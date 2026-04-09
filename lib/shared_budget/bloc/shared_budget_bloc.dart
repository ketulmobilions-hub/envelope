import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:sharing_repository/sharing_repository.dart';

part 'shared_budget_event.dart';
part 'shared_budget_state.dart';

class SharedBudgetBloc extends Bloc<SharedBudgetEvent, SharedBudgetState> {
  SharedBudgetBloc({
    required SharingRepository sharingRepository,
    required BudgetRepository budgetRepository,
    required String budgetId,
    required String currentUserId,
    required String currentUserName,
  }) : _sharingRepository = sharingRepository,
       _budgetRepository = budgetRepository,
       _budgetId = budgetId,
       _currentUserId = currentUserId,
       _currentUserName = currentUserName,
       super(const SharedBudgetState()) {
    on<SharedBudgetStarted>(_onStarted);
    on<SharedBudgetRefreshRequested>(_onRefreshRequested);
    on<SharedBudgetMemberInvited>(_onMemberInvited);
    on<SharedBudgetInviteLinkRequested>(_onInviteLinkRequested);
    on<SharedBudgetMemberRoleUpdated>(_onMemberRoleUpdated);
    on<SharedBudgetMemberRemoved>(_onMemberRemoved);
    on<SharedBudgetInviteLinkCleared>(_onInviteLinkCleared);
    on<SharedBudgetInviteRevoked>(_onInviteRevoked);
    on<SharedBudgetPendingInvitesRequested>(_onPendingInvitesRequested);
    on<_MembersUpdated>(_onMembersUpdated);
    on<_MembersStreamError>(_onMembersStreamError);
  }

  final SharingRepository _sharingRepository;
  final BudgetRepository _budgetRepository;
  final String _budgetId;
  final String _currentUserId;
  final String _currentUserName;
  String? _budgetOwnerId;
  String? _budgetName;
  StreamSubscription<List<BudgetMember>>? _membersSubscription;

  /// The budget ID this bloc is watching.
  String get budgetId => _budgetId;

  /// The current user's ID.
  String get currentUserId => _currentUserId;

  /// Whether the current user owns this budget.
  bool get isOwner => _budgetOwnerId == _currentUserId;

