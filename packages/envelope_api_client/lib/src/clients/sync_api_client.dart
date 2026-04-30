import 'package:envelope_api_client/src/exceptions.dart';
import 'package:envelope_api_client/src/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// API client for sync-related operations.
class SyncApiClient {
  /// Creates a [SyncApiClient] with the given [SupabaseClient].
  const SyncApiClient({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  /// Fetches sync metadata by [id].
  Future<SyncMetadataDto> getSyncMetadata(String id) async {
    try {
      final response = await _supabaseClient
          .from('sync_metadata')
          .select()
          .eq('id', id)
          .single();
      return SyncMetadataDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all pending sync items for a device.
  Future<List<SyncMetadataDto>> getPendingSyncItems(String deviceId) async {
    try {
      final response = await _supabaseClient
          .from('sync_metadata')
          .select()
          .eq('device_id', deviceId)
          .eq('sync_status', 'pending');
      return response.map(SyncMetadataDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new sync metadata entry.
  ///
  /// Server-generated field (`id`) is stripped so Supabase applies its default.
  Future<SyncMetadataDto> createSyncMetadata(
    SyncMetadataDto metadata,
  ) async {
    try {
      final json = metadata.toJson()..remove('id');
      final response = await _supabaseClient
          .from('sync_metadata')
          .insert(json)
          .select()
          .single();
      return SyncMetadataDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Updates an existing sync metadata entry.
  Future<SyncMetadataDto> updateSyncMetadata(
    SyncMetadataDto metadata,
  ) async {
    try {
      final response = await _supabaseClient
          .from('sync_metadata')
          .update(metadata.toJson())
          .eq('id', metadata.id)
          .select()
          .single();
      return SyncMetadataDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Marks a sync item as synced.
  Future<SyncMetadataDto> markAsSynced(String id) async {
    try {
      final response = await _supabaseClient
          .from('sync_metadata')
          .update({'sync_status': 'synced'})
          .eq('id', id)
          .select()
          .single();
      return SyncMetadataDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all items with sync conflicts.
  Future<List<SyncMetadataDto>> getConflicts() async {
    try {
      final response = await _supabaseClient
          .from('sync_metadata')
          .select()
          .eq('sync_status', 'conflict');
      return response.map(SyncMetadataDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes a sync metadata entry by [id].
  Future<void> deleteSyncMetadata(String id) async {
    try {
      await _supabaseClient.from('sync_metadata').delete().eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }
}
