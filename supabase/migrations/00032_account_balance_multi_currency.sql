-- =============================================================================
-- Migration: Multi-currency account balance recalc
-- =============================================================================
-- Multi-currency support phase 4 (account balance + rounding parity).
--
-- Problem 1: `recalculate_account_balance` (00018) sums `transactions.amount`
-- raw, ignoring `currency` and `exchange_rate`. A USD invoice deposited to an
-- INR account adds 1200 (foreign cents) to `current_balance` instead of
-- 10140000 (₹1,01,400 cents). Phase 1 (00029) fixed envelope spent and period
-- income but left the account-balance trigger unconverted.
--
-- Problem 2: Phase 1 (00029) and the related split spent recalc cast directly
-- via `(amount * exchange_rate)::bigint`, which truncates toward zero. The
-- Dart client uses `.round()` (round-half-away-from-zero). On borderline
-- FX values client/server disagree by 1 cent.
--
-- Solution:
--   * Convert each transaction into account-native cents by dividing the
--     persisted base-currency amount by the account's `display_fx_rate`.
--     For accounts whose currency matches the budget base
--     (display_fx_rate = 1.0) the value equals `base_currency_amount`; for
--     non-base accounts the rate restores account-native cents. All math
--     is done in `numeric` to avoid `real`-precision drift and bigint
--     overflow at small rates.
--   * Replace `::bigint` truncating casts with `round(...)::bigint` in the
--     phase-1 trigger and the split spent recalcs so client and server
--     produce identical totals.
--
-- Scope notes:
--   * `current_balance` snapshot from the backfill is point-in-time at
--     migration apply. Future `display_fx_rate` edits trigger re-recalc
--     via the new accounts-side trigger added below.
--   * Migration is idempotent: function bodies are `create or replace`,
--     triggers are dropped+recreated, backfill is a single update that
--     yields the same value when re-run.
-- =============================================================================

-- Account balance recalc helper ---------------------------------------------

create or replace function public.recalculate_account_balance(
  p_account_id uuid
) returns void as $$
declare
  v_starting_balance bigint;
  v_display_fx_rate numeric;
begin
  if p_account_id is null then
    return;
  end if;

  select starting_balance, display_fx_rate::numeric
    into v_starting_balance, v_display_fx_rate
  from public.accounts
  where id = p_account_id;

  if v_starting_balance is null then
    return;
  end if;
  -- accounts_display_fx_rate_positive (00030) is the canonical guard.
  -- Silent return matches the early-return policy of other recalc helpers
  -- in this file and avoids aborting an INSERT/UPDATE on transactions if
  -- the constraint is ever loosened in a future migration. The backfill
  -- DO-loop below also depends on this returning silently — a raise here
  -- would abort the entire backfill on a single bad row.
  if v_display_fx_rate is null or v_display_fx_rate <= 0 then
    return;
  end if;

  update public.accounts
  set current_balance = v_starting_balance + coalesce((
    select sum(
      case
        when type = 'income'
          then round(base_currency_amount::numeric / v_display_fx_rate)::bigint
        when type = 'expense'
          then -round(base_currency_amount::numeric / v_display_fx_rate)::bigint
        when type = 'transfer'
          -- transfer base_currency_amount preserves sign (neg=out, pos=in).
          then round(base_currency_amount::numeric / v_display_fx_rate)::bigint
        else 0
      end
    )
    from public.transactions
    where account_id = p_account_id
      and type in ('income', 'expense', 'transfer')
      and deleted_at is null
  ), 0),
  updated_at = now()
  where id = p_account_id;
end;
$$ language plpgsql;

-- Trigger function on transactions: also fire when exchange_rate or
-- base_currency_amount change, not just amount.

create or replace function public.trg_recalculate_account_balance()
returns trigger as $$
begin
  if tg_op = 'DELETE' then
    if old.type in ('income', 'expense', 'transfer') then
      perform public.recalculate_account_balance(old.account_id);
    end if;
    return old;
  end if;

  if tg_op = 'INSERT' then
    if new.type in ('income', 'expense', 'transfer') then
      perform public.recalculate_account_balance(new.account_id);
    end if;
    return new;
  end if;

  if tg_op = 'UPDATE' then
    if old.account_id is distinct from new.account_id then
      if old.type in ('income', 'expense', 'transfer') then
        perform public.recalculate_account_balance(old.account_id);
      end if;
    end if;

    if new.type in ('income', 'expense', 'transfer') and (
      old.account_id is distinct from new.account_id
      or old.amount is distinct from new.amount
      or old.exchange_rate is distinct from new.exchange_rate
      or old.base_currency_amount is distinct from new.base_currency_amount
      or old.currency is distinct from new.currency
      or old.type is distinct from new.type
      or old.deleted_at is distinct from new.deleted_at
    ) then
      perform public.recalculate_account_balance(new.account_id);
    end if;

    return new;
  end if;

  return null;
end;
$$ language plpgsql;

-- New trigger on accounts.display_fx_rate so existing transactions are
-- re-summed at the new rate when the user edits FX.

create or replace function public.trg_recalculate_account_balance_on_fx()
returns trigger as $$
begin
  -- Recursion guard. recalculate_account_balance UPDATEs current_balance
  -- and updated_at on this same accounts row. The trigger DDL below is
  -- column-scoped to display_fx_rate, but Postgres still re-fires this
  -- function on EVERY row UPDATE that includes display_fx_rate in its
  -- target list — without this guard the inner update from
  -- recalculate_account_balance would re-enter at depth=2 and infinite
  -- loop in any future change that writes display_fx_rate alongside
  -- current_balance. Required for the schema as it stands.
  if pg_trigger_depth() > 1 then
    return new;
  end if;
  if old.display_fx_rate is distinct from new.display_fx_rate then
    perform public.recalculate_account_balance(new.id);
  end if;
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_accounts_display_fx_rate on public.accounts;
create trigger trg_accounts_display_fx_rate
  after update of display_fx_rate on public.accounts
  for each row execute function public.trg_recalculate_account_balance_on_fx();

-- Round-parity fixes for phase-1 functions -----------------------------------
-- Replace truncating `::bigint` casts with `round(...)::bigint` so client
-- (Dart `.round()`) and server stay byte-identical at borderline values.

create or replace function public.trg_set_base_currency_amount()
returns trigger as $$
begin
  new.base_currency_amount :=
    round((new.amount * new.exchange_rate)::numeric)::bigint;
  return new;
end;
$$ language plpgsql;

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
    select sum(round((ts.amount * t.exchange_rate)::numeric)::bigint)
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
    select sum(round((ts.amount * t.exchange_rate)::numeric)::bigint)
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

-- Re-derive base_currency_amount for any rows where the stored value
-- differs from the round-parity formula. Soft-deleted rows are also
-- corrected so a later restore surfaces the right base-currency amount.
-- The `is distinct from` predicate keeps the update bounded to rows that
-- actually need a change (idempotent re-runs are no-ops).
update public.transactions
  set base_currency_amount =
        round((amount * exchange_rate)::numeric)::bigint
  where base_currency_amount
        is distinct from round((amount * exchange_rate)::numeric)::bigint;

-- Per-account backfill loop. Avoids a single unbounded UPDATE that would
-- lock the accounts table on large tenants.
do $$
declare
  r record;
begin
  for r in
    select id from public.accounts
  loop
    perform public.recalculate_account_balance(r.id);
  end loop;
end;
$$;
