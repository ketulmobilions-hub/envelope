create table public.push_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  token text not null,
  platform text not null check (platform in ('android', 'ios', 'web')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, token)
);
create index idx_push_tokens_user on public.push_tokens(user_id);

-- Auto-update updated_at on row modification.
create or replace function public.push_tokens_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger trg_push_tokens_updated_at
  before update on public.push_tokens
  for each row execute function public.push_tokens_updated_at();

-- Enable RLS.
alter table public.push_tokens enable row level security;

create policy "Users can read own push tokens"
  on public.push_tokens for select
  using (user_id = auth.uid());

create policy "Users can insert own push tokens"
  on public.push_tokens for insert
  with check (user_id = auth.uid());

create policy "Users can update own push tokens"
  on public.push_tokens for update
  using (user_id = auth.uid());

create policy "Users can delete own push tokens"
  on public.push_tokens for delete
  using (user_id = auth.uid());
