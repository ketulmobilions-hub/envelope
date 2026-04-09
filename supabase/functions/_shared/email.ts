import { createClient, SupabaseClient } from 'https://esm.sh/@supabase/supabase-js@2';

export const FROM_ADDRESS =
  Deno.env.get('FROM_EMAIL') ?? 'Envelope <noreply@envelope.app>';

/** Creates a Supabase client with service_role privileges (bypasses RLS). */
export function createSupabaseServiceClient(): SupabaseClient {
  return createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );
}

/** Escapes HTML special characters to prevent XSS in email templates. */
export function escapeHtml(unsafe: string): string {
  return unsafe
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}

/** Sends an email via the Resend API. Returns the Resend email ID. */
export async function sendEmail(
  to: string,
  subject: string,
  html: string,
): Promise<string> {
  const apiKey = Deno.env.get('RESEND_API_KEY');
  if (!apiKey) throw new Error('RESEND_API_KEY is not configured');

  const res = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ from: FROM_ADDRESS, to, subject, html }),
  });

  if (!res.ok) {
    const body = await res.text();
    throw new Error(`Resend API error (${res.status}): ${body}`);
  }

  const json = await res.json();
  if (!json || typeof json.id !== 'string') {
    throw new Error(`Resend API returned unexpected response: ${JSON.stringify(json)}`);
  }

  return json.id;
}

/** Logs an email send attempt to the email_log table. Throws on failure. */
export async function logEmail(
  client: SupabaseClient,
  params: {
    userId?: string;
    recipientEmail: string;
    emailType: 'invitation' | 'bill_reminder' | 'weekly_summary';
    referenceId: string;
    status: 'sent' | 'failed';
    errorMessage?: string;
  },
): Promise<void> {
  const { error } = await client.from('email_log').insert({
    user_id: params.userId ?? null,
    recipient_email: params.recipientEmail,
    email_type: params.emailType,
    reference_id: params.referenceId,
    status: params.status,
    error_message: params.errorMessage ?? null,
  });

  if (error) {
    console.error(`Failed to log email: ${error.message}`);
  }
}

/** Checks whether an email with the given type and reference has already been sent. */
export async function checkAlreadySent(
  client: SupabaseClient,
  emailType: string,
  referenceId: string,
): Promise<boolean> {
  const { data } = await client
    .from('email_log')
    .select('id')
    .eq('email_type', emailType)
    .eq('reference_id', referenceId)
    .eq('status', 'sent')
    .limit(1);

  return (data?.length ?? 0) > 0;
}

/**
 * Verifies the request carries a valid service_role Authorization header.
 * Used by cron-triggered functions to reject unauthorized callers.
 */
export function verifyServiceRoleAuth(req: Request): boolean {
  const authHeader = req.headers.get('Authorization');
  const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
  if (!authHeader || !serviceRoleKey) return false;
  return authHeader === `Bearer ${serviceRoleKey}`;
}

/**
 * Returns a CORS-aware JSON response. Handles OPTIONS preflight.
 */
export function corsHeaders(): Record<string, string> {
  return {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  };
}

/**
 * Computes ISO 8601 week number and year for a given date.
 * Correctly handles year boundaries (e.g. Dec 31 may be W01 of next year).
 */
export function isoWeekNumber(date: Date): { isoYear: number; isoWeek: number } {
  const d = new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()));
  // Set to nearest Thursday: current date + 4 - current day number (Mon=1, Sun=7).
  const dayNum = d.getUTCDay() || 7;
  d.setUTCDate(d.getUTCDate() + 4 - dayNum);
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  const isoWeek = Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
  return { isoYear: d.getUTCFullYear(), isoWeek };
}

// ---------------------------------------------------------------------------
// HTML email templates
// ---------------------------------------------------------------------------

const STYLES = `
  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; margin: 0; padding: 0; background: #f5f5f5; }
  .container { max-width: 600px; margin: 0 auto; background: #ffffff; }
  .header { background: #4F46E5; padding: 24px; text-align: center; }
  .header h1 { color: #ffffff; margin: 0; font-size: 24px; }
  .content { padding: 32px 24px; color: #1f2937; line-height: 1.6; }
  .cta { display: inline-block; background: #4F46E5; color: #ffffff; padding: 12px 24px; border-radius: 8px; text-decoration: none; font-weight: 600; margin: 16px 0; }
  .footer { padding: 16px 24px; text-align: center; color: #9ca3af; font-size: 12px; }
  .summary-card { background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 8px; padding: 16px; margin: 12px 0; }
  .overspent { color: #dc2626; font-weight: 600; }
  .amount { font-weight: 600; }
`;

