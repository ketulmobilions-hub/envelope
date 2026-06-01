-- Paired data backfill for issue #80, phase 7.
--
-- Phase 1 (migration 00039) added `budgets.opening_balance` /
-- `budgets.opening_date` with default 0 / NULL. Phase 2's onboarding rewire
-- writes those fields for NEW budgets. This migration moves the seed cash for
-- EXISTING budgets (created before phase 2) from the onboarding period's
-- `total_income` onto the budget row so the phase-3 RTA logic finds it.
--
-- Per-period RTA invariant:
--   pre-mig:  RTA(earliest) = earliest.total_income + carried(0) - allocated
--                           = seed + 0 - allocated
--   post-mig: RTA(earliest) = earliest.total_income(0)
--                           + opening_contribution(seed)
--                           + carried(0) - allocated
--                           = seed - allocated
-- → identical. Downstream periods read the SAME signedPrev(earliest) =
-- (income + opening + carried - allocated), so their stored carriedRta needs
-- no recompute. The cascade is invariant under this swap.
--
-- Selection rule: only touch budgets that are CLEARLY pre-phase-2 — i.e. they
-- still have the defaults (opening_balance = 0 AND opening_date IS NULL) and
-- their earliest budget_period has total_income > 0. Phase-2 onboarding always
-- writes opening_date when seed cash is non-zero, so this gate cannot misfire
-- on a phase-2 budget.

begin;

with earliest_per_budget as (
  select distinct on (budget_id)
    budget_id,
    id           as period_id,
    start_date,
    total_income
  from budget_periods
  order by budget_id, start_date asc
),
to_migrate as (
  select b.id           as budget_id,
         e.period_id    as period_id,
         e.start_date   as anchor_date,
         e.total_income as seed
  from budgets b
  join earliest_per_budget e on e.budget_id = b.id
  where b.opening_balance = 0
    and b.opening_date is null
    and e.total_income > 0
),
budget_update as (
  update budgets b
     set opening_balance = tm.seed,
         opening_date    = tm.anchor_date,
         updated_at      = now()
    from to_migrate tm
   where b.id = tm.budget_id
   returning b.id, tm.period_id
)
update budget_periods bp
   set total_income = 0
  from budget_update bu
 where bp.id = bu.period_id;

commit;

comment on column budgets.opening_balance is
  'Seed cash in minor units. Initial value is the sum of on-budget account '
  'starting balances at onboarding. Added to Ready-to-Assign in the period '
  'that contains opening_date and propagates forward via carried_rta. '
  'Migration 00040 backfilled this from the earliest period total_income for '
  'pre-phase-2 budgets.';
