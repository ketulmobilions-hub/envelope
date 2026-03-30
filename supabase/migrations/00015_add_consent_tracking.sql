-- Consent tracking columns for GDPR compliance.
alter table public.users
  add column privacy_accepted_at timestamptz,
  add column terms_accepted_at timestamptz,
  add column consent_version text;
