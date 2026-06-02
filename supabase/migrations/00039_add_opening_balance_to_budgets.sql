-- Adds period-agnostic seed cash to budgets (issue #80).
--
-- Previously the sum of on-budget account starting balances was written to
-- the onboarding month's `budget_periods.total_income`, trapping the seed
-- inside that month. Backdated transactions in earlier periods then saw
-- Ready-to-Assign = 0 because the auto-created earlier period had no
-- income, deadlocking the user (cannot fix overspend without RTA).
--
-- The seed now lives on the budget as `opening_balance`, anchored on
-- `opening_date`. Application logic (added in a follow-up PR) will add
-- `opening_balance` to RTA in the period that contains `opening_date` and
-- propagate it forward via `carried_rta`. Backfilling an earlier period
-- shifts `opening_date`.
--
-- Backfill of existing budgets (moving seed cash off the earliest period's
-- `total_income`) is intentionally deferred. It will ship as a paired
-- migration alongside the RTA-logic PR so existing users do not see an
-- interim RTA regression between the schema bump and the consumer landing.
--
-- bigint to match the other money columns (minor units / cents).
alter table budgets
  add column opening_balance bigint not null default 0;

alter table budgets
  add column opening_date timestamptz;

comment on column budgets.opening_balance is
  'Seed cash in minor units. Initial value is the sum of on-budget account '
  'starting balances at onboarding. Added to Ready-to-Assign in the period '
  'that contains opening_date and propagates forward via carried_rta.';

comment on column budgets.opening_date is
  'Date the opening balance is anchored to. Shifts earlier when an earlier '
  'period is backfilled.';