  Future<void> _onStarted(
    SharedBudgetStarted event,
    Emitter<SharedBudgetState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SharedBudgetStatus.loading,
        generatedInviteLink: null,
      ),
    );

    await _membersSubscription?.cancel();
    _membersSubscription = _sharingRepository
        .watchMembers(_budgetId)
        .listen(
          (members) => add(_MembersUpdated(members)),
          onError: (Object _) => add(const _MembersStreamError()),
        );

    try {
      final budget = await _budgetRepository.getBudget(_budgetId);
      _budgetOwnerId = budget.ownerId;
      _budgetName = budget.name;
    } on BudgetException {
      // Ownership check falls back to false if budget can't be fetched.
    }

    try {
      await _sharingRepository.refreshMembers(_budgetId);
    } on SharingException {
      // Local watch will still show cached data.
    }

    // Load pending invites.
    add(const SharedBudgetPendingInvitesRequested());
  }

  void _onMembersUpdated(
    _MembersUpdated event,
    Emitter<SharedBudgetState> emit,
  ) {
    emit(
      state.copyWith(
        status: SharedBudgetStatus.loaded,
        members: event.members,
      ),
    );
  }

  void _onMembersStreamError(
    _MembersStreamError event,
    Emitter<SharedBudgetState> emit,
  ) {
    emit(
      state.copyWith(
        status: SharedBudgetStatus.error,
        error: SharedBudgetError.loadFailed,
      ),
    );
    emit(state.copyWith(status: SharedBudgetStatus.loaded, error: null));
  }

  Future<void> _onRefreshRequested(
    SharedBudgetRefreshRequested event,
    Emitter<SharedBudgetState> emit,
  ) async {
    emit(state.copyWith(status: SharedBudgetStatus.refreshing));
    try {
      await _sharingRepository.refreshMembers(_budgetId);
    } on SharingException {
      // Stream will update on its own if data changes.
    } finally {
      emit(state.copyWith(status: SharedBudgetStatus.loaded));
    }
  }

  Future<void> _onMemberInvited(
    SharedBudgetMemberInvited event,
    Emitter<SharedBudgetState> emit,
  ) async {
    if (!state.canInvite) {
      emit(
        state.copyWith(
          status: SharedBudgetStatus.error,
          error: SharedBudgetError.memberLimitReached,
        ),
      );
      emit(state.copyWith(status: SharedBudgetStatus.loaded, error: null));
      return;
    }

    try {
      await _sharingRepository.inviteMember(
        budgetId: _budgetId,
        email: event.email,
        inviterName: _currentUserName,
        budgetName: _budgetName ?? '',
        role: event.role,
      );
      await _sharingRepository.refreshMembers(_budgetId);
      emit(
        state.copyWith(success: SharedBudgetSuccess.inviteSent),
      );
      emit(state.copyWith(success: null));
    } on SharingException {
      emit(
        state.copyWith(
          status: SharedBudgetStatus.error,
          error: SharedBudgetError.inviteFailed,
        ),
      );
      emit(state.copyWith(status: SharedBudgetStatus.loaded, error: null));
    }
  }

  Future<void> _onInviteLinkRequested(
    SharedBudgetInviteLinkRequested event,
    Emitter<SharedBudgetState> emit,
  ) async {
    if (!state.canInvite) {
      emit(
        state.copyWith(
          status: SharedBudgetStatus.error,
          error: SharedBudgetError.memberLimitReached,
        ),
      );
      emit(state.copyWith(status: SharedBudgetStatus.loaded, error: null));
      return;
    }

    try {
      final invite = await _sharingRepository.generateInviteLink(
        budgetId: _budgetId,
        userId: _currentUserId,
        role: event.role,
      );
      emit(state.copyWith(generatedInviteLink: invite.id));
      // Refresh pending invites list.
      add(const SharedBudgetPendingInvitesRequested());
    } on SharingException {
      emit(
        state.copyWith(
          status: SharedBudgetStatus.error,
          error: SharedBudgetError.inviteFailed,
        ),
      );
      emit(state.copyWith(status: SharedBudgetStatus.loaded, error: null));
    }
  }

  void _onInviteLinkCleared(
    SharedBudgetInviteLinkCleared event,
    Emitter<SharedBudgetState> emit,
  ) {
    emit(state.copyWith(generatedInviteLink: null));
  }

  Future<void> _onMemberRoleUpdated(
    SharedBudgetMemberRoleUpdated event,
    Emitter<SharedBudgetState> emit,
  ) async {
    try {
      await _sharingRepository.updateMemberRole(
        memberId: event.memberId,
        role: event.role,
      );
    } on SharingException {
      emit(
        state.copyWith(
          status: SharedBudgetStatus.error,
          error: SharedBudgetError.updateRoleFailed,
        ),
      );
      emit(state.copyWith(status: SharedBudgetStatus.loaded, error: null));
    }
  }

  Future<void> _onMemberRemoved(
    SharedBudgetMemberRemoved event,
    Emitter<SharedBudgetState> emit,
  ) async {
    try {
      await _sharingRepository.removeMember(event.memberId);
      await _sharingRepository.refreshMembers(_budgetId);
    } on SharingException {
      emit(
        state.copyWith(
          status: SharedBudgetStatus.error,
          error: SharedBudgetError.removeFailed,
        ),
      );
      emit(state.copyWith(status: SharedBudgetStatus.loaded, error: null));
    }
  }

  Future<void> _onInviteRevoked(
    SharedBudgetInviteRevoked event,
    Emitter<SharedBudgetState> emit,
  ) async {
    try {
      await _sharingRepository.revokeInvite(event.inviteId);
      add(const SharedBudgetPendingInvitesRequested());
    } on SharingException {
      emit(
        state.copyWith(
          status: SharedBudgetStatus.error,
          error: SharedBudgetError.inviteFailed,
        ),
      );
      emit(state.copyWith(status: SharedBudgetStatus.loaded, error: null));
    }
  }

  Future<void> _onPendingInvitesRequested(
    SharedBudgetPendingInvitesRequested event,
    Emitter<SharedBudgetState> emit,
  ) async {
    try {
      final invites = await _sharingRepository.getPendingInvites(_budgetId);
      emit(state.copyWith(pendingInvites: invites));
    } on SharingException {
      // Non-critical — just don't show pending invites.
    }
  }

  @override
  Future<void> close() async {
    await _membersSubscription?.cancel();
    return super.close();
  }
}
