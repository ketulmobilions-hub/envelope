-- =============================================================================
-- Migration: Recalculate spent_amount on envelope_allocations via triggers
-- =============================================================================
-- Problem: When transactions are created/updated/deleted, the spent_amount on
-- envelope_allocations is never updated, causing stale "available" balances.
-- Solution: Postgres triggers on transactions and transaction_splits tables
-- that recalculate spent_amount whenever relevant changes occur.
-- =============================================================================

-- Helper function: recalculate spent_amount for a given envelope in the
-- budget period that contains a given date.
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
      and t.date between bp.start_date and bp.end_date
  ), 0) + coalesce((
    select sum(ts.amount::bigint)
    from public.transaction_splits ts
    join public.transactions t on t.id = ts.transaction_id
    join public.budget_periods bp on bp.id = ea.budget_period_id
    where ts.envelope_id = ea.envelope_id
      and t.type = 'expense'
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

-- Helper function: recalculate spent_amount for a given envelope from splits
-- in the budget period that contains a given date.
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

  -- For split transactions, the parent transaction has envelope_id = NULL.
  -- The splits carry the envelope assignments. We need to sum:
  -- 1. Direct (non-split) expense transactions for this envelope
  -- 2. Split amounts for expense transactions assigned to this envelope
  update public.envelope_allocations ea
  set spent_amount = coalesce((
    select sum(t.amount)
    from public.transactions t
    join public.budget_periods bp on bp.id = ea.budget_period_id
    where t.envelope_id = ea.envelope_id
      and t.type = 'expense'
      and t.date between bp.start_date and bp.end_date
  ), 0) + coalesce((
    select sum(ts.amount::bigint)
    from public.transaction_splits ts
    join public.transactions t on t.id = ts.transaction_id
    join public.budget_periods bp on bp.id = ea.budget_period_id
    where ts.envelope_id = ea.envelope_id
      and t.type = 'expense'
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

-- =============================================================================
-- Trigger function for transactions table
-- =============================================================================
create or replace function public.trg_recalculate_spent_amount()
returns trigger as $$
begin
  if tg_op = 'DELETE' then
    -- Only recalculate for expense transactions
    if old.type = 'expense' then
      perform public.recalculate_spent_for_envelope(
        old.envelope_id, old.budget_id, old.date
      );
    end if;
    return old;
  end if;

  if tg_op = 'INSERT' then
    if new.type = 'expense' then
      perform public.recalculate_spent_for_envelope(
        new.envelope_id, new.budget_id, new.date
      );
    end if;
    return new;
  end if;

  if tg_op = 'UPDATE' then
    -- Recalculate old allocation if envelope_id or date changed
    if old.type = 'expense' and (
      old.envelope_id is distinct from new.envelope_id
      or old.date is distinct from new.date
      or old.amount is distinct from new.amount
      or old.type is distinct from new.type
    ) then
      perform public.recalculate_spent_for_envelope(
        old.envelope_id, old.budget_id, old.date
      );
    end if;

    -- Recalculate new allocation
    if new.type = 'expense' then
      perform public.recalculate_spent_for_envelope(
        new.envelope_id, new.budget_id, new.date
      );
    end if;

    return new;
  end if;

  return null;
end;
$$ language plpgsql;

-- =============================================================================
-- Trigger function for transaction_splits table
-- =============================================================================
create or replace function public.trg_recalculate_split_spent_amount()
returns trigger as $$
begin
  if tg_op = 'DELETE' then
    perform public.recalculate_split_spent_for_envelope(
      old.envelope_id, old.transaction_id
    );
    return old;
  end if;

  if tg_op = 'INSERT' then
    perform public.recalculate_split_spent_for_envelope(
      new.envelope_id, new.transaction_id
    );
    return new;
  end if;

  if tg_op = 'UPDATE' then
    -- If envelope changed, recalculate both old and new
    if old.envelope_id is distinct from new.envelope_id then
      perform public.recalculate_split_spent_for_envelope(
        old.envelope_id, old.transaction_id
      );
    end if;
    perform public.recalculate_split_spent_for_envelope(
      new.envelope_id, new.transaction_id
    );
    return new;
  end if;

  return null;
end;
$$ language plpgsql;

-- =============================================================================
-- Create triggers
-- =============================================================================

-- Trigger on transactions table (fires AFTER to see committed data)
drop trigger if exists trg_transactions_spent_amount on public.transactions;
create trigger trg_transactions_spent_amount
  after insert or update or delete on public.transactions
  for each row execute function public.trg_recalculate_spent_amount();

-- Trigger on transaction_splits table
drop trigger if exists trg_splits_spent_amount on public.transaction_splits;
create trigger trg_splits_spent_amount
  after insert or update or delete on public.transaction_splits
  for each row execute function public.trg_recalculate_split_spent_amount();

-- =============================================================================
-- Backfill: recalculate all existing spent_amount values
-- =============================================================================

-- Direct (non-split) expense transactions
update public.envelope_allocations ea
set spent_amount = coalesce((
  select sum(t.amount)
  from public.transactions t
  join public.budget_periods bp on bp.id = ea.budget_period_id
  where t.envelope_id = ea.envelope_id
    and t.type = 'expense'
    and t.date between bp.start_date and bp.end_date
), 0) + coalesce((
  select sum(ts.amount::bigint)
  from public.transaction_splits ts
  join public.transactions t on t.id = ts.transaction_id
  join public.budget_periods bp on bp.id = ea.budget_period_id
  where ts.envelope_id = ea.envelope_id
    and t.type = 'expense'
    and t.date between bp.start_date and bp.end_date
), 0);
