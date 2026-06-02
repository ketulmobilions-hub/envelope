-- Issue #82 follow-up: drop server-side spent_amount triggers and their
-- helper functions. They were left behind by 00041 and reference the
-- now-dropped `budget_periods` table plus the removed
-- `envelope_allocations.spent_amount` column, so any transaction insert
-- raises `relation "public.budget_periods" does not exist`.
--
-- Under the global model, "spent" is derived from transactions on demand
-- (TransactionsDao.sumExpensesByEnvelopeId folds in transaction_splits via
-- JOIN). No server-side aggregate is needed.

begin;

-- 1. Triggers on the source tables.
drop trigger if exists trg_transactions_spent_amount on public.transactions;
drop trigger if exists trg_splits_spent_amount on public.transaction_splits;

-- 2. Trigger entry-point functions.
drop function if exists public.trg_recalculate_spent_amount();
drop function if exists public.trg_recalculate_split_spent_amount();

-- 3. Helper recompute functions. Signatures are stable across 00012/00019/
--    00020/00038.
drop function if exists public.recalculate_spent_for_envelope(uuid, uuid, date);
drop function if exists public.recalculate_split_spent_for_envelope(uuid, uuid);

commit;
