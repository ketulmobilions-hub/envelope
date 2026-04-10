----------------------------------------
-- GOAL CONTRIBUTIONS
----------------------------------------
create table if not exists public.goal_contributions (
  id uuid primary key default gen_random_uuid(),
  goal_id uuid not null references public.goals(id) on delete cascade,
  amount_cents integer not null,
  note text,
  created_at timestamptz not null default now()
);

alter table public.goal_contributions enable row level security;

create policy "Members can read goal contributions"
  on public.goal_contributions for select
  using (
    exists (
      select 1 from public.goals g
      where g.id = goal_id
        and public.is_budget_member(g.budget_id)
    )
  );

create policy "Members can create goal contributions"
  on public.goal_contributions for insert
  with check (
    exists (
      select 1 from public.goals g
      where g.id = goal_id
        and public.is_budget_member(g.budget_id)
    )
  );

create policy "Members can delete goal contributions"
  on public.goal_contributions for delete
  using (
    exists (
      select 1 from public.goals g
      where g.id = goal_id
        and public.is_budget_member(g.budget_id)
    )
  );
