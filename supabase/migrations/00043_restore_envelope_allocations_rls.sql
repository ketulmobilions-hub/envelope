-- Issue #82 follow-up: 00041 replaced envelope_allocations via a
-- create-tmp-table → drop → rename swap. RLS settings and policies live on
-- the table, not the columns, so they were lost in the swap. Re-enable RLS
-- and recreate the four membership-gated policies originally shipped in
-- 00008. Idempotent: drop policy if exists + create.

begin;

alter table public.envelope_allocations enable row level security;

drop policy if exists "Members can read allocations"
  on public.envelope_allocations;
drop policy if exists "Members can create allocations"
  on public.envelope_allocations;
drop policy if exists "Members can update allocations"
  on public.envelope_allocations;
drop policy if exists "Members can delete allocations"
  on public.envelope_allocations;

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

commit;
