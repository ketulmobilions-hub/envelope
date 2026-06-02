-- Issue #82 follow-up: 00041's replacement envelope_allocations table did
-- not carry over two attributes that the original (00004) defined:
--   * `id` had `default gen_random_uuid()` — without it, inserts that omit
--     id fail with `null value in column "id" ... violates not-null
--     constraint`. Drift/PostgREST INSERTs strip empty-string id so the
--     default has to be on the column.
--   * `envelope_id` referenced `public.envelopes(id) on delete cascade`
--     — needed to keep allocation rows from outliving their envelopes.
--
-- This migration restores both. Idempotent: defaults are set only if
-- absent, and the FK is recreated under a stable name.

begin;

alter table public.envelope_allocations
  alter column id set default gen_random_uuid();

alter table public.envelope_allocations
  drop constraint if exists envelope_allocations_envelope_id_fkey;

alter table public.envelope_allocations
  add constraint envelope_allocations_envelope_id_fkey
  foreign key (envelope_id)
  references public.envelopes(id)
  on delete cascade;

commit;
