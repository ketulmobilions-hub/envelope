-- Bill reminders
create table public.bill_reminders (
  id uuid primary key default gen_random_uuid(),
  budget_id uuid not null references public.budgets(id) on delete cascade,
  name text not null,
  estimated_amount bigint not null,
  due_day integer not null,
  frequency text not null,
  envelope_id uuid references public.envelopes(id) on delete set null,
  reminder_days_before integer not null default 3,
  created_at timestamptz not null default now()
);

create index idx_bill_reminders_budget on public.bill_reminders(budget_id);
create index idx_bill_reminders_envelope on public.bill_reminders(envelope_id);

-- Goals
create table public.goals (
  id uuid primary key default gen_random_uuid(),
  budget_id uuid not null references public.budgets(id) on delete cascade,
  envelope_id uuid references public.envelopes(id) on delete set null,
  account_id uuid references public.accounts(id) on delete set null,
  type text not null,
  name text not null,
  target_amount bigint,
  target_date date,
  monthly_contribution bigint,
  current_amount bigint not null default 0,
  is_completed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_goals_budget on public.goals(budget_id);
create index idx_goals_envelope on public.goals(envelope_id);
create index idx_goals_account on public.goals(account_id);

create trigger goals_updated_at
  before update on public.goals
  for each row execute function public.set_updated_at();

-- Net worth snapshots
create table public.net_worth_snapshots (
  id uuid primary key default gen_random_uuid(),
  budget_id uuid not null references public.budgets(id) on delete cascade,
  date date not null,
  assets bigint not null,
  liabilities bigint not null,
  net_worth bigint not null,
  created_at timestamptz not null default now(),
  unique (budget_id, date)
);

create index idx_net_worth_snapshots_budget on public.net_worth_snapshots(budget_id);
