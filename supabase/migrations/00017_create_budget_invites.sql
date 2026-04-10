-- Server-side budget invites for secure invite link generation.
create table public.budget_invites (
  id uuid primary key default gen_random_uuid(),
  budget_id uuid not null references public.budgets(id) on delete cascade,
  role text not null default 'viewer',
  created_by uuid not null references public.users(id) on delete cascade,
  expires_at timestamptz not null default (now() + interval '7 days'),
  redeemed_at timestamptz,
  redeemed_by uuid references public.users(id),
  created_at timestamptz not null default now()
);

create index idx_budget_invites_budget on public.budget_invites(budget_id);
create index idx_budget_invites_created_by on public.budget_invites(created_by);

-- RLS: budget owners and editors can manage invites for their budgets.
alter table public.budget_invites enable row level security;

create policy "Budget members can view invites"
  on public.budget_invites for select
  using (
    budget_id in (
      select b.id from public.budgets b where b.owner_id = auth.uid()
      union
      select bm.budget_id from public.budget_members bm
        where bm.user_id = auth.uid() and bm.role in ('owner', 'editor')
    )
  );

create policy "Budget owners and editors can create invites"
  on public.budget_invites for insert
  with check (
    created_by = auth.uid()
    and budget_id in (
      select b.id from public.budgets b where b.owner_id = auth.uid()
      union
      select bm.budget_id from public.budget_members bm
        where bm.user_id = auth.uid() and bm.role in ('owner', 'editor')
    )
  );

create policy "Invite creators can delete their invites"
  on public.budget_invites for delete
  using (created_by = auth.uid());
