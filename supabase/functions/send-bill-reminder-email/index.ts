import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import {
  billReminderEmailHtml,
  checkAlreadySent,
  corsHeaders,
  createSupabaseServiceClient,
  logEmail,
  sendEmail,
  verifyServiceRoleAuth,
} from '../_shared/email.ts';

interface UserInfo {
  userId: string;
  email: string;
  displayName: string;
}

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

  // Normalize today to UTC midnight for reliable day-diff calculations.
  const now = new Date();
  const today = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
  const todayStr = today.toISOString().slice(0, 10); // YYYY-MM-DD
  const currentDayOfMonth = today.getUTCDate();

  // Fetch all bill reminders for non-archived budgets.
  const { data: bills, error: billsError } = await client
    .from('bill_reminders')
    .select(`
      id,
      name,
      estimated_amount,
      due_day,
      reminder_days_before,
      budget_id,
      budgets!inner (
        id,
        name,
        base_currency,
        owner_id,
        is_archived
      )
    `)
    .eq('budgets.is_archived', false);

  if (billsError) {
    return new Response(
      JSON.stringify({ error: billsError.message }),
      { status: 500, headers: corsHeaders() },
    );
  }

  // Filter bills that are due in exactly `reminder_days_before` days.
  const dueDate = (dueDay: number): Date => {
    let year = today.getUTCFullYear();
    let month = today.getUTCMonth();

    // If due day already passed this month, target next month.
    if (dueDay < currentDayOfMonth) {
      month++;
      if (month > 11) {
        month = 0;
        year++;
      }
    }

    // Clamp to last day of the target month.
    const lastDay = new Date(Date.UTC(year, month + 1, 0)).getUTCDate();
    return new Date(Date.UTC(year, month, Math.min(dueDay, lastDay)));
  };

  const eligibleBills = (bills ?? []).filter((bill: any) => {
    const due = dueDate(bill.due_day);
    const diffDays = Math.round(
      (due.getTime() - today.getTime()) / (1000 * 60 * 60 * 24),
    );
    return diffDays === (bill.reminder_days_before ?? 3);
  });

  let sent = 0;
  let skipped = 0;
  let failed = 0;

  // Batch: collect all unique user IDs we need across all bills.
  const allUserIds = new Set<string>();
  const billBudgets = new Map<string, any>();

  for (const bill of eligibleBills) {
    const budget = bill.budgets as any;
    billBudgets.set(bill.id, budget);
    allUserIds.add(budget.owner_id);
  }

  // Batch fetch shared members for all eligible budgets at once.
  const budgetIds = [...new Set(eligibleBills.map((b: any) => (b.budgets as any).id))];
  let allMembers: any[] = [];
  if (budgetIds.length > 0) {
    const { data: members } = await client
      .from('budget_members')
      .select('user_id, budget_id')
      .in('budget_id', budgetIds)
      .not('accepted_at', 'is', null)
      .not('user_id', 'is', null);
    allMembers = members ?? [];
    for (const m of allMembers) {
      allUserIds.add(m.user_id);
    }
  }

  // Batch fetch all user info and preferences in one query each.
  const userIdArray = [...allUserIds];
  const userMap = new Map<string, UserInfo>();
  const prefsMap = new Map<string, { emailEnabled: boolean; billReminders: boolean }>();

  if (userIdArray.length > 0) {
    const { data: users } = await client
      .from('users')
      .select('id, email, display_name')
      .in('id', userIdArray);

    for (const u of users ?? []) {
      userMap.set(u.id, {
        userId: u.id,
        email: u.email,
        displayName: u.display_name || 'there',
      });
    }

    const { data: allPrefs } = await client
      .from('notification_preferences')
      .select('user_id, email_enabled, bill_reminders')
      .in('user_id', userIdArray);

    for (const p of allPrefs ?? []) {
      prefsMap.set(p.user_id, {
        emailEnabled: p.email_enabled,
        billReminders: p.bill_reminders,
      });
    }
  }

  // Build a map of budget_id -> member user IDs for quick lookup.
  const membersByBudget = new Map<string, string[]>();
  for (const m of allMembers) {
    const list = membersByBudget.get(m.budget_id) ?? [];
    list.push(m.user_id);
    membersByBudget.set(m.budget_id, list);
  }

  // Process each eligible bill.
  for (const bill of eligibleBills) {
    const budget = billBudgets.get(bill.id)!;
    const referenceId = `${bill.id}:${todayStr}`;

    // Collect users: owner + accepted shared members (deduplicated).
    const userIds = new Set<string>([budget.owner_id]);
    for (const memberId of membersByBudget.get(budget.id) ?? []) {
      userIds.add(memberId);
    }

    for (const userId of userIds) {
      const userRefId = `${referenceId}:${userId}`;
      const user = userMap.get(userId);
      if (!user) {
        skipped++;
        continue;
      }

      const prefs = prefsMap.get(userId);
      if (!prefs?.emailEnabled || !prefs?.billReminders) {
        skipped++;
        continue;
      }

      if (await checkAlreadySent(client, 'bill_reminder', userRefId)) {
        skipped++;
        continue;
      }

      const daysUntilDue = bill.reminder_days_before ?? 3;
      const amount = `${budget.base_currency} ${(bill.estimated_amount / 100).toFixed(2)}`;
      const subject = `Reminder: ${bill.name} is due in ${daysUntilDue} day${daysUntilDue === 1 ? '' : 's'}`;
      const html = billReminderEmailHtml(
        user.displayName,
        bill.name,
        amount,
        daysUntilDue,
        budget.name,
      );

      try {
        await sendEmail(user.email, subject, html);
        await logEmail(client, {
          userId: user.userId,
          recipientEmail: user.email,
          emailType: 'bill_reminder',
          referenceId: userRefId,
          status: 'sent',
        });
        sent++;
      } catch (err) {
        await logEmail(client, {
          userId: user.userId,
          recipientEmail: user.email,
          emailType: 'bill_reminder',
          referenceId: userRefId,
          status: 'failed',
          errorMessage: (err as Error).message,
        });
        failed++;
      }
    }
  }

  return new Response(
    JSON.stringify({ sent, skipped, failed }),
    { status: 200, headers: corsHeaders() },
  );
});
