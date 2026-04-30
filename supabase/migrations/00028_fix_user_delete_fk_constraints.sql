-- Fix FK constraints that blocked deleting a row from public.users.
-- Without ON DELETE CASCADE/SET NULL, deleting a user row would fail with
-- a FK violation from these three columns.

-- transactions.created_by: make nullable, set null on user delete.
alter table public.transactions
  alter column created_by drop not null;

alter table public.transactions
  drop constraint if exists transactions_created_by_fkey;

alter table public.transactions
  add constraint transactions_created_by_fkey
    foreign key (created_by) references public.users(id) on delete set null;

-- activity_log.user_id: cascade delete the log entries with the user.
alter table public.activity_log
  drop constraint if exists activity_log_user_id_fkey;

alter table public.activity_log
  add constraint activity_log_user_id_fkey
    foreign key (user_id) references public.users(id) on delete cascade;

-- budget_invites.redeemed_by: already nullable, set null on user delete.
alter table public.budget_invites
  drop constraint if exists budget_invites_redeemed_by_fkey;

alter table public.budget_invites
  add constraint budget_invites_redeemed_by_fkey
    foreign key (redeemed_by) references public.users(id) on delete set null;
