part of 'shared_budget_bloc.dart';

sealed class SharedBudgetEvent extends Equatable {
  const SharedBudgetEvent();

  @override
  List<Object?> get props => [];
}

/// Start listening to budget members.
final class SharedBudgetStarted extends SharedBudgetEvent {
  const SharedBudgetStarted();
}

/// Pull-to-refresh members list.
final class SharedBudgetRefreshRequested extends SharedBudgetEvent {
  const SharedBudgetRefreshRequested();
}

/// Invite a member by email.
final class SharedBudgetMemberInvited extends SharedBudgetEvent {
  const SharedBudgetMemberInvited({
    required this.email,
    required this.role,
  });

  final String email;
  final String role;

  @override
  List<Object?> get props => [email, role];
}

/// Request a shareable invite link.
final class SharedBudgetInviteLinkRequested extends SharedBudgetEvent {
  const SharedBudgetInviteLinkRequested({required this.role});

  final String role;

  @override
  List<Object?> get props => [role];
}

/// Update a member's role.
final class SharedBudgetMemberRoleUpdated extends SharedBudgetEvent {
  const SharedBudgetMemberRoleUpdated({
    required this.memberId,
    required this.role,
  });

  final String memberId;
  final String role;

  @override
  List<Object?> get props => [memberId, role];
}

/// Remove a member from the budget.
final class SharedBudgetMemberRemoved extends SharedBudgetEvent {
  const SharedBudgetMemberRemoved(this.memberId);

  final String memberId;

  @override
  List<Object?> get props => [memberId];
}

/// Clear a previously generated invite link (e.g. on role change).
final class SharedBudgetInviteLinkCleared extends SharedBudgetEvent {
  const SharedBudgetInviteLinkCleared();
}

/// Internal event when the members stream emits new data.
final class _MembersUpdated extends SharedBudgetEvent {
  const _MembersUpdated(this.members);

  final List<BudgetMember> members;

  @override
  List<Object?> get props => [members];
}

/// Internal event when the members stream errors.
final class _MembersStreamError extends SharedBudgetEvent {
  const _MembersStreamError();
}
