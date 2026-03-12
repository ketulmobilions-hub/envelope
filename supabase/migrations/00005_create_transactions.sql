-- Tags
create table public.tags (
  id uuid primary key default gen_random_uuid(),
  budget_id uuid not null references public.budgets(id) on delete cascade,
  name text not null,
  unique (budget_id, name)
);

create index idx_tags_budget on public.tags(budget_id);

-- Recurring rules (created before transactions since transactions reference them)
create table public.recurring_rules (
  id uuid primary key default gen_random_uuid(),
  budget_id uuid not null references public.budgets(id) on delete cascade,
  account_id uuid not null references public.accounts(id) on delete cascade,
  envelope_id uuid references public.envelopes(id) on delete set null,
  type text not null,
  amount bigint not null,
  currency text not null default 'USD',
  payee text,
  notes text,
  frequency text not null,
  custom_interval integer,
  custom_unit text,
  start_date date not null,
  end_date date,
  next_occurrence date not null,
  auto_post boolean not null default false,
  is_paused boolean not null default false,
  created_at timestamptz not null default now()
);

create index idx_recurring_rules_budget on public.recurring_rules(budget_id);
create index idx_recurring_rules_next on public.recurring_rules(next_occurrence) where not is_paused;

-- Transactions
create table public.transactions (
  id uuid primary key default gen_random_uuid(),
  budget_id uuid not null references public.budgets(id) on delete cascade,
  account_id uuid not null references public.accounts(id) on delete cascade,
  envelope_id uuid references public.envelopes(id) on delete set null,
  type text not null,
  amount bigint not null,
  currency text not null default 'USD',
  exchange_rate real not null default 1.0,
  payee text,
  notes text,
  date date not null,
  is_reconciled boolean not null default false,
  recurring_rule_id uuid references public.recurring_rules(id) on delete set null,
  transfer_pair_id uuid,
  created_by uuid not null references public.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_transactions_budget on public.transactions(budget_id);
create index idx_transactions_account on public.transactions(account_id);
create index idx_transactions_envelope on public.transactions(envelope_id);
create index idx_transactions_date on public.transactions(date);
create index idx_transactions_transfer on public.transactions(transfer_pair_id) where transfer_pair_id is not null;
create index idx_transactions_recurring_rule on public.transactions(recurring_rule_id) where recurring_rule_id is not null;
create index idx_transactions_created_by on public.transactions(created_by);

create trigger transactions_updated_at
  before update on public.transactions
  for each row execute function public.set_updated_at();

-- Transaction splits (multi-envelope)
create table public.transaction_splits (
  id uuid primary key default gen_random_uuid(),
  transaction_id uuid not null references public.transactions(id) on delete cascade,
  envelope_id uuid not null references public.envelopes(id) on delete cascade,
  amount real not null
);

create index idx_transaction_splits_transaction on public.transaction_splits(transaction_id);

-- Transaction tags (many-to-many)
create table public.transaction_tags (
  transaction_id uuid not null references public.transactions(id) on delete cascade,
  tag_id uuid not null references public.tags(id) on delete cascade,
  primary key (transaction_id, tag_id)
);
