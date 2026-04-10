import 'package:envelope_api_client/src/exceptions.dart';
import 'package:envelope_api_client/src/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// API client for report-related operations.
class ReportsApiClient {
  /// Creates a [ReportsApiClient] with the given [SupabaseClient].
  const ReportsApiClient({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  // --- Net Worth Snapshots ---

  /// Fetches a net worth snapshot by [id].
  Future<NetWorthSnapshotDto> getNetWorthSnapshot(String id) async {
    try {
      final response = await _supabaseClient
          .from('net_worth_snapshots')
          .select()
          .eq('id', id)
          .single();
      return NetWorthSnapshotDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all net worth snapshots for a budget.
  Future<List<NetWorthSnapshotDto>> getNetWorthSnapshotsByBudget(
    String budgetId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('net_worth_snapshots')
          .select()
          .eq('budget_id', budgetId)
          .order('date', ascending: false);
      return response.map(NetWorthSnapshotDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates or updates a net worth snapshot for the given budget and date.
  ///
  /// Uses upsert so that recording a second snapshot on the same day updates
  /// the existing row instead of failing the (budget_id, date) unique
  /// constraint.
  ///
  /// Server-generated fields (`id`, `created_at`) are stripped so Supabase
  /// applies its defaults.
  Future<NetWorthSnapshotDto> createNetWorthSnapshot(
    NetWorthSnapshotDto snapshot,
  ) async {
    try {
      final json = snapshot.toJson()
        ..remove('id')
        ..remove('created_at');
      final response = await _supabaseClient
          .from('net_worth_snapshots')
          .upsert(json, onConflict: 'budget_id,date')
          .select()
          .single();
      return NetWorthSnapshotDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes a net worth snapshot by [id].
  Future<void> deleteNetWorthSnapshot(String id) async {
    try {
      await _supabaseClient.from('net_worth_snapshots').delete().eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  // --- Activity Log ---

  /// Fetches an activity log entry by [id].
  Future<ActivityLogDto> getActivityLog(String id) async {
    try {
      final response = await _supabaseClient
          .from('activity_log')
          .select()
          .eq('id', id)
          .single();
      return ActivityLogDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all activity log entries for a budget.
  Future<List<ActivityLogDto>> getActivityLogsByBudget(
    String budgetId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('activity_log')
          .select()
          .eq('budget_id', budgetId)
          .order('created_at', ascending: false);
      return response.map(ActivityLogDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new activity log entry.
  ///
  /// Server-generated fields (`id`, `created_at`) are stripped so Supabase
  /// applies its defaults.
  Future<ActivityLogDto> createActivityLog(ActivityLogDto log) async {
    try {
      final json = log.toJson()
        ..remove('id')
        ..remove('created_at');
      final response = await _supabaseClient
          .from('activity_log')
          .insert(json)
          .select()
          .single();
      return ActivityLogDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes an activity log entry by [id].
  Future<void> deleteActivityLog(String id) async {
    try {
      await _supabaseClient.from('activity_log').delete().eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }
}
