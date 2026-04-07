-- =============================================================================
-- Migration: Upsert envelope_allocations when spending occurs
-- =============================================================================
-- Problem: When transactions are logged to an envelope that does not have an
-- existing allocation in the current budget period, the spent_amount trigger 
-- previously used an UPDATE statement, which affected 0 rows. Thus, spending
-- in unallocated envelopes was not tracked by the envelope_allocations table.
-- Solution: Change the recalculate functions to use an INSERT...ON CONFLICT 
-- (UPSERT) so that an allocation row is automatically created if one doesn't
-- exist, allowing the dashboard to properly indicate overspending (spent > 0).
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

  -- Calculate total spent_amount for the envelope within this period
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
  ), 0);

  insert into public.envelope_allocations (
    envelope_id, budget_period_id, spent_amount
  ) values (
    p_envelope_id, v_budget_period_id, v_spent
  ) on conflict (envelope_id, budget_period_id)
  do update set spent_amount = EXCLUDED.spent_amount;
end;
$$ language plpgsql;


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

  -- Calculate total spent_amount for the envelope from its splits
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
  ), 0);

  insert into public.envelope_allocations (
    envelope_id, budget_period_id, spent_amount
  ) values (
    p_envelope_id, v_budget_period_id, v_spent
  ) on conflict (envelope_id, budget_period_id)
  do update set spent_amount = EXCLUDED.spent_amount;
end;
$$ language plpgsql;

-- Apply backfill to catch any unallocated spending that was missed previously
insert into public.envelope_allocations (envelope_id, budget_period_id, spent_amount)
select sub.envelope_id, sub.budget_period_id, sub.spent
from (
  select
    e.id as envelope_id,
    bp.id as budget_period_id,
    (coalesce((
      select sum(t.amount)
      from public.transactions t
      where t.envelope_id = e.id
        and t.type = 'expense'
        and t.deleted_at is null
        and t.date between bp.start_date and bp.end_date
    ), 0) + coalesce((
      select sum(ts.amount::bigint)
      from public.transaction_splits ts
      join public.transactions t on t.id = ts.transaction_id
      where ts.envelope_id = e.id
        and t.type = 'expense'
        and t.deleted_at is null
        and t.date between bp.start_date and bp.end_date
    ), 0)) as spent
  from public.envelopes e
  cross join public.budget_periods bp
) sub
where sub.spent > 0
on conflict (envelope_id, budget_period_id)
do update set spent_amount = EXCLUDED.spent_amount;
