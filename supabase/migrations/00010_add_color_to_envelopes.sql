alter table public.envelopes add column color text;

-- Reload PostgREST schema cache so the new column is immediately queryable.
notify pgrst, 'reload schema';
