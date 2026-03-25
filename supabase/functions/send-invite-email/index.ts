import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';

interface InviteRequest {
  email: string;
  budgetName: string;
  inviterName: string;
  inviteId: string;
}

serve(async (req: Request) => {
  try {
    const { email, budgetName, inviterName, inviteId } =
      (await req.json()) as InviteRequest;

    if (!email || !budgetName || !inviterName || !inviteId) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } },
      );
    }

    // TODO: Configure email provider (e.g. Resend, SendGrid, or Supabase
    // built-in email). For now this is a placeholder that logs the invite.
    console.log(
      `Sending invite email to ${email} for budget "${budgetName}" ` +
        `from ${inviterName} (invite: ${inviteId})`,
    );

    // Placeholder: In production, replace with actual email sending logic.
    // Example with Resend:
    // const res = await fetch('https://api.resend.com/emails', {
    //   method: 'POST',
    //   headers: {
    //     'Authorization': `Bearer ${Deno.env.get('RESEND_API_KEY')}`,
    //     'Content-Type': 'application/json',
    //   },
    //   body: JSON.stringify({
    //     from: 'Envelope <noreply@envelope.app>',
    //     to: email,
    //     subject: `${inviterName} invited you to "${budgetName}"`,
    //     html: `<p>${inviterName} has invited you to collaborate on
    //            the budget "${budgetName}" in Envelope.</p>
    //            <a href="https://envelope.app/invite/${inviteId}">
    //              Accept Invitation
    //            </a>`,
    //   }),
    // });

    return new Response(
      JSON.stringify({ success: true }),
      { status: 200, headers: { 'Content-Type': 'application/json' } },
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: (error as Error).message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } },
    );
  }
});
