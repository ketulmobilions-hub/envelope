-- Email log for audit trail and deduplication of sent emails.
create table public.email_log (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.users(id) on delete cascade,
  recipient_email text not null,
  email_type text not null check (email_type in ('invitation', 'bill_reminder', 'weekly_summary')),
  reference_id text not null,
  status text not null default 'sent' check (status in ('sent', 'failed')),
  error_message text,
  created_at timestamptz not null default now()
);

create index idx_email_log_user on public.email_log(user_id);
create unique index idx_email_log_dedup on public.email_log(email_type, reference_id);
create index idx_email_log_created on public.email_log(created_at);

-- RLS: users can read their own email history; inserts via service_role only.
alter table public.email_log enable row level security;

create policy "Users can view own email log"
  on public.email_log for select
  using (auth.uid() = user_id);

-- Add weekly_summary preference column to notification_preferences.
alter table public.notification_preferences
  add column weekly_summary boolean not null default true;

-- pg_cron and pg_net for scheduled email triggers.
-- NOTE: pg_cron and pg_net must be enabled in Supabase Dashboard > Database > Extensions.
-- The cron jobs below use Vault secrets. Before applying, store these secrets:
--   SELECT vault.create_secret('<your-supabase-url>', 'supabase_url');
--   SELECT vault.create_secret('<your-service-role-key>', 'service_role_key');
create extension if not exists pg_cron;
create extension if not exists pg_net;

-- Daily bill reminder emails at 8:00 AM UTC.
select cron.schedule(
  'daily-bill-reminder-emails',
  '0 8 * * *',
  $$
  select net.http_post(
    url := (select decrypted_secret from vault.decrypted_secrets where name = 'supabase_url') || '/functions/v1/send-bill-reminder-email',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'service_role_key')
    ),
    body := '{}'::jsonb
  );
  $$
);

-- Weekly budget summary emails every Monday at 8:00 AM UTC.
select cron.schedule(
  'weekly-summary-emails',
  '0 8 * * 1',
  $$
  select net.http_post(
    url := (select decrypted_secret from vault.decrypted_secrets where name = 'supabase_url') || '/functions/v1/send-weekly-summary-email',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'service_role_key')
    ),
    body := '{}'::jsonb
  );
  $$
);
