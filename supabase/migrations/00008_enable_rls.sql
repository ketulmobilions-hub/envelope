-- Enable RLS on all tables
alter table public.users enable row level security;
alter table public.budgets enable row level security;
alter table public.budget_members enable row level security;
alter table public.budget_periods enable row level security;
alter table public.accounts enable row level security;
alter table public.debt_accounts enable row level security;
alter table public.category_groups enable row level security;
alter table public.envelopes enable row level security;
alter table public.envelope_allocations enable row level security;
alter table public.allocation_templates enable row level security;
alter table public.allocation_template_items enable row level security;
alter table public.tags enable row level security;
alter table public.recurring_rules enable row level security;
alter table public.transactions enable row level security;
alter table public.transaction_splits enable row level security;
alter table public.transaction_tags enable row level security;
alter table public.bill_reminders enable row level security;
alter table public.goals enable row level security;
alter table public.net_worth_snapshots enable row level security;
alter table public.notification_preferences enable row level security;
alter table public.activity_log enable row level security;
alter table public.sync_metadata enable row level security;

-- Helper: check if user is a member (owner or shared) of a budget
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

-- Helper: check if user is the budget owner
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

---------------------------------------
-- USERS
---------------------------------------
create policy "Users can read own profile"
  on public.users for select
  using (id = auth.uid());

create policy "Users can insert own profile"
  on public.users for insert
  with check (id = auth.uid());

create policy "Users can update own profile"
  on public.users for update
  using (id = auth.uid());

---------------------------------------
-- BUDGETS
---------------------------------------
create policy "Users can read own and shared budgets"
  on public.budgets for select
  using (
    owner_id = auth.uid()
    or id in (
      select budget_id from public.budget_members
      where user_id = auth.uid() and accepted_at is not null
    )
  );

create policy "Users can create budgets"
  on public.budgets for insert
  with check (owner_id = auth.uid());

create policy "Owners can update budgets"
  on public.budgets for update
  using (owner_id = auth.uid());

create policy "Owners can delete budgets"
  on public.budgets for delete
  using (owner_id = auth.uid());

---------------------------------------
-- BUDGET MEMBERS
---------------------------------------
create policy "Members can read budget members"
  on public.budget_members for select
  using (public.is_budget_member(budget_id));

create policy "Owners can manage budget members"
  on public.budget_members for insert
  with check (public.is_budget_owner(budget_id));

create policy "Owners can update budget members"
  on public.budget_members for update
  using (public.is_budget_owner(budget_id));

create policy "Owners can remove budget members"
  on public.budget_members for delete
  using (public.is_budget_owner(budget_id));

create policy "Members can leave a shared budget"
  on public.budget_members for delete
  using (user_id = auth.uid());

---------------------------------------
-- BUDGET PERIODS
---------------------------------------
create policy "Members can read budget periods"
  on public.budget_periods for select
  using (public.is_budget_member(budget_id));

create policy "Members can manage budget periods"
  on public.budget_periods for insert
  with check (public.is_budget_member(budget_id));

create policy "Members can update budget periods"
  on public.budget_periods for update
  using (public.is_budget_member(budget_id));

---------------------------------------
-- ACCOUNTS
---------------------------------------
create policy "Members can read accounts"
  on public.accounts for select
  using (public.is_budget_member(budget_id));

create policy "Members can create accounts"
  on public.accounts for insert
  with check (public.is_budget_member(budget_id));

create policy "Members can update accounts"
  on public.accounts for update
  using (public.is_budget_member(budget_id));

create policy "Owners can delete accounts"
  on public.accounts for delete
  using (public.is_budget_owner(budget_id));

---------------------------------------
-- DEBT ACCOUNTS
---------------------------------------
create policy "Members can read debt accounts"
  on public.debt_accounts for select
  using (public.is_budget_member(
    (select budget_id from public.accounts where id = account_id)
  ));

create policy "Members can manage debt accounts"
  on public.debt_accounts for insert
  with check (public.is_budget_member(
    (select budget_id from public.accounts where id = account_id)
  ));

create policy "Members can update debt accounts"
  on public.debt_accounts for update
  using (public.is_budget_member(
    (select budget_id from public.accounts where id = account_id)
  ));

