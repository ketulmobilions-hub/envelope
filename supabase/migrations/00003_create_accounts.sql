-- Accounts
create table public.accounts (
  id uuid primary key default gen_random_uuid(),
  budget_id uuid not null references public.budgets(id) on delete cascade,
  name text not null,
  type text not null,
  starting_balance bigint not null,
  current_balance bigint not null,
  currency text not null,
  is_archived boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_accounts_budget on public.accounts(budget_id);

create trigger accounts_updated_at
  before update on public.accounts
  for each row execute function public.set_updated_at();

-- Debt accounts (1-to-1 extension of accounts)
create table public.debt_accounts (
  account_id uuid primary key references public.accounts(id) on delete cascade,
  interest_rate real not null,
  minimum_payment bigint not null,
  original_balance bigint not null,
  payoff_strategy text
);
