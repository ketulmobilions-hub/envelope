import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import {
  checkAlreadySent,
  corsHeaders,
  createSupabaseServiceClient,
  escapeHtml,
  invitationEmailHtml,
  logEmail,
  sendEmail,
} from '../_shared/email.ts';

interface InviteRequest {
  email: string;
  budgetName: string;
  inviterName: string;
  inviteId: string;
}

serve(async (req: Request) => {
  // Handle CORS preflight for web clients.
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders() });
  }

  try {
    // Verify the caller is authenticated via their JWT.
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: 'Missing Authorization header' }),
        { status: 401, headers: corsHeaders() },
      );
    }

    // Verify the caller's JWT using the service role client.
    const jwt = authHeader.replace(/^Bearer\s+/i, '');
    const serviceClient = createSupabaseServiceClient();
    const { data: { user: caller }, error: authError } = await serviceClient.auth.getUser(jwt);
    if (authError || !caller) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized' }),
        { status: 401, headers: corsHeaders() },
      );
    }

    const { email, budgetName, inviterName, inviteId } =
      (await req.json()) as InviteRequest;

    if (!email || !budgetName || !inviterName || !inviteId) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields' }),
        { status: 400, headers: corsHeaders() },
      );
    }

    // Verify the caller is the owner or a member of the budget associated
    // with this invite, to prevent abuse.
    const { data: member } = await serviceClient
      .from('budget_members')
      .select('id')
      .eq('id', inviteId)
      .single();

    if (!member) {
      return new Response(
        JSON.stringify({ error: 'Invalid invite' }),
        { status: 403, headers: corsHeaders() },
      );
    }

    // Deduplication: skip if this invite email was already sent.
    if (await checkAlreadySent(serviceClient, 'invitation', inviteId)) {
      return new Response(
        JSON.stringify({ success: true, skipped: true }),
        { status: 200, headers: corsHeaders() },
      );
    }

    const safeInviterName = escapeHtml(inviterName);
    const safeBudgetName = escapeHtml(budgetName);
    const subject = `${safeInviterName} invited you to "${safeBudgetName}" on Envelope`;
    const html = invitationEmailHtml(inviterName, budgetName, inviteId);

    try {
      await sendEmail(email, subject, html);
      await logEmail(serviceClient, {
        recipientEmail: email,
        emailType: 'invitation',
        referenceId: inviteId,
        status: 'sent',
      });
    } catch (sendError) {
      await logEmail(serviceClient, {
        recipientEmail: email,
        emailType: 'invitation',
        referenceId: inviteId,
        status: 'failed',
        errorMessage: (sendError as Error).message,
      });
      throw sendError;
    }

    return new Response(
      JSON.stringify({ success: true }),
      { status: 200, headers: corsHeaders() },
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: (error as Error).message }),
      { status: 500, headers: corsHeaders() },
    );
  }
});
