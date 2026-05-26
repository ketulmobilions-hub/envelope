-- =============================================================================
-- Migration: categorize transfers to off-budget accounts
-- =============================================================================
-- A transfer OUT to an off-budget account (e.g. checking -> fixed deposit)
-- leaves the budget and must reduce an envelope's available, like an expense.
-- The client sets `envelope_id` on the outgoing leg (negative amount, type
-- 'transfer') of such a transfer. The spent calculation then counts those legs.
--
-- The trigger/recalc do NOT need to know about on/off-budget: a transfer-out
-- leg only carries an `envelope_id` when the client classified it as on->off,
-- and `recalculate_spent_for_envelope` early-returns on a null envelope. So
-- on<->on transfers (no envelope_id) contribute nothing.
--
-- The inverse (off->on, raising Ready to Assign) is intentionally out of scope
-- here: it needs delete-time income reversal in the transactions bloc, so it is
-- deferred to a follow-up.
-- =============================================================================

create or replace function public.recalculate_spent_for_envelope(
  p_envelope_id uuid,
  p_budget_id uuid,
  p_date date
) returns void as $$
declare
  v_budget_period_id uuid;
  v_spent bigint;
begin
  if p_envelope_id is null then
    return;
  end if;

  select id into v_budget_period_id
  from public.budget_periods
  where budget_id = p_budget_id
    and p_date between start_date and end_date
  limit 1;

  if v_budget_period_id is null then
    return;
  end if;

  v_spent := coalesce((
    select sum(t.amount)
    from public.transactions t
    join public.budget_periods bp on bp.id = v_budget_period_id
    where t.envelope_id = p_envelope_id
      and t.type = 'expense'
      and t.deleted_at is null
      and t.date between bp.start_date and bp.end_date
  ), 0) + coalesce((
    select sum(ts.amount::bigint)
    from public.transaction_splits ts
    join public.transactions t on t.id = ts.transaction_id
    join public.budget_periods bp on bp.id = v_budget_period_id
    where ts.envelope_id = p_envelope_id
      and t.type = 'expense'
      and t.deleted_at is null
      and t.date between bp.start_date and bp.end_date
  ), 0) + coalesce((
    -- Categorized transfer OUT to an off-budget account. The outgoing leg has
    -- a negative amount, so negate it to add a positive spend.
    select sum(-t.amount)
    from public.transactions t
    join public.budget_periods bp on bp.id = v_budget_period_id
    where t.envelope_id = p_envelope_id
      and t.type = 'transfer'
      and t.amount < 0
      and t.deleted_at is null
      and t.date between bp.start_date and bp.end_date
  ), 0);

  insert into public.envelope_allocations (
    envelope_id, budget_period_id, spent_amount
  ) values (
    p_envelope_id, v_budget_period_id, v_spent
  ) on conflict (envelope_id, budget_period_id)
  do update set spent_amount = EXCLUDED.spent_amount;
end;
$$ language plpgsql;

-- Fire the recalc for categorized transfer-out legs as well as expenses.
-- A transfer-out leg is identified by `type = 'transfer' and amount < 0`;
-- when it carries no envelope_id (on<->on transfer) the recalc no-ops.
create or replace function public.trg_recalculate_spent_amount()
returns trigger as $$
begin
  if tg_op = 'DELETE' then
    if old.type = 'expense'
       or (old.type = 'transfer' and old.amount < 0) then
      perform public.recalculate_spent_for_envelope(
        old.envelope_id, old.budget_id, old.date
      );
    end if;
    return old;
  end if;

  if tg_op = 'INSERT' then
    if (new.type = 'expense'
        or (new.type = 'transfer' and new.amount < 0))
       and new.deleted_at is null then
      perform public.recalculate_spent_for_envelope(
        new.envelope_id, new.budget_id, new.date
      );
    end if;
    return new;
  end if;

  if tg_op = 'UPDATE' then
    if (old.type = 'expense'
        or (old.type = 'transfer' and old.amount < 0))
       and (
         old.envelope_id is distinct from new.envelope_id
         or old.date is distinct from new.date
         or old.amount is distinct from new.amount
         or old.type is distinct from new.type
         or old.deleted_at is distinct from new.deleted_at
       ) then
      perform public.recalculate_spent_for_envelope(
        old.envelope_id, old.budget_id, old.date
      );
    end if;

    if (new.type = 'expense'
        or (new.type = 'transfer' and new.amount < 0))
       and new.deleted_at is null then
      perform public.recalculate_spent_for_envelope(
        new.envelope_id, new.budget_id, new.date
      );
    end if;

    return new;
  end if;

  return null;
end;
$$ language plpgsql;

-- Keep the split-driven recalc consistent with recalculate_spent_for_envelope:
-- it recomputes the envelope's FULL spent and overwrites it, so it must also
-- include categorized transfer-out legs, or split activity on the same envelope
-- would clobber the transfer spend.
create or replace function public.recalculate_split_spent_for_envelope(
  p_envelope_id uuid,
  p_transaction_id uuid
) returns void as $$
declare
  v_budget_id uuid;
  v_date date;
  v_budget_period_id uuid;
  v_spent bigint;
begin
  if p_envelope_id is null then
    return;
  end if;

  select t.budget_id, t.date
  into v_budget_id, v_date
  from public.transactions t
  where t.id = p_transaction_id;

  if v_budget_id is null then
    return;
  end if;

  select id into v_budget_period_id
  from public.budget_periods
  where budget_id = v_budget_id
    and v_date between start_date and end_date
  limit 1;

  if v_budget_period_id is null then
    return;
  end if;

  v_spent := coalesce((
    select sum(t.amount)
    from public.transactions t
    join public.budget_periods bp on bp.id = v_budget_period_id
    where t.envelope_id = p_envelope_id
      and t.type = 'expense'
      and t.deleted_at is null
      and t.date between bp.start_date and bp.end_date
  ), 0) + coalesce((
    select sum(ts.amount::bigint)
    from public.transaction_splits ts
    join public.transactions t on t.id = ts.transaction_id
    join public.budget_periods bp on bp.id = v_budget_period_id
    where ts.envelope_id = p_envelope_id
      and t.type = 'expense'
      and t.deleted_at is null
      and t.date between bp.start_date and bp.end_date
  ), 0) + coalesce((
    select sum(-t.amount)
    from public.transactions t
    join public.budget_periods bp on bp.id = v_budget_period_id
    where t.envelope_id = p_envelope_id
      and t.type = 'transfer'
      and t.amount < 0
      and t.deleted_at is null
      and t.date between bp.start_date and bp.end_date
  ), 0);

  insert into public.envelope_allocations (
    envelope_id, budget_period_id, spent_amount
  ) values (
    p_envelope_id, v_budget_period_id, v_spent
  ) on conflict (envelope_id, budget_period_id)
  do update set spent_amount = EXCLUDED.spent_amount;
end;
$$ language plpgsql;
