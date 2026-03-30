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
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

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

    // Create a client with the caller's JWT to verify identity.
    const userClient = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_ANON_KEY')!,
      { global: { headers: { Authorization: authHeader } } },
    );
    const { data: { user: caller }, error: authError } = await userClient.auth.getUser();
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

    const serviceClient = createSupabaseServiceClient();

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
