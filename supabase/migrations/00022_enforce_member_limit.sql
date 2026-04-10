-- Helper function: count all members for a budget (pending + accepted).
create or replace function public.budget_member_count(budget_uuid uuid)
returns integer
language sql security definer set search_path = ''
stable as $$
  select count(*)::integer from public.budget_members where budget_id = budget_uuid;
$$;

-- Update INSERT policy to block inserts when free plan limit is reached.
drop policy "Owners can manage budget members" on public.budget_members;
create policy "Owners can manage budget members"
  on public.budget_members for insert
  with check (
    public.is_budget_owner(budget_id)
    and public.budget_member_count(budget_id) < 2
  );
