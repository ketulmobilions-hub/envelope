import 'package:envelope_api_client/src/exceptions.dart';
import 'package:envelope_api_client/src/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// API client for transaction-related operations.
class TransactionsApiClient {
  /// Creates a [TransactionsApiClient] with the given [SupabaseClient].
  const TransactionsApiClient({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  // --- Transactions ---

  /// Fetches a transaction by [id].
  Future<TransactionDto> getTransaction(String id) async {
    try {
      final response = await _supabaseClient
          .from('transactions')
          .select()
          .eq('id', id)
          .single();
      return TransactionDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all transactions for a budget.
  Future<List<TransactionDto>> getTransactionsByBudget(
    String budgetId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('transactions')
          .select()
          .eq('budget_id', budgetId)
          .filter('deleted_at', 'is', null)
          .order('date', ascending: false);
      return response.map(TransactionDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all transactions for an account.
  Future<List<TransactionDto>> getTransactionsByAccount(
    String accountId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('transactions')
          .select()
          .eq('account_id', accountId)
          .order('date', ascending: false);
      return response.map(TransactionDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new transaction.
  ///
  /// Server-generated fields (`id`, `created_at`, `updated_at`) are
  /// stripped from the payload so Supabase applies its defaults.
  Future<TransactionDto> createTransaction(TransactionDto transaction) async {
    try {
      final json = transaction.toJson()
        ..remove('id')
        ..remove('created_at')
        ..remove('updated_at');
      final response = await _supabaseClient
          .from('transactions')
          .insert(json)
          .select()
          .single();
      return TransactionDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Updates an existing transaction.
  Future<TransactionDto> updateTransaction(TransactionDto transaction) async {
    try {
      final response = await _supabaseClient
          .from('transactions')
          .update(transaction.toJson())
          .eq('id', transaction.id)
          .select()
          .single();
      return TransactionDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes a transaction by its [id].
  Future<void> deleteTransaction(String id) async {
    try {
      await _supabaseClient
          .from('transactions')
          .delete()
          .eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Restores a soft-deleted transaction by clearing `deleted_at`.
  Future<void> restoreTransaction(String id) async {
    try {
      await _supabaseClient
          .from('transactions')
          .update({'deleted_at': null})
          .eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  // --- Transaction Splits ---

  /// Fetches all splits for a transaction.
  Future<List<TransactionSplitDto>> getTransactionSplits(
    String transactionId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('transaction_splits')
          .select()
          .eq('transaction_id', transactionId);
      return response.map(TransactionSplitDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new transaction split.
  ///
  /// Server-generated field (`id`) is stripped so Supabase applies its default.
  Future<TransactionSplitDto> createTransactionSplit(
    TransactionSplitDto split,
  ) async {
    try {
      final json = split.toJson()..remove('id');
      final response = await _supabaseClient
          .from('transaction_splits')
          .insert(json)
          .select()
          .single();
      return TransactionSplitDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes all splits for a transaction.
  Future<void> deleteTransactionSplits(String transactionId) async {
    try {
      await _supabaseClient
          .from('transaction_splits')
          .delete()
          .eq('transaction_id', transactionId);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  // --- Tags ---

  /// Fetches all tags for a budget.
  Future<List<TagDto>> getTags(String budgetId) async {
    try {
      final response = await _supabaseClient
          .from('tags')
          .select()
          .eq('budget_id', budgetId);
      return response.map(TagDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new tag.
  ///
  /// Server-generated field (`id`) is stripped so Supabase applies its default.
  Future<TagDto> createTag(TagDto tag) async {
    try {
      final json = tag.toJson()..remove('id');
      final response = await _supabaseClient
          .from('tags')
          .insert(json)
          .select()
          .single();
      return TagDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes a tag by [id].
  Future<void> deleteTag(String id) async {
    try {
      await _supabaseClient.from('tags').delete().eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  // --- Transaction Tags (join table) ---

  /// Adds a tag to a transaction.
  Future<void> addTransactionTag({
    required String transactionId,
    required String tagId,
  }) async {
    try {
      await _supabaseClient.from('transaction_tags').insert({
        'transaction_id': transactionId,
        'tag_id': tagId,
      });
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Removes a tag from a transaction.
  Future<void> removeTransactionTag({
    required String transactionId,
    required String tagId,
  }) async {
    try {
      await _supabaseClient
          .from('transaction_tags')
          .delete()
          .eq('transaction_id', transactionId)
          .eq('tag_id', tagId);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all tag IDs for a transaction.
  Future<List<String>> getTransactionTags(String transactionId) async {
    try {
      final response = await _supabaseClient
          .from('transaction_tags')
          .select('tag_id')
          .eq('transaction_id', transactionId);
      return response
          .map<String>((row) => row['tag_id'] as String)
          .toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }
}