create policy "Owners can delete debt accounts"
  on public.debt_accounts for delete
  using (public.is_budget_owner(
    (select budget_id from public.accounts where id = account_id)
  ));

---------------------------------------
-- CATEGORY GROUPS
---------------------------------------
create policy "Members can read category groups"
  on public.category_groups for select
  using (public.is_budget_member(budget_id));

create policy "Members can create category groups"
  on public.category_groups for insert
  with check (public.is_budget_member(budget_id));

create policy "Members can update category groups"
  on public.category_groups for update
  using (public.is_budget_member(budget_id));

create policy "Owners can delete category groups"
  on public.category_groups for delete
  using (public.is_budget_owner(budget_id));

---------------------------------------
-- ENVELOPES
---------------------------------------
create policy "Members can read envelopes"
  on public.envelopes for select
  using (public.is_budget_member(budget_id));

create policy "Members can create envelopes"
  on public.envelopes for insert
  with check (public.is_budget_member(budget_id));

create policy "Members can update envelopes"
  on public.envelopes for update
  using (public.is_budget_member(budget_id));

create policy "Owners can delete envelopes"
  on public.envelopes for delete
  using (public.is_budget_owner(budget_id));

---------------------------------------
-- ENVELOPE ALLOCATIONS
---------------------------------------
create policy "Members can read allocations"
  on public.envelope_allocations for select
  using (public.is_budget_member(
    (select budget_id from public.envelopes where id = envelope_id)
  ));

create policy "Members can create allocations"
  on public.envelope_allocations for insert
  with check (public.is_budget_member(
    (select budget_id from public.envelopes where id = envelope_id)
  ));

create policy "Members can update allocations"
  on public.envelope_allocations for update
  using (public.is_budget_member(
    (select budget_id from public.envelopes where id = envelope_id)
  ));

create policy "Members can delete allocations"
  on public.envelope_allocations for delete
  using (public.is_budget_member(
    (select budget_id from public.envelopes where id = envelope_id)
  ));

---------------------------------------
-- ALLOCATION TEMPLATES
---------------------------------------
create policy "Members can read templates"
  on public.allocation_templates for select
  using (public.is_budget_member(budget_id));

create policy "Members can create templates"
  on public.allocation_templates for insert
  with check (public.is_budget_member(budget_id));

create policy "Members can update templates"
  on public.allocation_templates for update
  using (public.is_budget_member(budget_id));

create policy "Members can delete templates"
  on public.allocation_templates for delete
  using (public.is_budget_member(budget_id));

---------------------------------------
-- ALLOCATION TEMPLATE ITEMS
---------------------------------------
create policy "Members can read template items"
  on public.allocation_template_items for select
  using (public.is_budget_member(
    (select budget_id from public.allocation_templates where id = template_id)
  ));

create policy "Members can manage template items"
  on public.allocation_template_items for insert
  with check (public.is_budget_member(
    (select budget_id from public.allocation_templates where id = template_id)
  ));

create policy "Members can update template items"
  on public.allocation_template_items for update
  using (public.is_budget_member(
    (select budget_id from public.allocation_templates where id = template_id)
  ));

create policy "Members can delete template items"
  on public.allocation_template_items for delete
  using (public.is_budget_member(
    (select budget_id from public.allocation_templates where id = template_id)
  ));

---------------------------------------
-- TAGS
---------------------------------------
create policy "Members can read tags"
  on public.tags for select
  using (public.is_budget_member(budget_id));

create policy "Members can create tags"
  on public.tags for insert
  with check (public.is_budget_member(budget_id));

create policy "Members can update tags"
  on public.tags for update
  using (public.is_budget_member(budget_id));

create policy "Members can delete tags"
  on public.tags for delete
  using (public.is_budget_member(budget_id));

---------------------------------------
-- RECURRING RULES
---------------------------------------
create policy "Members can read recurring rules"
  on public.recurring_rules for select
  using (public.is_budget_member(budget_id));

create policy "Members can create recurring rules"
  on public.recurring_rules for insert
  with check (public.is_budget_member(budget_id));

create policy "Members can update recurring rules"
  on public.recurring_rules for update
  using (public.is_budget_member(budget_id));

