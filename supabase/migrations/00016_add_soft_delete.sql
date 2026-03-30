-- Soft-delete support: add deleted_at column to key tables.
-- Rows with deleted_at IS NOT NULL are considered deleted but recoverable.
-- A scheduled job purges rows older than 30 days.

alter table public.transactions add column deleted_at timestamptz;
alter table public.envelopes add column deleted_at timestamptz;

create index idx_transactions_deleted on public.transactions(deleted_at)
  where deleted_at is not null;
create index idx_envelopes_deleted on public.envelopes(deleted_at)
  where deleted_at is not null;

-- Scheduled purge of soft-deleted rows older than 30 days.
select cron.schedule(
  'purge-soft-deleted',
  '0 3 * * *',
  $$
  delete from public.transactions where deleted_at < now() - interval '30 days';
  delete from public.envelopes where deleted_at < now() - interval '30 days';
  $$
);
