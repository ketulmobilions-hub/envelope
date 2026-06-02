-- Issue #82: Drop budget periods entirely. RTA and envelope allocations go
-- global. Monthly views in Reports are re-derived from transaction dates on
-- demand instead of from period FKs.
--
-- Migration strategy:
--   1. Add `account_seed_balance` column to budgets. This holds the cached
--      sum of on-budget account starting balances and is the part of seed
--      cash refreshOpeningBalanceForBudget continues to keep in sync as
--      accounts are edited. `opening_balance` retains the pre-existing
--      manual seed PLUS the historical per-period total_income folded in
--      below — refreshOpeningBalanceForBudget no longer touches it, so the
--      migrated income cannot be silently zeroed by a future account edit.
--   2. Fold all per-period total_income into budgets.opening_balance.
--   3. Collapse envelope_allocations rows: one row per envelope_id, with
--      allocated_amount = SUM(allocated_amount) across all periods. Drop
--      the period FK and the spent_amount / rollover_amount columns.
--   4. Drop budget_periods table entirely.
--
-- After this migration, the new RTA formula is:
--   RTA = SUM(income transactions) + budgets.opening_balance
--       + budgets.account_seed_balance
--       - SUM(envelope_allocations.allocated_amount)
--
-- Idempotency: the migration's data steps are gated on `budget_periods`
-- still existing. A repeat application after the table is dropped becomes a
-- no-op, so re-running cannot double-count the income fold.

begin;

-- 1. Add the account_seed_balance column ahead of any work that depends on it.
alter table budgets
  add column if not exists account_seed_balance bigint not null default 0;

do $$
begin
  if to_regclass('public.budget_periods') is null then
    -- Migration already applied; nothing to fold or collapse.
    return;
  end if;

  -- 2a. Snapshot the current sum of on-budget account starting balances into
  --     account_seed_balance so opening_balance can be reserved purely for the
  --     legacy seed + folded historical income.
  with seed as (
    select budget_id,
           coalesce(sum(greatest(starting_balance, 0)), 0) as seed_total
      from accounts
     where is_on_budget = true
       and is_archived = false
     group by budget_id
  )
  update budgets b
     set account_seed_balance = s.seed_total,
         updated_at           = now()
    from seed s
   where b.id = s.budget_id;

  -- 2b. Fold per-period income onto budgets.opening_balance.
  --     The remote calculateReadyToAssign formula was:
  --       period.total_income + opening_contribution + carried_rta - allocated
  --     After this migration, opening_balance subsumes all of those revenue
  --     contributions, so the global formula stays mathematically equivalent
  --     for the budget's cumulative balance.
  with income_rollup as (
    select budget_id, sum(total_income) as total_income
      from budget_periods
     group by budget_id
  )
  update budgets b
     set opening_balance = b.opening_balance + ir.total_income,
         updated_at      = now()
    from income_rollup ir
   where b.id = ir.budget_id
     and ir.total_income > 0;

  -- 3. Collapse envelope_allocations into one row per envelope_id.
  create table envelope_allocations_new (
    id               uuid primary key,
    envelope_id      uuid not null unique,
    allocated_amount bigint not null default 0,
    created_at       timestamptz not null default now()
  );

  insert into envelope_allocations_new (id, envelope_id, allocated_amount, created_at)
    select gen_random_uuid(),
           envelope_id,
           sum(allocated_amount),
           min(created_at)
      from envelope_allocations
     group by envelope_id;

  drop table envelope_allocations;
  alter table envelope_allocations_new rename to envelope_allocations;

  -- 4. Drop budget_periods table.
  drop table budget_periods;
end $$;

commit;

comment on column budgets.account_seed_balance is
  'Cached sum of on-budget account starting balances (clamped at zero). '
  'Refreshed by the client whenever an account is added, edited, archived, '
  'or deleted. Distinct from opening_balance so the legacy seed and '
  'pre-#82 historical income folded into opening_balance survive account '
  'edits without being overwritten.';

comment on column budgets.opening_balance is
  'Legacy seed cash plus historical period total_income migrated in by '
  '00041. Set during onboarding and never overwritten by the periodic '
  'account-balance refresh. Folds directly into Ready-to-Assign alongside '
  'account_seed_balance.';

comment on table envelope_allocations is
  'Global per-envelope allocation. One row per envelope_id. allocated_amount '
  'is the running total assigned to this envelope across all time. Spent '
  'amounts are derived from transactions on demand.';
