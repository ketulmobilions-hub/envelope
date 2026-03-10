// Repository stub — fields will be used when methods are implemented.
// ignore_for_file: unused_field
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart'
    hide CategoryGroup, Envelope, EnvelopeAllocation;
import 'package:envelope_repository/envelope_repository.dart';

/// Repository for envelope and category group operations.
class EnvelopeRepository {
  const EnvelopeRepository({
    required EnvelopeApiClient apiClient,
    required AppDatabase localDatabase,
  })  : _apiClient = apiClient,
        _localDatabase = localDatabase;

  final EnvelopeApiClient _apiClient;
  final AppDatabase _localDatabase;

  // --- Category Groups ---

  /// Creates a new category group.
  Future<CategoryGroup> createCategoryGroup({
    required String budgetId,
    required String name,
  }) async {
    // TODO(envelope): implement createCategoryGroup
    throw UnimplementedError();
  }

  /// Watches all category groups for a [budgetId].
  Stream<List<CategoryGroup>> watchCategoryGroups(String budgetId) {
    // TODO(envelope): implement watchCategoryGroups
    throw UnimplementedError();
  }

  /// Updates a category [group].
  Future<void> updateCategoryGroup(CategoryGroup group) async {
    // TODO(envelope): implement updateCategoryGroup
    throw UnimplementedError();
  }

  /// Deletes a category group by its [id].
  Future<void> deleteCategoryGroup(String id) async {
    // TODO(envelope): implement deleteCategoryGroup
    throw UnimplementedError();
  }

  /// Reorders category groups by [orderedIds].
  Future<void> reorderCategoryGroups(List<String> orderedIds) async {
    // TODO(envelope): implement reorderCategoryGroups
    throw UnimplementedError();
  }

  // --- Envelopes ---

  /// Creates a new envelope.
  Future<Envelope> createEnvelope({
    required String categoryGroupId,
    required String budgetId,
    required String name,
  }) async {
    // TODO(envelope): implement createEnvelope
    throw UnimplementedError();
  }

  /// Watches all envelopes for a [budgetId].
  Stream<List<Envelope>> watchEnvelopes(String budgetId) {
    // TODO(envelope): implement watchEnvelopes
    throw UnimplementedError();
  }

  /// Updates an [envelope].
  Future<void> updateEnvelope(Envelope envelope) async {
    // TODO(envelope): implement updateEnvelope
    throw UnimplementedError();
  }

  /// Deletes an envelope by its [id].
  Future<void> deleteEnvelope(String id) async {
    // TODO(envelope): implement deleteEnvelope
    throw UnimplementedError();
  }

  /// Moves an envelope to a new category group.
  Future<void> moveEnvelope({
    required String envelopeId,
    required String newCategoryGroupId,
  }) async {
    // TODO(envelope): implement moveEnvelope
    throw UnimplementedError();
  }

  /// Reorders envelopes by [orderedIds].
  Future<void> reorderEnvelopes(List<String> orderedIds) async {
    // TODO(envelope): implement reorderEnvelopes
    throw UnimplementedError();
  }

  // --- Allocations ---

  /// Creates an allocation for an envelope in a budget period.
  Future<EnvelopeAllocation> allocate({
    required String envelopeId,
    required String budgetPeriodId,
    required int amount,
  }) async {
    // TODO(envelope): implement allocate
    throw UnimplementedError();
  }

  /// Watches all allocations for a [budgetPeriodId].
  Stream<List<EnvelopeAllocation>> watchAllocations(String budgetPeriodId) {
    // TODO(envelope): implement watchAllocations
    throw UnimplementedError();
  }

  /// Updates an [allocation].
  Future<void> updateAllocation(EnvelopeAllocation allocation) async {
    // TODO(envelope): implement updateAllocation
    throw UnimplementedError();
  }
}
