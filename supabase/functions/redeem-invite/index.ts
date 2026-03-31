import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import {
  corsHeaders,
  createSupabaseServiceClient,
} from '../_shared/email.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders() });
  }

  try {
    // Verify the caller is authenticated.
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: 'Missing Authorization header' }),
        { status: 401, headers: corsHeaders() },
      );
    }

    const userClient = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_ANON_KEY')!,
      { global: { headers: { Authorization: authHeader } } },
    );
    const { data: { user: caller }, error: authError } =
      await userClient.auth.getUser();

    if (authError || !caller) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized' }),
        { status: 401, headers: corsHeaders() },
      );
    }

    const { inviteId } = (await req.json()) as { inviteId: string };
    if (!inviteId) {
      return new Response(
        JSON.stringify({ error: 'Missing inviteId' }),
        { status: 400, headers: corsHeaders() },
      );
    }

    const serviceClient = createSupabaseServiceClient();

    // Look up the invite.
    const { data: invite, error: inviteError } = await serviceClient
      .from('budget_invites')
      .select('*')
      .eq('id', inviteId)
      .single();

    if (inviteError || !invite) {
      return new Response(
        JSON.stringify({ error: 'Invite not found' }),
        { status: 404, headers: corsHeaders() },
      );
    }

    // Validate: not expired.
    if (new Date(invite.expires_at) < new Date()) {
      return new Response(
        JSON.stringify({ error: 'Invite has expired' }),
        { status: 410, headers: corsHeaders() },
      );
    }

    // Validate: not already redeemed.
    if (invite.redeemed_at) {
      return new Response(
        JSON.stringify({ error: 'Invite has already been redeemed' }),
        { status: 409, headers: corsHeaders() },
      );
    }

    // Validate: caller is not already a member.
    const { data: existingMember } = await serviceClient
      .from('budget_members')
      .select('id')
      .eq('budget_id', invite.budget_id)
      .eq('user_id', caller.id)
      .limit(1);

    if (existingMember && existingMember.length > 0) {
      return new Response(
        JSON.stringify({ error: 'You are already a member of this budget' }),
        { status: 409, headers: corsHeaders() },
      );
    }

    // Check caller is not the budget owner.
    const { data: budget } = await serviceClient
      .from('budgets')
      .select('id, name, owner_id')
      .eq('id', invite.budget_id)
      .single();

    if (budget?.owner_id === caller.id) {
      return new Response(
        JSON.stringify({ error: 'You own this budget' }),
        { status: 409, headers: corsHeaders() },
      );
    }

    // Create budget member.
    const { error: memberError } = await serviceClient
      .from('budget_members')
      .insert({
        budget_id: invite.budget_id,
        user_id: caller.id,
        role: invite.role,
        invited_via: `invite:${invite.id}`,
        accepted_at: new Date().toISOString(),
      });

    if (memberError) {
      return new Response(
        JSON.stringify({ error: `Failed to add member: ${memberError.message}` }),
        { status: 500, headers: corsHeaders() },
      );
    }

    // Mark invite as redeemed.
    await serviceClient
      .from('budget_invites')
      .update({
        redeemed_at: new Date().toISOString(),
        redeemed_by: caller.id,
      })
      .eq('id', inviteId);

    return new Response(
      JSON.stringify({
        success: true,
        budgetId: invite.budget_id,
        budgetName: budget?.name ?? '',
        role: invite.role,
      }),
      { status: 200, headers: corsHeaders() },
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: (error as Error).message }),
      { status: 500, headers: corsHeaders() },
    );
  }
});
