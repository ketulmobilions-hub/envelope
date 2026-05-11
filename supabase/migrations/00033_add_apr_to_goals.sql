-- Add APR + minimum payment fields to goals for debt_payoff schedule.
--
-- apr_bps          : annual percentage rate in basis points (1799 = 17.99%)
-- min_payment_cents: lender-required minimum monthly payment in cents
--
-- Both are nullable and only meaningful when goal.type = 'debt_payoff'.

ALTER TABLE public.goals
  ADD COLUMN apr_bps integer;

ALTER TABLE public.goals
  ADD COLUMN min_payment_cents bigint;
