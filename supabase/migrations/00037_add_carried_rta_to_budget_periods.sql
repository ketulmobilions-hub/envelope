-- Adds carried-forward Ready-to-Assign to budget periods (YNAB-style).
--
-- Holds the signed RTA carried from the previous period:
--   carried_rta = (prev.total_income + prev.carried_rta - sum(prev.allocated))
--                 - sum(prev uncovered overspend)
-- Can be negative (over-assignment or uncovered cash overspend), which surfaces
-- a negative Ready-to-Assign so the user is forced to rebalance.
-- bigint to match the sibling money columns total_income / total_allocated
-- (minor units); carried_rta is derived from them and must not truncate.
alter table budget_periods
  add column carried_rta bigint not null default 0;

comment on column budget_periods.carried_rta is
  'Signed Ready-to-Assign carried forward from the previous period. '
  'Negative values indicate over-assignment or uncovered overspend.';
