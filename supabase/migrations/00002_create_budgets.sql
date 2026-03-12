-- Budgets
create table public.budgets (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.users(id) on delete cascade,
  name text not null,
  base_currency text not null default 'USD',
  period_type text not null default 'monthly',
  period_start_day integer not null default 1,
  is_archived boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_budgets_owner on public.budgets(owner_id);

create trigger budgets_updated_at
  before update on public.budgets
  for each row execute function public.set_updated_at();

-- Budget members (sharing)
create table public.budget_members (
  id uuid primary key default gen_random_uuid(),
  budget_id uuid not null references public.budgets(id) on delete cascade,
  user_id uuid not null references public.users(id) on delete cascade,
  role text not null default 'viewer',
  invited_via text not null,
  accepted_at timestamptz,
  created_at timestamptz not null default now(),
  unique (budget_id, user_id)
);

create index idx_budget_members_budget on public.budget_members(budget_id);
create index idx_budget_members_user on public.budget_members(user_id);

-- Budget periods
create table public.budget_periods (
  id uuid primary key default gen_random_uuid(),
  budget_id uuid not null references public.budgets(id) on delete cascade,
  start_date date not null,
  end_date date not null,
  total_income bigint not null default 0,
  total_allocated bigint not null default 0,
  is_closed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (budget_id, start_date)
);

create index idx_budget_periods_budget on public.budget_periods(budget_id);

create trigger budget_periods_updated_at
  before update on public.budget_periods
  for each row execute function public.set_updated_at();
