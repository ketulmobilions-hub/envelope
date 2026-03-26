-- Add on-budget flag to accounts.
-- On-budget accounts contribute their starting balance to Ready to Assign.
-- Off-budget accounts (e.g. credit cards, investments) do not.
ALTER TABLE accounts ADD COLUMN is_on_budget BOOLEAN NOT NULL DEFAULT true;

-- Refresh PostgREST schema cache so the new column is immediately available.
NOTIFY pgrst, 'reload schema';
