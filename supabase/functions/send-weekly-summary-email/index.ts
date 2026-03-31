import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import {
  type BudgetSummary,
  checkAlreadySent,
  corsHeaders,
  createSupabaseServiceClient,
  isoWeekNumber,
  logEmail,
  sendEmail,
  verifyServiceRoleAuth,
  weeklySummaryEmailHtml,
} from '../_shared/email.ts';

serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders() });
  }

  // Only allow service_role callers (pg_cron).
  if (!verifyServiceRoleAuth(req)) {
    return new Response(
      JSON.stringify({ error: 'Unauthorized' }),
      { status: 401, headers: corsHeaders() },
    );
  }

  const client = createSupabaseServiceClient();
  const today = new Date();

  // ISO week label for dedup and display.
  const { isoYear, isoWeek } = isoWeekNumber(today);
  const weekLabel = `${isoYear}-W${String(isoWeek).padStart(2, '0')}`;

  // Date range for "this week" (last 7 days).
  const weekAgo = new Date(today);
  weekAgo.setUTCDate(weekAgo.getUTCDate() - 7);
  const weekAgoStr = weekAgo.toISOString();

  // Formatted date range for the email body.
  const formatDate = (d: Date) =>
    d.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
  const dateRange = `${formatDate(weekAgo)} – ${formatDate(today)}`;

  // Get all users with email + weekly_summary notifications enabled.
  const { data: prefs, error: prefsError } = await client
    .from('notification_preferences')
    .select('user_id')
    .eq('email_enabled', true)
    .eq('weekly_summary', true);

  if (prefsError) {
    return new Response(
      JSON.stringify({ error: prefsError.message }),
      { status: 500, headers: corsHeaders() },
    );
  }

  const userIds = (prefs ?? []).map((p: any) => p.user_id);
  if (userIds.length === 0) {
    return new Response(
      JSON.stringify({ sent: 0, skipped: 0, failed: 0 }),
      { status: 200, headers: corsHeaders() },
    );
  }

  // Batch fetch all user info at once.
  const { data: allUsers } = await client
    .from('users')
    .select('id, email, display_name')
    .in('id', userIds);

  const userMap = new Map<string, any>();
  for (const u of allUsers ?? []) {
    userMap.set(u.id, u);
  }

  // Batch fetch all owned budgets for these users.
  const { data: allOwnedBudgets } = await client
    .from('budgets')
    .select('id, name, base_currency, owner_id')
    .in('owner_id', userIds)
    .eq('is_archived', false);

  // Batch fetch all shared memberships for these users.
  const { data: allMemberships } = await client
    .from('budget_members')
    .select('user_id, budget_id')
    .in('user_id', userIds)
    .not('accepted_at', 'is', null);

  // Fetch shared budgets that aren't already in owned set.
  const ownedBudgetIds = new Set((allOwnedBudgets ?? []).map((b: any) => b.id));
  const sharedBudgetIds = [
    ...new Set(
      (allMemberships ?? [])
        .map((m: any) => m.budget_id)
        .filter((id: string) => !ownedBudgetIds.has(id)),
    ),
  ];

  let sharedBudgetMap = new Map<string, any>();
  if (sharedBudgetIds.length > 0) {
    const { data: sharedBudgets } = await client
      .from('budgets')
      .select('id, name, base_currency, owner_id')
      .in('id', sharedBudgetIds)
      .eq('is_archived', false);

    for (const b of sharedBudgets ?? []) {
      sharedBudgetMap.set(b.id, b);
    }
  }

  // Build per-user budget lists.
  const ownedByUser = new Map<string, any[]>();
  for (const b of allOwnedBudgets ?? []) {
    const list = ownedByUser.get(b.owner_id) ?? [];
    list.push(b);
    ownedByUser.set(b.owner_id, list);
  }

  const sharedByUser = new Map<string, any[]>();
  for (const m of allMemberships ?? []) {
    const budget = sharedBudgetMap.get(m.budget_id);
    if (!budget) continue;
    const list = sharedByUser.get(m.user_id) ?? [];
    list.push(budget);
    sharedByUser.set(m.user_id, list);
  }

  // Collect all budget IDs we need period/allocation data for.
  const allBudgetIds = [
    ...new Set([
      ...(allOwnedBudgets ?? []).map((b: any) => b.id),
      ...sharedBudgetIds,
    ]),
  ];

  // Batch fetch current periods for all budgets.
  const todayIso = today.toISOString();
  const { data: allPeriods } = await client
    .from('budget_periods')
    .select('id, budget_id, start_date, end_date')
    .in('budget_id', allBudgetIds)
    .lte('start_date', todayIso)
    .gte('end_date', todayIso);

  const periodByBudget = new Map<string, any>();
  const periodIds: string[] = [];
  for (const p of allPeriods ?? []) {
    periodByBudget.set(p.budget_id, p);
    periodIds.push(p.id);
  }

  // Batch fetch allocations for all current periods.
  let allocationsByPeriod = new Map<string, any[]>();
  if (periodIds.length > 0) {
    const { data: allAllocations } = await client
      .from('envelope_allocations')
      .select('period_id, allocated_amount, spent_amount, rollover_amount, envelope_id')
      .in('period_id', periodIds);

    for (const a of allAllocations ?? []) {
      const list = allocationsByPeriod.get(a.period_id) ?? [];
      list.push(a);
      allocationsByPeriod.set(a.period_id, list);
    }
  }

  // Batch fetch envelope names for overspent envelopes.
  const overspentEnvelopeIds = new Set<string>();
  for (const [, allocations] of allocationsByPeriod) {
    for (const a of allocations) {
      if (a.spent_amount > a.allocated_amount + (a.rollover_amount ?? 0)) {
        overspentEnvelopeIds.add(a.envelope_id);
      }
    }
  }

  const envelopeNames = new Map<string, string>();
  if (overspentEnvelopeIds.size > 0) {
    const { data: envelopes } = await client
      .from('envelopes')
      .select('id, name')
      .in('id', [...overspentEnvelopeIds]);

    for (const e of envelopes ?? []) {
      envelopeNames.set(e.id, e.name);
    }
  }

  // Batch fetch transaction counts per budget for the past week.
  const txCountByBudget = new Map<string, number>();
  for (const budgetId of allBudgetIds) {
    const { count } = await client
      .from('transactions')
      .select('id', { count: 'exact', head: true })
      .eq('budget_id', budgetId)
      .gte('date', weekAgoStr);
    txCountByBudget.set(budgetId, count ?? 0);
  }

  let sent = 0;
  let skipped = 0;
  let failed = 0;

  // Process each user.
  for (const userId of userIds) {
    const referenceId = `${userId}:${weekLabel}`;

    if (await checkAlreadySent(client, 'weekly_summary', referenceId)) {
      skipped++;
      continue;
    }

    const user = userMap.get(userId);
    if (!user) {
      skipped++;
      continue;
    }

    const userBudgets = [
      ...(ownedByUser.get(userId) ?? []),
      ...(sharedByUser.get(userId) ?? []),
    ];

    if (userBudgets.length === 0) {
      skipped++;
      continue;
    }

    // Build summary for each budget using pre-fetched data.
    const summaries: BudgetSummary[] = [];

    for (const budget of userBudgets) {
      const period = periodByBudget.get(budget.id);
      if (!period) continue;

      const allocations = allocationsByPeriod.get(period.id) ?? [];

      const totalAllocated = allocations.reduce(
        (sum: number, a: any) => sum + (a.allocated_amount ?? 0),
        0,
      );
      const totalSpent = allocations.reduce(
        (sum: number, a: any) => sum + (a.spent_amount ?? 0),
        0,
      );

      const overspentEnvelopes = allocations
        .filter(
          (a: any) =>
            a.spent_amount > a.allocated_amount + (a.rollover_amount ?? 0),
        )
        .map((a: any) => ({
          name: envelopeNames.get(a.envelope_id) ?? 'Unknown',
          overspentBy:
            a.spent_amount - a.allocated_amount - (a.rollover_amount ?? 0),
        }));

      summaries.push({
        budgetName: budget.name,
        totalAllocated,
        totalSpent,
        currency: budget.base_currency,
        transactionCount: txCountByBudget.get(budget.id) ?? 0,
        overspentEnvelopes,
      });
    }

    if (summaries.length === 0) {
      skipped++;
      continue;
    }

    const userName = user.display_name || 'there';
    const subject = 'Your weekly budget summary';
    const html = weeklySummaryEmailHtml(userName, summaries, dateRange);

    try {
      await sendEmail(user.email, subject, html);
      await logEmail(client, {
        userId: user.id,
        recipientEmail: user.email,
        emailType: 'weekly_summary',
        referenceId,
        status: 'sent',
      });
      sent++;
    } catch (err) {
      await logEmail(client, {
        userId: user.id,
        recipientEmail: user.email,
        emailType: 'weekly_summary',
        referenceId,
        status: 'failed',
        errorMessage: (err as Error).message,
      });
      failed++;
    }
  }

  return new Response(
    JSON.stringify({ sent, skipped, failed }),
    { status: 200, headers: corsHeaders() },
  );
});
