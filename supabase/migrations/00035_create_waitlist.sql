-- Marketing waitlist signups.
--
-- Public-facing landing page POSTs to this table via the Supabase REST API
-- using the anon key. Anonymous inserts are allowed; reads/updates/deletes
-- are blocked for anon and only accessible via service_role from admin tools.

create table public.waitlist (
  id uuid primary key default gen_random_uuid(),
  email text not null,
  source text,
  user_agent text,
  created_at timestamptz not null default now()
);

-- Case-insensitive uniqueness on email.
create unique index idx_waitlist_email_lower on public.waitlist (lower(email));
create index idx_waitlist_created_at on public.waitlist (created_at desc);

alter table public.waitlist enable row level security;

create policy "Anyone can join the waitlist"
  on public.waitlist for insert
  to anon, authenticated
  with check (
    email is not null
    and length(email) <= 320
    and email ~* '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$'
  );
