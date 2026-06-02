-- =============================================================================
-- Migration: Add exchange_rate to recurring_rules
-- =============================================================================
-- Multi-currency support phase 3.
--
-- A recurring rule snapshots the user's currency + FX choice at create-time.
-- When the rule fires (RecurringCheckCubit._autoPostRule), the generated
-- transaction needs to inherit the snapshot rate so its base_currency_amount
-- is computed correctly. Today the rule has `currency` but no exchange_rate,
-- so foreign-currency rules generate transactions at rate=1.0 (incorrect).
-- =============================================================================

alter table public.recurring_rules
  add column if not exists exchange_rate real not null default 1.0;

alter table public.recurring_rules
  drop constraint if exists recurring_rules_exchange_rate_positive;
alter table public.recurring_rules
  add constraint recurring_rules_exchange_rate_positive
    check (exchange_rate > 0);
