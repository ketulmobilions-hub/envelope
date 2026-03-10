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

  /// Creates a new net worth snapshot.
  Future<NetWorthSnapshotDto> createNetWorthSnapshot(
    NetWorthSnapshotDto snapshot,
  ) async {
    try {
      final response = await _supabaseClient
          .from('net_worth_snapshots')
          .insert(snapshot.toJson())
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
  Future<ActivityLogDto> createActivityLog(ActivityLogDto log) async {
    try {
      final response = await _supabaseClient
          .from('activity_log')
          .insert(log.toJson())
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
