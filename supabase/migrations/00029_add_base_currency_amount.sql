-- =============================================================================
-- Migration: Add base_currency_amount to transactions
-- =============================================================================
-- Multi-currency support phase 1 (data foundation).
--
-- Problem: All envelope/budget aggregations sum the raw `amount` column
-- regardless of `currency` and `exchange_rate`. A USD invoice on an INR budget
-- contributes 1200 (cents of foreign currency) to RTA instead of 10140000
-- (₹1,01,400). Reports/RTA/spent are nonsensical for multi-currency budgets.
--
-- Solution: Persist a derived `base_currency_amount` column equal to
-- `(amount * exchange_rate)::bigint`. A trigger keeps it in sync on insert
-- and update. All envelope-spent and period-income aggregations are switched
-- to sum `base_currency_amount` so totals are always expressed in the
-- budget's base currency.
--
-- Account balance (`accounts.current_balance`) is intentionally NOT migrated;
-- it remains in the account's native currency. Net worth conversion is the
-- responsibility of phase 2 via `accounts.display_fx_rate`.
-- =============================================================================

-- Column + backfill ----------------------------------------------------------

alter table public.transactions
  add column if not exists base_currency_amount bigint not null default 0;

update public.transactions
  set base_currency_amount = (amount * exchange_rate)::bigint
  where base_currency_amount = 0;

-- Trigger function -----------------------------------------------------------

create or replace function public.trg_set_base_currency_amount()
returns trigger as $$
begin
  new.base_currency_amount := (new.amount * new.exchange_rate)::bigint;
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_transactions_base_currency_amount
  on public.transactions;
create trigger trg_transactions_base_currency_amount
  before insert or update of amount, exchange_rate on public.transactions
  for each row execute function public.trg_set_base_currency_amount();

-- Switch envelope spent recalc to use base_currency_amount -------------------

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
    select sum(t.base_currency_amount)
    from public.transactions t
    join public.budget_periods bp on bp.id = v_budget_period_id
    where t.envelope_id = p_envelope_id
      and t.type = 'expense'
      and t.deleted_at is null
      and t.date between bp.start_date and bp.end_date
  ), 0) + coalesce((
    -- transaction_splits.amount stays in the parent transaction's currency,
    -- so multiply by the parent transaction's exchange_rate.
    select sum((ts.amount * t.exchange_rate)::bigint)
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

  v_spent := coalesce((
    select sum(t.base_currency_amount)
    from public.transactions t
    join public.budget_periods bp on bp.id = v_budget_period_id
    where t.envelope_id = p_envelope_id
      and t.type = 'expense'
      and t.deleted_at is null
      and t.date between bp.start_date and bp.end_date
  ), 0) + coalesce((
    select sum((ts.amount * t.exchange_rate)::bigint)
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

-- Backfill existing envelope_allocations.spent_amount with converted totals --

insert into public.envelope_allocations (
  envelope_id, budget_period_id, spent_amount
)
select sub.envelope_id, sub.budget_period_id, sub.spent
from (
  select
    e.id as envelope_id,
    bp.id as budget_period_id,
    (coalesce((
      select sum(t.base_currency_amount)
      from public.transactions t
      where t.envelope_id = e.id
        and t.type = 'expense'
        and t.deleted_at is null
        and t.date between bp.start_date and bp.end_date
    ), 0) + coalesce((
      select sum((ts.amount * t.exchange_rate)::bigint)
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
on conflict (envelope_id, budget_period_id)
do update set spent_amount = EXCLUDED.spent_amount;
