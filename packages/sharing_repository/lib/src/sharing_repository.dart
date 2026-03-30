import 'package:drift/drift.dart' show InsertMode, Value;
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart' as storage;
import 'package:sharing_repository/sharing_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// Repository for budget sharing and activity logging.
///
/// Uses a remote-first strategy: writes go to the Supabase API first,
/// then sync the result to the local Drift database. Reads stream from
/// local storage for reactive UI updates.
class SharingRepository {
  /// Creates a [SharingRepository].
  ///
  /// An optional [supabaseClient] can be provided for Realtime
  /// subscriptions via [subscribeToBudgetChanges].
  const SharingRepository({
    required EnvelopeApiClient apiClient,
    required storage.AppDatabase localDatabase,
    SupabaseClient? supabaseClient,
  }) : _apiClient = apiClient,
       _localDatabase = localDatabase,
       _supabaseClient = supabaseClient;

  final EnvelopeApiClient _apiClient;
  final storage.AppDatabase _localDatabase;
  final SupabaseClient? _supabaseClient;

  static const _uuid = Uuid();

  // ---------------------------------------------------------------------------
  // Members
  // ---------------------------------------------------------------------------

  /// Invites a member to a budget by email.
  ///
  /// [userId] is left `null` — the invited email is stored in
  /// [BudgetMemberDto.invitedVia] as `email:<address>`. When the
  /// invitee signs up / accepts, `userId` is set to their real ID.
  Future<BudgetMember> inviteMember({
    required String budgetId,
    required String email,
    required String inviterName,
    String role = 'viewer',
  }) async {
    try {
      final dto = BudgetMemberDto(
        id: '',
        budgetId: budgetId,
        invitedVia: 'email:$email',
        role: role,
        createdAt: DateTime.now(),
      );

      final created = await _apiClient.budgets.addBudgetMember(dto);
      await _cacheMember(created);

      await _logActivity(
        budgetId: budgetId,
        userId: email,
        action: 'invite_member',
        entityType: 'budget_member',
        entityId: created.id,
      );

      // Send invitation email (best-effort).
      try {
        final budget = await _apiClient.budgets.getBudget(budgetId);
        await _apiClient.budgets.invokeSendInviteEmail(
          email: email,
          budgetName: budget.name,
          inviterName: inviterName,
          inviteId: created.id,
        );
      } on Exception {
        // Email sending is best-effort; don't fail the invite flow.
      }

      return _mapMemberFromDto(created);
    } on EnvelopeApiException catch (e) {
      throw SharingException('Failed to invite member', error: e);
    } on Exception catch (e) {
      throw SharingException('Failed to invite member', error: e);
    }
  }

  /// Generates a shareable invite token for a budget.
  ///
  /// The token encodes the budget ID and role so that when a recipient
  /// opens the deep link, the app can call [inviteMember] with their
  /// actual user ID. No placeholder row is inserted into `budget_members`.
  String generateInviteLink({
    required String budgetId,
    String role = 'viewer',
  }) {
    // Token format: budgetId:role:nonce (plaintext, not secure).
    // TODO(sharing): Replace with a server-side `budget_invites` table.
    // See https://github.com/ketulmobilions-hub/envelope/issues/49
    // The invite table approach (id, budget_id, role, created_by,
    // expires_at, redeemed_at) enables expiration, single-use enforcement,
    // revocation, and audit trails. Requires a DB migration + Supabase
    // Edge Function to verify and redeem invites.
    final nonce = _uuid.v4();
    return '$budgetId:$role:$nonce';
  }

  /// Watches the list of members for a budget.
  ///
  /// Returns a reactive stream from local storage.
  Stream<List<BudgetMember>> watchMembers(String budgetId) {
    return _localDatabase.budgetsDao
        .watchMembersByBudgetId(budgetId)
        .map(
          (rows) => rows.map(_mapMemberFromLocal).toList(),
        )
        .handleError(
          (Object error) => throw SharingException(
            'Failed to watch members',
            error: error,
          ),
        );
  }

  /// Fetches members from the API and syncs to local storage.
  Future<void> refreshMembers(String budgetId) async {
    try {
      final remote = await _apiClient.budgets.getBudgetMembers(budgetId);
      final companions = remote.map(_toMemberCompanion).toList();
      await _localDatabase.budgetsDao.batchInsertBudgetMembers(
        companions,
        mode: InsertMode.insertOrReplace,
      );
    } on EnvelopeApiException catch (e) {
      throw SharingException('Failed to refresh members', error: e);
    }
  }

