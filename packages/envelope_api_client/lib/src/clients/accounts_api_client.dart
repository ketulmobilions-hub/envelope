import 'package:envelope_api_client/src/exceptions.dart';
import 'package:envelope_api_client/src/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// API client for account-related operations.
class AccountsApiClient {
  /// Creates an [AccountsApiClient] with the given [SupabaseClient].
  const AccountsApiClient({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  // --- Accounts ---

  /// Fetches an account by [id].
  Future<AccountDto> getAccount(String id) async {
    try {
      final response = await _supabaseClient
          .from('accounts')
          .select()
          .eq('id', id)
          .single();
      return AccountDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all accounts for a budget.
  Future<List<AccountDto>> getAccountsByBudget(String budgetId) async {
    try {
      final response = await _supabaseClient
          .from('accounts')
          .select()
          .eq('budget_id', budgetId);
      return response.map(AccountDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new account.
  ///
  /// Server-generated fields (`id`, `created_at`, `updated_at`) are
  /// stripped from the payload so Supabase applies its defaults.
  Future<AccountDto> createAccount(AccountDto account) async {
    try {
      final json = account.toJson()
        ..remove('id')
        ..remove('created_at')
        ..remove('updated_at');
      final response = await _supabaseClient
          .from('accounts')
          .insert(json)
          .select()
          .single();
      return AccountDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Updates an existing account.
  Future<AccountDto> updateAccount(AccountDto account) async {
    try {
      final response = await _supabaseClient
          .from('accounts')
          .update(account.toJson())
          .eq('id', account.id)
          .select()
          .single();
      return AccountDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes an account by [id].
  Future<void> deleteAccount(String id) async {
    try {
      await _supabaseClient.from('accounts').delete().eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  // --- Debt Accounts ---

  /// Fetches a debt account by [accountId], or `null` if none exists.
  Future<DebtAccountDto?> getDebtAccount(String accountId) async {
    try {
      final response = await _supabaseClient
          .from('debt_accounts')
          .select()
          .eq('account_id', accountId)
          .maybeSingle();
      if (response == null) return null;
      return DebtAccountDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new debt account.
  ///
  /// Server-generated field (`id`) is stripped so Supabase applies its default.
  Future<DebtAccountDto> createDebtAccount(DebtAccountDto debtAccount) async {
    try {
      final json = debtAccount.toJson()..remove('id');
      final response = await _supabaseClient
          .from('debt_accounts')
          .insert(json)
          .select()
          .single();
      return DebtAccountDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Updates an existing debt account.
  Future<DebtAccountDto> updateDebtAccount(DebtAccountDto debtAccount) async {
    try {
      final response = await _supabaseClient
          .from('debt_accounts')
          .update(debtAccount.toJson())
          .eq('account_id', debtAccount.accountId)
          .select()
          .single();
      return DebtAccountDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes a debt account by [accountId].
  Future<void> deleteDebtAccount(String accountId) async {
    try {
      await _supabaseClient
          .from('debt_accounts')
          .delete()
          .eq('account_id', accountId);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }
}
