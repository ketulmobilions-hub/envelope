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
    // Verify the caller is authenticated via their JWT.
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: 'Missing Authorization header' }),
        { status: 401, headers: corsHeaders() },
      );
    }

    // Create a client with the caller's JWT to get their user ID.
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

    const userId = caller.id;
    const serviceClient = createSupabaseServiceClient();

    // 1. Delete from public.users — cascades to all related data.
    const { error: deleteDataError } = await serviceClient
      .from('users')
      .delete()
      .eq('id', userId);

    if (deleteDataError) {
      console.error(`Failed to delete user data: ${deleteDataError.message}`);
      return new Response(
        JSON.stringify({ error: 'Failed to delete user data' }),
        { status: 500, headers: corsHeaders() },
      );
    }

    // 2. Delete the Supabase auth user via admin API.
    const { error: deleteAuthError } =
      await serviceClient.auth.admin.deleteUser(userId);

    if (deleteAuthError) {
      console.error(`Failed to delete auth user: ${deleteAuthError.message}`);
      // Data is already deleted; log but don't fail the request.
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
