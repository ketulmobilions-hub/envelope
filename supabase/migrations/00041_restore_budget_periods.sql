-- Restore budget_periods after revert of #82.
--
-- Recreates the `budget_periods` table (with `carried_rta` from 00037),
-- restores per-period columns on `envelope_allocations`
-- (`budget_period_id`, `spent_amount`, `rollover_amount`), reinstates the
-- spent-amount trigger functions and RLS policies, and removes the
-- `account_seed_balance` column added by the dropped 00041_remove migration.
--
-- All existing `envelope_allocations` rows are discarded — they were the
-- collapsed global-per-envelope rows from the #82 schema and have no period
-- to attach to. The app re-seeds allocations as periods come into use.

begin;

-- 1. Recreate budget_periods.
create table if not exists public.budget_periods (
  id uuid primary key default gen_random_uuid(),
  budget_id uuid not null references public.budgets(id) on delete cascade,
  start_date date not null,
  end_date date not null,
  total_income bigint not null default 0,
  total_allocated bigint not null default 0,
  is_closed boolean not null default false,
  carried_rta bigint not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (budget_id, start_date)
);

create index if not exists idx_budget_periods_budget
  on public.budget_periods(budget_id);

drop trigger if exists budget_periods_updated_at on public.budget_periods;
create trigger budget_periods_updated_at
  before update on public.budget_periods
  for each row execute function public.set_updated_at();

comment on column public.budget_periods.carried_rta is
  'Signed Ready-to-Assign carried forward from the previous period. '
  'Negative values indicate over-assignment or uncovered overspend.';

alter table public.budget_periods enable row level security;

drop policy if exists "Members can read budget periods" on public.budget_periods;
create policy "Members can read budget periods"
  on public.budget_periods for select
  using (public.is_budget_member(budget_id));

drop policy if exists "Members can manage budget periods" on public.budget_periods;
create policy "Members can manage budget periods"
  on public.budget_periods for insert
  with check (public.is_budget_member(budget_id));

drop policy if exists "Members can update budget periods" on public.budget_periods;
create policy "Members can update budget periods"
  on public.budget_periods for update
  using (public.is_budget_member(budget_id));

-- 2. Recreate envelope_allocations with the pre-#82 column set.
drop table if exists public.envelope_allocations cascade;
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

create index idx_envelope_allocations_envelope
  on public.envelope_allocations(envelope_id);
create index idx_envelope_allocations_period
  on public.envelope_allocations(budget_period_id);

alter table public.envelope_allocations enable row level security;

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

