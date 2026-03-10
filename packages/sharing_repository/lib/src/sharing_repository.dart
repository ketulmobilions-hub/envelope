// Repository stub — fields will be used when methods are implemented.
// ignore_for_file: unused_field
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart'
    hide BudgetMember;
import 'package:sharing_repository/src/models/models.dart';

/// Repository for budget sharing and activity logging.
class SharingRepository {
  const SharingRepository({
    required EnvelopeApiClient apiClient,
    required AppDatabase localDatabase,
  })  : _apiClient = apiClient,
        _localDatabase = localDatabase;

  final EnvelopeApiClient _apiClient;
  final AppDatabase _localDatabase;

  /// Invites a member to a budget.
  Future<BudgetMember> inviteMember({
    required String budgetId,
    required String email,
    String role = 'viewer',
  }) async {
    // TODO(envelope): Implement invite member
    throw UnimplementedError();
  }

  /// Watches the list of members for a budget.
  Stream<List<BudgetMember>> watchMembers(String budgetId) {
    // TODO(envelope): Implement watch members
    throw UnimplementedError();
  }

  /// Updates the role of a budget member.
  Future<void> updateMemberRole({
    required String memberId,
    required String role,
  }) async {
    // TODO(envelope): Implement update member role
    throw UnimplementedError();
  }

  /// Removes a member from a budget.
  Future<void> removeMember(String memberId) async {
    // TODO(envelope): Implement remove member
    throw UnimplementedError();
  }

  /// Accepts a budget invitation.
  Future<void> acceptInvitation(String memberId) async {
    // TODO(envelope): Implement accept invitation
    throw UnimplementedError();
  }

  /// Watches the activity log for a budget.
  Stream<List<ActivityLogEntry>> watchActivityLog(String budgetId) {
    // TODO(envelope): Implement watch activity log
    throw UnimplementedError();
  }
}
