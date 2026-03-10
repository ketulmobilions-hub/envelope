import 'package:envelope_api_client/src/clients/clients.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Facade that provides access to all Envelope API sub-clients.
class EnvelopeApiClient {
  /// Creates an [EnvelopeApiClient] with the given [SupabaseClient].
  EnvelopeApiClient({required SupabaseClient supabaseClient})
      : users = UsersApiClient(supabaseClient: supabaseClient),
        budgets = BudgetsApiClient(supabaseClient: supabaseClient),
        accounts = AccountsApiClient(supabaseClient: supabaseClient),
        envelopes = EnvelopesApiClient(supabaseClient: supabaseClient),
        transactions = TransactionsApiClient(supabaseClient: supabaseClient),
        recurring = RecurringApiClient(supabaseClient: supabaseClient),
        goals = GoalsApiClient(supabaseClient: supabaseClient),
        reports = ReportsApiClient(supabaseClient: supabaseClient),
        sync = SyncApiClient(supabaseClient: supabaseClient);

  /// API client for user operations.
  final UsersApiClient users;

  /// API client for budget operations.
  final BudgetsApiClient budgets;

  /// API client for account operations.
  final AccountsApiClient accounts;

  /// API client for envelope and category group operations.
  final EnvelopesApiClient envelopes;

  /// API client for transaction operations.
  final TransactionsApiClient transactions;

  /// API client for recurring rule and bill reminder operations.
  final RecurringApiClient recurring;

  /// API client for goal operations.
  final GoalsApiClient goals;

  /// API client for report operations.
  final ReportsApiClient reports;

  /// API client for sync operations.
  final SyncApiClient sync;
}
