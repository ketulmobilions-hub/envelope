-- Enable Realtime for all tables that the app subscribes to.
-- REPLICA IDENTITY FULL is required so Postgres publishes the full row on
-- UPDATE and DELETE events (not just the primary key).
-- These statements are idempotent — safe to re-run.

ALTER TABLE public.budgets              REPLICA IDENTITY FULL;
ALTER TABLE public.budget_periods       REPLICA IDENTITY FULL;
ALTER TABLE public.accounts             REPLICA IDENTITY FULL;
ALTER TABLE public.category_groups      REPLICA IDENTITY FULL;
ALTER TABLE public.envelopes            REPLICA IDENTITY FULL;
ALTER TABLE public.envelope_allocations REPLICA IDENTITY FULL;
ALTER TABLE public.transactions         REPLICA IDENTITY FULL;
ALTER TABLE public.recurring_rules      REPLICA IDENTITY FULL;
ALTER TABLE public.bill_reminders       REPLICA IDENTITY FULL;
ALTER TABLE public.goals                REPLICA IDENTITY FULL;

-- Add tables to the supabase_realtime publication only if not already members.
DO $$
DECLARE
  t text;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'budgets',
    'budget_periods',
    'accounts',
    'category_groups',
    'envelopes',
    'envelope_allocations',
    'transactions',
    'recurring_rules',
    'bill_reminders',
    'goals'
  ] LOOP
    IF NOT EXISTS (
      SELECT 1 FROM pg_publication_tables
      WHERE pubname = 'supabase_realtime'
        AND schemaname = 'public'
        AND tablename = t
    ) THEN
      EXECUTE format('ALTER PUBLICATION supabase_realtime ADD TABLE public.%I', t);
    END IF;
  END LOOP;
END $$;