create policy "Members can delete recurring rules"
  on public.recurring_rules for delete
  using (public.is_budget_member(budget_id));

---------------------------------------
-- TRANSACTIONS
---------------------------------------
create policy "Members can read transactions"
  on public.transactions for select
  using (public.is_budget_member(budget_id));

create policy "Members can create transactions"
  on public.transactions for insert
  with check (public.is_budget_member(budget_id));

create policy "Members can update transactions"
  on public.transactions for update
  using (public.is_budget_member(budget_id));

create policy "Members can delete transactions"
  on public.transactions for delete
  using (public.is_budget_member(budget_id));

---------------------------------------
-- TRANSACTION SPLITS
---------------------------------------
create policy "Members can read splits"
  on public.transaction_splits for select
  using (public.is_budget_member(
    (select budget_id from public.transactions where id = transaction_id)
  ));

create policy "Members can create splits"
  on public.transaction_splits for insert
  with check (public.is_budget_member(
    (select budget_id from public.transactions where id = transaction_id)
  ));

create policy "Members can update splits"
  on public.transaction_splits for update
  using (public.is_budget_member(
    (select budget_id from public.transactions where id = transaction_id)
  ));

create policy "Members can delete splits"
  on public.transaction_splits for delete
  using (public.is_budget_member(
    (select budget_id from public.transactions where id = transaction_id)
  ));

---------------------------------------
-- TRANSACTION TAGS
---------------------------------------
create policy "Members can read transaction tags"
  on public.transaction_tags for select
  using (public.is_budget_member(
    (select budget_id from public.transactions where id = transaction_id)
  ));

create policy "Members can manage transaction tags"
  on public.transaction_tags for insert
  with check (public.is_budget_member(
    (select budget_id from public.transactions where id = transaction_id)
  ));

create policy "Members can delete transaction tags"
  on public.transaction_tags for delete
  using (public.is_budget_member(
    (select budget_id from public.transactions where id = transaction_id)
  ));

---------------------------------------
-- BILL REMINDERS
---------------------------------------
create policy "Members can read bill reminders"
  on public.bill_reminders for select
  using (public.is_budget_member(budget_id));

create policy "Members can create bill reminders"
  on public.bill_reminders for insert
  with check (public.is_budget_member(budget_id));

create policy "Members can update bill reminders"
  on public.bill_reminders for update
  using (public.is_budget_member(budget_id));

create policy "Members can delete bill reminders"
  on public.bill_reminders for delete
  using (public.is_budget_member(budget_id));

---------------------------------------
-- GOALS
---------------------------------------
create policy "Members can read goals"
  on public.goals for select
  using (public.is_budget_member(budget_id));

create policy "Members can create goals"
  on public.goals for insert
  with check (public.is_budget_member(budget_id));

create policy "Members can update goals"
  on public.goals for update
  using (public.is_budget_member(budget_id));

create policy "Members can delete goals"
  on public.goals for delete
  using (public.is_budget_member(budget_id));

---------------------------------------
-- NET WORTH SNAPSHOTS
---------------------------------------
create policy "Members can read net worth snapshots"
  on public.net_worth_snapshots for select
  using (public.is_budget_member(budget_id));

create policy "Members can create net worth snapshots"
  on public.net_worth_snapshots for insert
  with check (public.is_budget_member(budget_id));

---------------------------------------
-- NOTIFICATION PREFERENCES
---------------------------------------
create policy "Users can read own notification preferences"
  on public.notification_preferences for select
  using (user_id = auth.uid());

create policy "Users can create own notification preferences"
  on public.notification_preferences for insert
  with check (user_id = auth.uid());

create policy "Users can update own notification preferences"
  on public.notification_preferences for update
  using (user_id = auth.uid());

create policy "Users can delete own notification preferences"
  on public.notification_preferences for delete
  using (user_id = auth.uid());

---------------------------------------
-- ACTIVITY LOG
---------------------------------------
create policy "Members can read activity log"
  on public.activity_log for select
  using (public.is_budget_member(budget_id));

create policy "Members can create activity log entries"
  on public.activity_log for insert
  with check (public.is_budget_member(budget_id));

---------------------------------------
-- SYNC METADATA
---------------------------------------
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