function wrapHtml(body: string): string {
  return `<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><style>${STYLES}</style></head>
<body>
  <div class="container">
    <div class="header"><h1>Envelope</h1></div>
    <div class="content">${body}</div>
    <div class="footer">
      <p>You received this email because you have email notifications enabled in Envelope.</p>
      <p>To stop receiving these emails, open the Envelope app and disable email notifications in Settings &gt; Notifications.</p>
    </div>
  </div>
</body>
</html>`;
}

export function invitationEmailHtml(
  inviterName: string,
  budgetName: string,
  inviteId: string,
): string {
  const safeInviter = escapeHtml(inviterName);
  const safeBudget = escapeHtml(budgetName);
  const safeInviteId = encodeURIComponent(inviteId);

  return wrapHtml(`
    <p>Hi there,</p>
    <p><strong>${safeInviter}</strong> has invited you to collaborate on the budget
       <strong>&ldquo;${safeBudget}&rdquo;</strong> in Envelope.</p>
    <p><a class="cta" href="https://envelope.app/invite/${safeInviteId}">Accept Invitation</a></p>
    <p>If you don't have an Envelope account yet, you'll be able to create one when you accept.</p>
  `);
}

export function billReminderEmailHtml(
  userName: string,
  billName: string,
  amount: string,
  daysUntilDue: number,
  budgetName: string,
): string {
  const safeName = escapeHtml(userName);
  const safeBill = escapeHtml(billName);
  const safeAmount = escapeHtml(amount);
  const safeBudget = escapeHtml(budgetName);

  return wrapHtml(`
    <p>Hi ${safeName},</p>
    <p>This is a reminder that your bill <strong>${safeBill}</strong> is due
       in <strong>${daysUntilDue} day${daysUntilDue === 1 ? '' : 's'}</strong>.</p>
    <div class="summary-card">
      <p><strong>Bill:</strong> ${safeBill}</p>
      <p><strong>Estimated amount:</strong> ${safeAmount}</p>
      <p><strong>Budget:</strong> ${safeBudget}</p>
    </div>
    <p>Open Envelope to review and mark this bill as paid.</p>
  `);
}

export interface BudgetSummary {
  budgetName: string;
  totalAllocated: number;
  totalSpent: number;
  currency: string;
  transactionCount: number;
  overspentEnvelopes: { name: string; overspentBy: number }[];
}

export function weeklySummaryEmailHtml(
  userName: string,
  summaries: BudgetSummary[],
  weekLabel: string,
): string {
  const safeName = escapeHtml(userName);
  const safeWeek = escapeHtml(weekLabel);

  const budgetSections = summaries
    .map((s) => {
      const safeBudget = escapeHtml(s.budgetName);
      const remaining = s.totalAllocated - s.totalSpent;
      const overspentList = s.overspentEnvelopes
        .map(
          (e) =>
            `<li class="overspent">${escapeHtml(e.name)}: over by ${escapeHtml(formatCents(e.overspentBy, s.currency))}</li>`,
        )
        .join('');

      return `
      <div class="summary-card">
        <h3 style="margin-top:0">${safeBudget}</h3>
        <p>Allocated: <span class="amount">${escapeHtml(formatCents(s.totalAllocated, s.currency))}</span></p>
        <p>Spent: <span class="amount">${escapeHtml(formatCents(s.totalSpent, s.currency))}</span></p>
        <p>Remaining: <span class="amount" style="color:${remaining >= 0 ? '#059669' : '#dc2626'}">${escapeHtml(formatCents(remaining, s.currency))}</span></p>
        <p>${s.transactionCount} transaction${s.transactionCount === 1 ? '' : 's'} this week</p>
        ${overspentList ? `<p><strong>Overspent envelopes:</strong></p><ul>${overspentList}</ul>` : ''}
      </div>`;
    })
    .join('');

  return wrapHtml(`
    <p>Hi ${safeName},</p>
    <p>Here's your budget summary for the week of <strong>${safeWeek}</strong>.</p>
    ${budgetSections || '<p>No active budgets this week.</p>'}
    <p>Open Envelope to see the full details.</p>
  `);
}

function formatCents(cents: number, currency: string): string {
  const abs = Math.abs(cents);
  const sign = cents < 0 ? '-' : '';
  return `${sign}${currency} ${(abs / 100).toFixed(2)}`;
}
