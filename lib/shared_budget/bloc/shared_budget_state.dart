part of 'shared_budget_bloc.dart';

enum SharedBudgetStatus { initial, loading, loaded, error }

/// Role constants used across the shared budget feature.
abstract final class MemberRole {
  static const String owner = 'owner';
  static const String editor = 'editor';
  static const String viewer = 'viewer';
}

enum SharedBudgetError {
  loadFailed,
  inviteFailed,
  updateRoleFailed,
  removeFailed,
  memberLimitReached,
}

/// Success actions that trigger one-shot UI feedback (e.g. SnackBar).
enum SharedBudgetSuccess { inviteSent }

final class SharedBudgetState extends Equatable {
  const SharedBudgetState({
    this.status = SharedBudgetStatus.initial,
    this.members = const [],
    this.pendingInvites = const [],
    this.error,
    this.success,
    this.generatedInviteLink,
  });

  final SharedBudgetStatus status;
  final List<BudgetMember> members;
  final List<BudgetInvite> pendingInvites;
  final SharedBudgetError? error;
  final SharedBudgetSuccess? success;
  final String? generatedInviteLink;

  static const int _maxFreeMembers = 2;

  /// Whether the budget can accept more members under the free tier.
  bool get canInvite => members.length < _maxFreeMembers;

  SharedBudgetState copyWith({
    SharedBudgetStatus? status,
    List<BudgetMember>? members,
    List<BudgetInvite>? pendingInvites,
    Object? error = _sentinel,
    Object? success = _sentinel,
    Object? generatedInviteLink = _sentinel,
  }) {
    return SharedBudgetState(
      status: status ?? this.status,
      members: members ?? this.members,
      pendingInvites: pendingInvites ?? this.pendingInvites,
      error: error == _sentinel
          ? this.error
          : error as SharedBudgetError?,
      success: success == _sentinel
          ? this.success
          : success as SharedBudgetSuccess?,
      generatedInviteLink: generatedInviteLink == _sentinel
          ? this.generatedInviteLink
          : generatedInviteLink as String?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props =>
      [status, members, pendingInvites, error, success, generatedInviteLink];
}
