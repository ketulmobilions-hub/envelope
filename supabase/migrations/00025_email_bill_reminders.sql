-- Add separate email_bill_reminders column to notification_preferences.
-- Previously, both push and email bill reminder toggles shared the same
-- bill_reminders column, causing changes to one to reflect in the other.

ALTER TABLE notification_preferences
  ADD COLUMN IF NOT EXISTS email_bill_reminders boolean NOT NULL DEFAULT true;