  /// Updates the role of a budget member.
  Future<void> updateMemberRole({
    required String memberId,
    required String role,
  }) async {
    try {
      final local = await _localDatabase.budgetsDao.getBudgetMember(memberId);
      if (local == null) {
        throw const SharingException('Member not found in local cache');
      }

      final dto = BudgetMemberDto(
        id: memberId,
        budgetId: local.budgetId,
        userId: local.userId,
        invitedVia: local.invitedVia,
        role: role,
        acceptedAt: local.acceptedAt,
        createdAt: local.createdAt,
      );

      final updated = await _apiClient.budgets.updateBudgetMember(dto);
      await _cacheMember(updated);

      await _logActivity(
        budgetId: updated.budgetId,
        userId: updated.userId ?? memberId,
        action: 'update_role',
        entityType: 'budget_member',
        entityId: memberId,
        details: 'Role changed to $role',
      );
    } on SharingException {
      rethrow;
    } on EnvelopeApiException catch (e) {
      throw SharingException('Failed to update member role', error: e);
    }
  }

  /// Removes a member from a budget.
  Future<void> removeMember(String memberId) async {
    try {
      await _apiClient.budgets.removeBudgetMember(memberId);
    } on EnvelopeApiException catch (e) {
      throw SharingException('Failed to remove member', error: e);
    }
    try {
      await _localDatabase.budgetsDao.deleteBudgetMember(memberId);
    } on Exception {
      // Stale local entry will be cleaned up on next refresh.
    }
  }

  /// Accepts a budget invitation.
  Future<void> acceptInvitation(String memberId) async {
    try {
      final local = await _localDatabase.budgetsDao.getBudgetMember(memberId);
      if (local == null) {
        throw const SharingException('Member not found in local cache');
      }

      final dto = BudgetMemberDto(
        id: memberId,
        budgetId: local.budgetId,
        userId: local.userId,
        invitedVia: local.invitedVia,
        role: local.role,
        acceptedAt: DateTime.now(),
        createdAt: local.createdAt,
      );

      final updated = await _apiClient.budgets.updateBudgetMember(dto);
      await _cacheMember(updated);

      await _logActivity(
        budgetId: updated.budgetId,
        userId: updated.userId ?? memberId,
        action: 'accept_invitation',
        entityType: 'budget_member',
        entityId: memberId,
      );
    } on SharingException {
      rethrow;
    } on EnvelopeApiException catch (e) {
      throw SharingException('Failed to accept invitation', error: e);
    }
  }

  /// Declines a budget invitation.
  Future<void> declineInvitation(String memberId) async {
    try {
      await _apiClient.budgets.removeBudgetMember(memberId);
    } on EnvelopeApiException catch (e) {
      throw SharingException('Failed to decline invitation', error: e);
    }
    try {
      await _localDatabase.budgetsDao.deleteBudgetMember(memberId);
    } on Exception {
      // Stale local entry will be cleaned up on next refresh.
    }
  }

  // ---------------------------------------------------------------------------
  // Activity Log
  // ---------------------------------------------------------------------------

  /// Watches the activity log for a budget.
  ///
  /// Returns a reactive stream from local storage.
  Stream<List<ActivityLogEntry>> watchActivityLog(String budgetId) {
    return _localDatabase.reportsDao
        .watchActivityLogsByBudgetId(budgetId)
        .map(
          (rows) => rows.map(_mapActivityFromLocal).toList(),
        )
        .handleError(
          (Object error) => throw SharingException(
            'Failed to watch activity log',
            error: error,
          ),
        );
  }

  /// Fetches activity logs from the API and syncs to local storage.
  Future<void> refreshActivityLog(String budgetId) async {
    try {
      final remote = await _apiClient.reports.getActivityLogsByBudget(budgetId);
      final companions = remote.map(_toActivityCompanion).toList();
      await _localDatabase.reportsDao.batchInsertActivityLogs(
        companions,
        mode: InsertMode.insertOrReplace,
      );
    } on EnvelopeApiException catch (e) {
      throw SharingException('Failed to refresh activity log', error: e);
    }
  }

  // ---------------------------------------------------------------------------
  // Realtime
  // ---------------------------------------------------------------------------

