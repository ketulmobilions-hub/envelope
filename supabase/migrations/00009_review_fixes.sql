-- Fix migration: applies all review fixes to an existing database
-- Run this if you already applied migrations 00001-00008

-- Fix #1: transaction_splits.amount should be real, not bigint
alter table public.transaction_splits
  alter column amount type real;

-- Fix #2: set_updated_at() needs security definer + search_path
create or replace function public.set_updated_at()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- Fix #3: sync_metadata needs user_id column for proper RLS
alter table public.sync_metadata
  add column if not exists user_id uuid not null references public.users(id) on delete cascade default '00000000-0000-0000-0000-000000000000';

-- Remove the broken default after adding the column
alter table public.sync_metadata
  alter column user_id drop default;

create index if not exists idx_sync_metadata_user on public.sync_metadata(user_id);

-- Drop all existing sync_metadata policies (old + any from partial runs)
drop policy if exists "Users can read own sync metadata" on public.sync_metadata;
drop policy if exists "Users can manage sync metadata" on public.sync_metadata;
drop policy if exists "Users can update sync metadata" on public.sync_metadata;
drop policy if exists "Users can create own sync metadata" on public.sync_metadata;
drop policy if exists "Users can update own sync metadata" on public.sync_metadata;
drop policy if exists "Users can delete own sync metadata" on public.sync_metadata;

-- Create proper sync_metadata policies
create policy "Users can read own sync metadata"
  on public.sync_metadata for select
  using (user_id = auth.uid());

create policy "Users can create own sync metadata"
  on public.sync_metadata for insert
  with check (user_id = auth.uid());

create policy "Users can update own sync metadata"
  on public.sync_metadata for update
  using (user_id = auth.uid());

create policy "Users can delete own sync metadata"
  on public.sync_metadata for delete
  using (user_id = auth.uid());

-- Fix #4: RLS helpers need set search_path = ''
create or replace function public.is_budget_member(budget_uuid uuid)
returns boolean
language sql
security definer set search_path = ''
stable
as $$
  select exists (
    select 1 from public.budgets
    where id = budget_uuid and owner_id = auth.uid()
    union all
    select 1 from public.budget_members
    where budget_id = budget_uuid
      and user_id = auth.uid()
      and accepted_at is not null
  );
$$;

create or replace function public.is_budget_owner(budget_uuid uuid)
returns boolean
language sql
security definer set search_path = ''
stable
as $$
  select exists (
    select 1 from public.budgets
    where id = budget_uuid and owner_id = auth.uid()
  );
$$;

-- Fix: budgets SELECT policy - inline check instead of function call
-- Avoids security definer + RLS interaction issue with return=representation
drop policy if exists "Users can read own and shared budgets" on public.budgets;
create policy "Users can read own and shared budgets"
  on public.budgets for select
  using (
    owner_id = auth.uid()
    or id in (
      select budget_id from public.budget_members
      where user_id = auth.uid() and accepted_at is not null
    )
  );

-- Fix #5: budget_members.invited_via should be NOT NULL
-- (only run if you have no existing rows with null invited_via)
update public.budget_members set invited_via = 'email' where invited_via is null;
alter table public.budget_members alter column invited_via set not null;

-- Fix #11: budget_periods needs updated_at for sync
alter table public.budget_periods
  add column if not exists updated_at timestamptz not null default now();

drop trigger if exists budget_periods_updated_at on public.budget_periods;
create trigger budget_periods_updated_at
  before update on public.budget_periods
  for each row execute function public.set_updated_at();

-- Fix #12: Users INSERT policy
drop policy if exists "Users can insert own profile" on public.users;
create policy "Users can insert own profile"
  on public.users for insert
  with check (id = auth.uid());

-- Fix #13: Members can leave shared budgets
drop policy if exists "Members can leave a shared budget" on public.budget_members;
create policy "Members can leave a shared budget"
  on public.budget_members for delete
  using (user_id = auth.uid());

-- Fix #14-17: Missing indexes
create index if not exists idx_transactions_recurring_rule on public.transactions(recurring_rule_id) where recurring_rule_id is not null;
create index if not exists idx_transactions_created_by on public.transactions(created_by);
create index if not exists idx_goals_envelope on public.goals(envelope_id);
create index if not exists idx_goals_account on public.goals(account_id);
create index if not exists idx_bill_reminders_envelope on public.bill_reminders(envelope_id);

-- Fix #20: notification_preferences DELETE policy
drop policy if exists "Users can delete own notification preferences" on public.notification_preferences;
create policy "Users can delete own notification preferences"
  on public.notification_preferences for delete
  using (user_id = auth.uid());

-- Fix #21: envelope_allocations DELETE policy
drop policy if exists "Members can delete allocations" on public.envelope_allocations;
create policy "Members can delete allocations"
  on public.envelope_allocations for delete
  using (public.is_budget_member(
    (select budget_id from public.envelopes where id = envelope_id)
  ));

-- Fix #6-10: Remove unnecessary SQL defaults (Drift always provides values)
-- These are harmless but we align for consistency
alter table public.accounts alter column starting_balance drop default;
alter table public.accounts alter column current_balance drop default;
alter table public.debt_accounts alter column interest_rate drop default;
alter table public.debt_accounts alter column minimum_payment drop default;
alter table public.debt_accounts alter column original_balance drop default;
alter table public.allocation_template_items alter column percentage drop default;
alter table public.net_worth_snapshots alter column assets drop default;
alter table public.net_worth_snapshots alter column liabilities drop default;
alter table public.net_worth_snapshots alter column net_worth drop default;
