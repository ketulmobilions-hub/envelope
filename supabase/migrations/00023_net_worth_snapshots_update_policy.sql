-- Add missing UPDATE policy for net_worth_snapshots.
-- Required so that upsert (INSERT ... ON CONFLICT DO UPDATE) can overwrite
-- an existing snapshot for the same (budget_id, date) without hitting RLS.
create policy "Members can update net worth snapshots"
  on public.net_worth_snapshots for update
  using (public.is_budget_member(budget_id))
  with check (public.is_budget_member(budget_id));
