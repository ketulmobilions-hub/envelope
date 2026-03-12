-- Notification preferences
create table public.notification_preferences (
  user_id uuid primary key references public.users(id) on delete cascade,
  push_enabled boolean not null default true,
  email_enabled boolean not null default true,
  overspend_alerts boolean not null default true,
  bill_reminders boolean not null default true,
  daily_logging_reminder boolean not null default true,
  recurring_transaction_alerts boolean not null default true,
  shared_budget_activity boolean not null default true
);

-- Activity log (audit trail for shared budgets)
create table public.activity_log (
  id uuid primary key default gen_random_uuid(),
  budget_id uuid not null references public.budgets(id) on delete cascade,
  user_id uuid not null references public.users(id),
  action text not null,
  entity_type text not null,
  entity_id text not null,
  details text,
  created_at timestamptz not null default now()
);

create index idx_activity_log_budget on public.activity_log(budget_id);
create index idx_activity_log_created on public.activity_log(created_at);

-- Sync metadata (offline-first multi-device support)
create table public.sync_metadata (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  table_name text not null,
  record_id text not null,
  last_modified timestamptz not null default now(),
  is_deleted boolean not null default false,
  device_id text not null,
  sync_status text not null default 'pending',
  unique (table_name, record_id, device_id)
);

create index idx_sync_metadata_user on public.sync_metadata(user_id);
create index idx_sync_metadata_status on public.sync_metadata(sync_status) where sync_status = 'pending';
create index idx_sync_metadata_table_record on public.sync_metadata(table_name, record_id);
