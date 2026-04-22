-- Add linked_account_id to envelopes to support CC Payment envelope tracking.
-- When a credit card account is created, a corresponding payment envelope is
-- auto-created and linked via this column.
ALTER TABLE envelopes
  ADD COLUMN IF NOT EXISTS linked_account_id uuid REFERENCES accounts(id) ON DELETE SET NULL;
