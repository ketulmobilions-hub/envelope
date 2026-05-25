-- Transaction templates
-- Saved blueprints for one-tap pre-fill of the add-transaction sheet.
-- Distinct from recurring_rules (no schedule) and allocation_templates
-- (which scope to budget allocation, not transactions).

create table public.transaction_templates (
  id uuid primary key default gen_random_uuid(),
  budget_id uuid not null references public.budgets(id) on delete cascade,
  name text not null,
  type text not null check (type in ('expense', 'income')),
  account_id uuid references public.accounts(id) on delete set null,
  envelope_id uuid references public.envelopes(id) on delete set null,
  amount_cents bigint,
  payee text,
  notes text,
  currency text,
  tag_ids_json text,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index idx_transaction_templates_budget
  on public.transaction_templates(budget_id);

drop trigger if exists set_transaction_templates_updated_at
  on public.transaction_templates;
create trigger set_transaction_templates_updated_at
  before update on public.transaction_templates
  for each row execute function public.set_updated_at();

alter table public.transaction_templates replica identity full;

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'transaction_templates'
  ) then
    alter publication supabase_realtime add table public.transaction_templates;
  end if;
end $$;

alter table public.transaction_templates enable row level security;

create policy "Members can read transaction_templates"
  on public.transaction_templates for select
  using (public.is_budget_member(budget_id));

create policy "Members can create transaction_templates"
  on public.transaction_templates for insert
  with check (public.is_budget_member(budget_id));

create policy "Members can update transaction_templates"
  on public.transaction_templates for update
  using (public.is_budget_member(budget_id));

create policy "Members can delete transaction_templates"
  on public.transaction_templates for delete
  using (public.is_budget_member(budget_id));
