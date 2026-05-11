-- Add a manual priority order column to goals.
--
-- Auto-assign distributes Ready-to-Assign across active goals in this
-- ascending order; ties break by id for determinism. Defaults to 0 so
-- pre-existing rows keep working without manual reordering.

ALTER TABLE public.goals
  ADD COLUMN sort_order integer NOT NULL DEFAULT 0;
