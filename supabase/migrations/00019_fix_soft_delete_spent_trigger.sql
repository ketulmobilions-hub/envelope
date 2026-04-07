-- =============================================================================
-- Fix: exclude soft-deleted transactions from spent_amount calculations
-- and fire the trigger when deleted_at changes.
-- =============================================================================

-- Updated helper: excludes soft-deleted transactions.
create or replace function public.recalculate_spent_for_envelope(
  p_envelope_id uuid,
  p_budget_id uuid,
  p_date date
) returns void as $$
begin
  if p_envelope_id is null then
    return;
  end if;

  update public.envelope_allocations ea
  set spent_amount = coalesce((
    select sum(t.amount)
    from public.transactions t
    join public.budget_periods bp on bp.id = ea.budget_period_id
    where t.envelope_id = ea.envelope_id
      and t.type = 'expense'
      and t.deleted_at is null
      and t.date between bp.start_date and bp.end_date
  ), 0) + coalesce((
    select sum(ts.amount::bigint)
    from public.transaction_splits ts
    join public.transactions t on t.id = ts.transaction_id
    join public.budget_periods bp on bp.id = ea.budget_period_id
    where ts.envelope_id = ea.envelope_id
      and t.type = 'expense'
      and t.deleted_at is null
      and t.date between bp.start_date and bp.end_date
  ), 0)
  where ea.envelope_id = p_envelope_id
    and ea.budget_period_id = (
      select bp.id
      from public.budget_periods bp
      where bp.budget_id = p_budget_id
        and p_date between bp.start_date and bp.end_date
      limit 1
    );
end;
$$ language plpgsql;

-- Updated helper for split transactions: excludes soft-deleted transactions.
create or replace function public.recalculate_split_spent_for_envelope(
  p_envelope_id uuid,
  p_transaction_id uuid
) returns void as $$
declare
  v_budget_id uuid;
  v_date date;
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

  update public.envelope_allocations ea
  set spent_amount = coalesce((
    select sum(t.amount)
    from public.transactions t
    join public.budget_periods bp on bp.id = ea.budget_period_id
    where t.envelope_id = ea.envelope_id
      and t.type = 'expense'
      and t.deleted_at is null
      and t.date between bp.start_date and bp.end_date
  ), 0) + coalesce((
    select sum(ts.amount::bigint)
    from public.transaction_splits ts
    join public.transactions t on t.id = ts.transaction_id
    join public.budget_periods bp on bp.id = ea.budget_period_id
    where ts.envelope_id = ea.envelope_id
      and t.type = 'expense'
      and t.deleted_at is null
      and t.date between bp.start_date and bp.end_date
  ), 0)
  where ea.envelope_id = p_envelope_id
    and ea.budget_period_id = (
      select bp.id
      from public.budget_periods bp
      where bp.budget_id = v_budget_id
        and v_date between bp.start_date and bp.end_date
      limit 1
    );
end;
$$ language plpgsql;

-- Updated trigger: also fires when deleted_at changes (soft delete/restore).
create or replace function public.trg_recalculate_spent_amount()
returns trigger as $$
begin
  if tg_op = 'DELETE' then
    if old.type = 'expense' then
      perform public.recalculate_spent_for_envelope(
        old.envelope_id, old.budget_id, old.date
      );
    end if;
    return old;
  end if;

  if tg_op = 'INSERT' then
    if new.type = 'expense' and new.deleted_at is null then
      perform public.recalculate_spent_for_envelope(
        new.envelope_id, new.budget_id, new.date
      );
    end if;
    return new;
  end if;

  if tg_op = 'UPDATE' then
    if old.type = 'expense' and (
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

    if new.type = 'expense' and new.deleted_at is null then
      perform public.recalculate_spent_for_envelope(
        new.envelope_id, new.budget_id, new.date
      );
    end if;

    return new;
  end if;

  return null;
end;
$$ language plpgsql;