-- 3. Restore spent-amount helper + trigger functions
--    (latest pre-#82 versions: 00020 upsert + 00019 soft-delete exclusion).
create or replace function public.recalculate_spent_for_envelope(
  p_envelope_id uuid,
  p_budget_id uuid,
  p_date date
) returns void as $$
declare
  v_budget_period_id uuid;
  v_spent bigint;
begin
  if p_envelope_id is null then
    return;
  end if;

  select id into v_budget_period_id
  from public.budget_periods
  where budget_id = p_budget_id
    and p_date between start_date and end_date
  limit 1;

  if v_budget_period_id is null then
    return;
  end if;

  v_spent := coalesce((
    select sum(t.amount)
    from public.transactions t
    join public.budget_periods bp on bp.id = v_budget_period_id
    where t.envelope_id = p_envelope_id
      and t.type = 'expense'
      and t.deleted_at is null
      and t.date between bp.start_date and bp.end_date
  ), 0) + coalesce((
    select sum(ts.amount::bigint)
    from public.transaction_splits ts
    join public.transactions t on t.id = ts.transaction_id
    join public.budget_periods bp on bp.id = v_budget_period_id
    where ts.envelope_id = p_envelope_id
      and t.type = 'expense'
      and t.deleted_at is null
      and t.date between bp.start_date and bp.end_date
  ), 0);

  insert into public.envelope_allocations (
    envelope_id, budget_period_id, spent_amount
  ) values (
    p_envelope_id, v_budget_period_id, v_spent
  ) on conflict (envelope_id, budget_period_id)
  do update set spent_amount = EXCLUDED.spent_amount;
end;
$$ language plpgsql;

create or replace function public.recalculate_split_spent_for_envelope(
  p_envelope_id uuid,
  p_transaction_id uuid
) returns void as $$
declare
  v_budget_id uuid;
  v_date date;
  v_budget_period_id uuid;
  v_spent bigint;
begin
  if p_envelope_id is null then
    return;
  end if;

  select t.budget_id, t.date
  into v_budget_id, v_date
  from public.transactions t
  where t.id = p_transaction_id;

  if v_budget_id is null then
    return;
  end if;

  select id into v_budget_period_id
  from public.budget_periods
  where budget_id = v_budget_id
    and v_date between start_date and end_date
  limit 1;

  if v_budget_period_id is null then
    return;
  end if;

  v_spent := coalesce((
    select sum(t.amount)
    from public.transactions t
    join public.budget_periods bp on bp.id = v_budget_period_id
    where t.envelope_id = p_envelope_id
      and t.type = 'expense'
      and t.deleted_at is null
      and t.date between bp.start_date and bp.end_date
  ), 0) + coalesce((
    select sum(ts.amount::bigint)
    from public.transaction_splits ts
    join public.transactions t on t.id = ts.transaction_id
    join public.budget_periods bp on bp.id = v_budget_period_id
    where ts.envelope_id = p_envelope_id
      and t.type = 'expense'
      and t.deleted_at is null
      and t.date between bp.start_date and bp.end_date
  ), 0);

  insert into public.envelope_allocations (
    envelope_id, budget_period_id, spent_amount
  ) values (
    p_envelope_id, v_budget_period_id, v_spent
  ) on conflict (envelope_id, budget_period_id)
  do update set spent_amount = EXCLUDED.spent_amount;
end;
$$ language plpgsql;

create or replace function public.trg_recalculate_spent_amount()
returns trigger as $$
begin
  if tg_op = 'DELETE' then
    if old.type = 'expense' then
      perform public.recalculate_spent_for_envelope(
        old.envelope_id, old.budget_id, old.date
      );
    end if;
    return old;
  end if;

  if tg_op = 'INSERT' then
    if new.type = 'expense' and new.deleted_at is null then
      perform public.recalculate_spent_for_envelope(
        new.envelope_id, new.budget_id, new.date
      );
    end if;
    return new;
  end if;

  if tg_op = 'UPDATE' then
    if old.type = 'expense' and (
      old.envelope_id is distinct from new.envelope_id
      or old.date is distinct from new.date
      or old.amount is distinct from new.amount
      or old.type is distinct from new.type
      or old.deleted_at is distinct from new.deleted_at
    ) then
      perform public.recalculate_spent_for_envelope(
        old.envelope_id, old.budget_id, old.date
      );
    end if;

    if new.type = 'expense' and new.deleted_at is null then
      perform public.recalculate_spent_for_envelope(
        new.envelope_id, new.budget_id, new.date
      );
    end if;

    return new;
  end if;

  return null;
end;
$$ language plpgsql;

create or replace function public.trg_recalculate_split_spent_amount()
returns trigger as $$
begin
  if tg_op = 'DELETE' then
    perform public.recalculate_split_spent_for_envelope(
      old.envelope_id, old.transaction_id
    );
    return old;
  end if;

  if tg_op = 'INSERT' then
    perform public.recalculate_split_spent_for_envelope(
      new.envelope_id, new.transaction_id
    );
    return new;
  end if;

  if tg_op = 'UPDATE' then
    if old.envelope_id is distinct from new.envelope_id then
      perform public.recalculate_split_spent_for_envelope(
        old.envelope_id, old.transaction_id
      );
    end if;
    perform public.recalculate_split_spent_for_envelope(
      new.envelope_id, new.transaction_id
    );
    return new;
  end if;

  return null;
end;
$$ language plpgsql;

drop trigger if exists trg_transactions_spent_amount on public.transactions;
create trigger trg_transactions_spent_amount
  after insert or update or delete on public.transactions
  for each row execute function public.trg_recalculate_spent_amount();

drop trigger if exists trg_splits_spent_amount on public.transaction_splits;
create trigger trg_splits_spent_amount
  after insert or update or delete on public.transaction_splits
  for each row execute function public.trg_recalculate_split_spent_amount();

-- 4. Drop the post-#82 budgets.account_seed_balance column.
alter table public.budgets drop column if exists account_seed_balance;

-- 5. Restore realtime publication for envelope_allocations and budget_periods.
--    (00024 added these; dropping/recreating the table breaks the publication.)
do $$
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    begin
      execute 'alter publication supabase_realtime add table public.budget_periods';
    exception when duplicate_object then null;
    end;
    begin
      execute 'alter publication supabase_realtime add table public.envelope_allocations';
    exception when duplicate_object then null;
    end;
  end if;
end $$;

commit;