  /// Subscribes to real-time changes on the `budget_members` table
  /// filtered by [budgetId].
  ///
  /// Returns the [RealtimeChannel] so the caller (bloc) can call
  /// `.unsubscribe()` on dispose.
  ///
  /// Requires a [SupabaseClient] to be passed to the constructor.
  RealtimeChannel? subscribeToBudgetChanges(String budgetId) {
    final client = _supabaseClient;
    if (client == null) return null;

    final channel = client
        .channel('budget_members:$budgetId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'budget_members',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'budget_id',
            value: budgetId,
          ),
          callback: (payload) async {
            // On any change, refresh the local cache from the payload.
            final newRecord = payload.newRecord;
            final oldRecord = payload.oldRecord;

            switch (payload.eventType) {
              case PostgresChangeEvent.insert:
              case PostgresChangeEvent.update:
                if (newRecord.isNotEmpty) {
                  final dto = BudgetMemberDto.fromJson(newRecord);
                  await _cacheMember(dto);
                }
              case PostgresChangeEvent.delete:
                if (oldRecord.isNotEmpty) {
                  final id = oldRecord['id'] as String?;
                  if (id != null) {
                    await _localDatabase.budgetsDao.deleteBudgetMember(id);
                  }
                }
              case PostgresChangeEvent.all:
                break;
            }
          },
        )
        .subscribe();

    return channel;
  }

  // ---------------------------------------------------------------------------
  // Private — DTO ↔ Domain mapping
  // ---------------------------------------------------------------------------

  static BudgetMember _mapMemberFromDto(BudgetMemberDto dto) {
    return BudgetMember(
      id: dto.id,
      budgetId: dto.budgetId,
      userId: dto.userId,
      invitedVia: dto.invitedVia,
      role: dto.role,
      acceptedAt: dto.acceptedAt,
      createdAt: dto.createdAt,
    );
  }

  static BudgetMember _mapMemberFromLocal(storage.BudgetMember row) {
    return BudgetMember(
      id: row.id,
      budgetId: row.budgetId,
      userId: row.userId,
      invitedVia: row.invitedVia,
      role: row.role,
      acceptedAt: row.acceptedAt,
      createdAt: row.createdAt,
    );
  }

  static storage.BudgetMembersCompanion _toMemberCompanion(
    BudgetMemberDto dto,
  ) {
    return storage.BudgetMembersCompanion.insert(
      id: dto.id,
      budgetId: dto.budgetId,
      userId: dto.userId != null ? Value(dto.userId) : const Value.absent(),
      invitedVia: dto.invitedVia,
      role: Value(dto.role),
      acceptedAt: dto.acceptedAt != null
          ? Value(dto.acceptedAt)
          : const Value.absent(),
      createdAt: dto.createdAt,
    );
  }

  static ActivityLogEntry _mapActivityFromLocal(storage.ActivityLogData row) {
    return ActivityLogEntry(
      id: row.id,
      budgetId: row.budgetId,
      userId: row.userId,
      action: row.action,
      entityType: row.entityType,
      entityId: row.entityId,
      details: row.details,
      createdAt: row.createdAt,
    );
  }

  static storage.ActivityLogCompanion _toActivityCompanion(
    ActivityLogDto dto,
  ) {
    return storage.ActivityLogCompanion.insert(
      id: dto.id,
      budgetId: dto.budgetId,
      userId: dto.userId,
      action: dto.action,
      entityType: dto.entityType,
      entityId: dto.entityId,
      details: dto.details != null ? Value(dto.details) : const Value.absent(),
      createdAt: dto.createdAt,
    );
  }

  // ---------------------------------------------------------------------------
  // Private — Local cache helpers
  // ---------------------------------------------------------------------------

  Future<void> _cacheMember(BudgetMemberDto dto) async {
    await _localDatabase.budgetsDao.insertBudgetMember(
      _toMemberCompanion(dto),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> _logActivity({
    required String budgetId,
    required String userId,
    required String action,
    required String entityType,
    required String entityId,
    String? details,
  }) async {
    try {
      final dto = ActivityLogDto(
        id: _uuid.v4(),
        budgetId: budgetId,
        userId: userId,
        action: action,
        entityType: entityType,
        entityId: entityId,
        details: details,
        createdAt: DateTime.now(),
      );

      final created = await _apiClient.reports.createActivityLog(dto);

      await _localDatabase.reportsDao.insertActivityLog(
        _toActivityCompanion(created),
        mode: InsertMode.insertOrReplace,
      );
    } on Exception {
      // Activity logging is best-effort; don't fail the main operation.
    }
  }
}
