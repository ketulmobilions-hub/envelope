-- =============================================================================
-- Migration: Add display_fx_rate to accounts
-- =============================================================================
-- Multi-currency support phase 2 (account-level FX).
--
-- Each account's `current_balance` stays in the account's own `currency`
-- (native). To present a consolidated net-worth or dashboard total in the
-- budget's base currency, every account needs a per-account conversion rate.
--
-- `display_fx_rate` is a manually-entered rate: 1 unit of `accounts.currency`
-- equals N units of `budgets.base_currency`. For accounts whose currency
-- already matches the budget base, the default 1.0 is correct and never
-- needs to be touched.
--
-- This rate is NOT used to convert transactions (that is handled by
-- `transactions.exchange_rate` per-transaction) — only for displaying a
-- single-currency aggregate of account balances.
-- =============================================================================

alter table public.accounts
  add column if not exists display_fx_rate real not null default 1.0;

-- Sanity: cannot be zero or negative.
alter table public.accounts
  drop constraint if exists accounts_display_fx_rate_positive;
alter table public.accounts
  add constraint accounts_display_fx_rate_positive
    check (display_fx_rate > 0);
