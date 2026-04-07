-- =============================================================================
-- Migration: Recalculate current_balance on accounts via triggers
-- =============================================================================
-- Problem: When transactions are created/updated/deleted, the current_balance on
-- accounts is never updated, causing stale balances in the UI.
-- Solution: Postgres triggers on the transactions table that recalculate
-- current_balance whenever income, expense, or transfer transactions change.
-- Transfer amounts are stored as signed values (negative = outgoing).
-- Pattern mirrors migration 00012 (spent_amount trigger).
-- =============================================================================

-- Helper function: recalculate current_balance for a given account.
create or replace function public.recalculate_account_balance(
  p_account_id uuid
) returns void as $$
declare
  v_starting_balance bigint;
begin
  if p_account_id is null then
    return;
  end if;

  select starting_balance into v_starting_balance
  from public.accounts
  where id = p_account_id;

  if v_starting_balance is null then
    return;
  end if;

  update public.accounts
  set current_balance = v_starting_balance + coalesce((
    select sum(
      case
        when type = 'income' then amount
        when type = 'expense' then -amount
        when type = 'transfer' then amount  -- stored signed: negative=out, positive=in
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

-- =============================================================================
-- Trigger function for transactions table
-- =============================================================================
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
    -- Recalculate old account if account changed
    if old.account_id is distinct from new.account_id then
      if old.type in ('income', 'expense', 'transfer') then
        perform public.recalculate_account_balance(old.account_id);
      end if;
    end if;

    -- Recalculate new account if any relevant field changed
    if new.type in ('income', 'expense', 'transfer') and (
      old.account_id is distinct from new.account_id
      or old.amount is distinct from new.amount
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

-- =============================================================================
-- Create trigger
-- =============================================================================
drop trigger if exists trg_transactions_account_balance on public.transactions;
create trigger trg_transactions_account_balance
  after insert or update or delete on public.transactions
  for each row execute function public.trg_recalculate_account_balance();

-- =============================================================================
-- Backfill: recalculate current_balance for all existing accounts
-- =============================================================================
update public.accounts a
set current_balance = a.starting_balance + coalesce((
  select sum(
    case
      when t.type = 'income' then t.amount
      when t.type = 'expense' then -t.amount
      when t.type = 'transfer' then t.amount
      else 0
    end
  )
  from public.transactions t
  where t.account_id = a.id
    and t.type in ('income', 'expense', 'transfer')
    and t.deleted_at is null
), 0),
updated_at = now();
