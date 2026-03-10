-- Category groups
create table public.category_groups (
  id uuid primary key default gen_random_uuid(),
  budget_id uuid not null references public.budgets(id) on delete cascade,
  name text not null,
  sort_order integer not null default 0,
  is_default boolean not null default false,
  is_archived boolean not null default false,
  created_at timestamptz not null default now()
);

create index idx_category_groups_budget on public.category_groups(budget_id);

-- Envelopes
create table public.envelopes (
  id uuid primary key default gen_random_uuid(),
  category_group_id uuid not null references public.category_groups(id) on delete cascade,
  budget_id uuid not null references public.budgets(id) on delete cascade,
  name text not null,
  sort_order integer not null default 0,
  is_archived boolean not null default false,
  created_at timestamptz not null default now()
);

create index idx_envelopes_budget on public.envelopes(budget_id);
create index idx_envelopes_category_group on public.envelopes(category_group_id);

-- Envelope allocations (per budget period)
create table public.envelope_allocations (
  id uuid primary key default gen_random_uuid(),
  envelope_id uuid not null references public.envelopes(id) on delete cascade,
  budget_period_id uuid not null references public.budget_periods(id) on delete cascade,
  allocated_amount bigint not null default 0,
  spent_amount bigint not null default 0,
  rollover_amount bigint not null default 0,
  created_at timestamptz not null default now(),
  unique (envelope_id, budget_period_id)
);

create index idx_envelope_allocations_envelope on public.envelope_allocations(envelope_id);
create index idx_envelope_allocations_period on public.envelope_allocations(budget_period_id);

-- Allocation templates
create table public.allocation_templates (
  id uuid primary key default gen_random_uuid(),
  budget_id uuid not null references public.budgets(id) on delete cascade,
  name text not null,
  created_at timestamptz not null default now()
);

create index idx_allocation_templates_budget on public.allocation_templates(budget_id);

-- Allocation template items
create table public.allocation_template_items (
  id uuid primary key default gen_random_uuid(),
  template_id uuid not null references public.allocation_templates(id) on delete cascade,
  envelope_id uuid not null references public.envelopes(id) on delete cascade,
  percentage real not null
);

create index idx_allocation_template_items_template on public.allocation_template_items(template_id);
