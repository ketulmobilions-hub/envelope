import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/accounts/widgets/account_helpers.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sharing_repository/sharing_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

/// `(openingBalance, openingDate)` pair — the only `Budget` fields that
/// affect RTA. Diffed in [DashboardBloc._onBudgetUpdated] to gate refreshes.
typedef _OpeningAnchor = (int openingBalance, DateTime? openingDate);

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required BudgetRepository budgetRepository,
    required AccountRepository accountRepository,
    required EnvelopeRepository envelopeRepository,
    required TransactionRepository transactionRepository,
    required String budgetId,
    SharingRepository? sharingRepository,
    DateTime Function()? now,
  }) : _budgetRepository = budgetRepository,
       _accountRepository = accountRepository,
       _envelopeRepository = envelopeRepository,
       _transactionRepository = transactionRepository,
       _budgetId = budgetId,
       _sharingRepository = sharingRepository,
       _now = now ?? DateTime.now,
       super(const DashboardState()) {
    on<DashboardStarted>(_onStarted);
    on<_BudgetUpdated>(_onBudgetUpdated);
    on<_PeriodsUpdated>(_onPeriodsUpdated);
    on<_AccountsUpdated>(_onAccountsUpdated);
    on<_AllocationsUpdated>(_onAllocationsUpdated);
    on<_EnvelopesUpdated>(_onEnvelopesUpdated);
    on<_CategoryGroupsUpdated>(_onCategoryGroupsUpdated);
    on<_RecentTransactionsUpdated>(_onRecentTransactionsUpdated);
    on<_RemoteChangeReceived>(_onRemoteChangeReceived);
    on<_DashboardStreamError>(_onStreamError);
    on<DashboardRefreshRequested>(_onRefreshRequested);
    on<DashboardPreviousPeriodRequested>(_onPreviousPeriod);
    on<DashboardNextPeriodRequested>(_onNextPeriod);
    on<QuickAllocationRequested>(_onQuickAllocationRequested);
    on<BudgetDeleteRequested>(_onBudgetDeleteRequested);
    on<_CcCreditLimitsLoaded>(_onCcCreditLimitsLoaded);
  }

  final BudgetRepository _budgetRepository;
  final AccountRepository _accountRepository;
  final EnvelopeRepository _envelopeRepository;
  final TransactionRepository _transactionRepository;
  final String _budgetId;
  final SharingRepository? _sharingRepository;
  final DateTime Function() _now;

  StreamSubscription<Budget>? _budgetSubscription;
  StreamSubscription<List<BudgetPeriod>>? _periodsSubscription;
  StreamSubscription<List<Account>>? _accountsSubscription;
  StreamSubscription<List<Envelope>>? _envelopesSubscription;
  StreamSubscription<List<CategoryGroup>>? _groupsSubscription;
  StreamSubscription<List<EnvelopeAllocation>>? _allocationsSubscription;
  StreamSubscription<List<Transaction>>? _transactionsSubscription;
  StreamSubscription<void>? _remoteChangeSubscription;
  StreamController<void>? _remoteChangeMergeController;

  List<RealtimeChannel> _realtimeChannels = [];
  RealtimeChannel? _allocationRealtimeChannel;

  int _generation = 0;
  int _allocationsGeneration = 0;

  /// Last observed seed-cash anchor `(openingBalance, openingDate)`. Stored to
  /// suppress redundant RTA refreshes when an unrelated budget field changes
  /// (e.g. `name`, `isArchived`) — only diffs that affect RTA trigger work.
  ///
  /// Reset to `null` in [_onStarted] BEFORE the new subscription is created;
  /// the generation guard on `_BudgetUpdated` rejects late events from the
  /// prior subscription, so the reset cannot leak a stale anchor.
  _OpeningAnchor? _lastOpeningAnchor;

  bool _signedOut = false;

  bool _periodsReceived = false;
  bool _accountsReceived = false;
  bool _envelopesReceived = false;
  bool _groupsReceived = false;
  bool _transactionsReceived = false;
  bool _waitingForAllocations = false;

  /// True once the user has manually navigated to a non-current period. Keeps
  /// the periods stream from snapping the selection back to "today" on every
  /// re-fire (remote change, refresh). Reset on [DashboardStarted].
  bool _manualPeriodSelected = false;

  bool get _isLoaded =>
      _periodsReceived &&
      _accountsReceived &&
      _envelopesReceived &&
      _groupsReceived &&
      _transactionsReceived &&
      !_waitingForAllocations;

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));

    _generation++;
    _allocationsGeneration++;
    _periodsReceived = false;
    _accountsReceived = false;
    _envelopesReceived = false;
    _groupsReceived = false;
    _transactionsReceived = false;
    _waitingForAllocations = false;
    _manualPeriodSelected = false;
    _lastOpeningAnchor = null;

    await Future.wait([
      _budgetSubscription?.cancel() ?? Future<void>.value(),
      _periodsSubscription?.cancel() ?? Future<void>.value(),
      _accountsSubscription?.cancel() ?? Future<void>.value(),
      _envelopesSubscription?.cancel() ?? Future<void>.value(),
      _groupsSubscription?.cancel() ?? Future<void>.value(),
      _allocationsSubscription?.cancel() ?? Future<void>.value(),
      _transactionsSubscription?.cancel() ?? Future<void>.value(),
    ]);

    // Subscribe to Supabase Realtime channels early so live changes that
    // arrive during the initial API refresh are written to local DB and
    // captured by the watch streams when they subscribe below.
    for (final ch in _realtimeChannels) {
      ch.unsubscribe();
    }
    _realtimeChannels = [
      _accountRepository.subscribeToRealtimeChanges(_budgetId),
      _budgetRepository.subscribeToBudgetChanges(_budgetId),
      _budgetRepository.subscribeToPeriodChanges(_budgetId),
      _envelopeRepository.subscribeToEnvelopeChanges(_budgetId),
      _envelopeRepository.subscribeToCategoryGroupChanges(_budgetId),
      _transactionRepository.subscribeToTransactionChanges(_budgetId),
      _sharingRepository?.subscribeToBudgetChanges(_budgetId),
    ].whereType<RealtimeChannel>().toList();

    await _remoteChangeSubscription?.cancel();
    _remoteChangeMergeController?.close();
    _remoteChangeSubscription = _mergeRemoteChangeStreams().listen(
      (_) {
        if (!isClosed) add(const _RemoteChangeReceived());
      },
      onError: (Object e) {
        debugPrint('Error in merge stream: $e');
        /* Ignore merge stream errors. */
      },
    );

    // Refresh from API first so local DB is populated before watch streams
    // subscribe. This prevents the race where empty DB emissions set all
    // _xxxReceived flags to true before any real data arrives, causing the
    // dashboard to transition to loaded with empty lists.
    await Future.wait([
      _safeRefresh(
        () => _budgetRepository.refreshBudgetPeriods(_budgetId),
      ),
      _safeRefresh(
        () => _accountRepository.refreshAccounts(_budgetId),
      ),
      _safeRefresh(
        () => _envelopeRepository.refreshEnvelopes(_budgetId),
      ),
      _safeRefresh(
        () => _envelopeRepository.refreshCategoryGroups(_budgetId),
      ),
      _safeRefresh(
        () => _transactionRepository.refreshTransactions(_budgetId),
      ),
    ]);

    // Subscribe to watch streams after API refresh — first emission has
    // fresh data so the dashboard loads correctly on first open.
    final gen = _generation;

    _budgetSubscription = _budgetRepository.watchBudget(_budgetId).listen(
      (budget) => add(_BudgetUpdated(budget, gen)),
      // A transient watch error here only blocks anchor-shift refreshes; the
      // rest of the dashboard remains usable. Swallow rather than flip the
      // whole dashboard to error (matches the "keep previous value" stance in
      // [_onBudgetUpdated]).
      onError: (Object _) {},
    );

    _periodsSubscription = _budgetRepository
        .watchBudgetPeriods(_budgetId)
        .listen(
          (periods) => add(_PeriodsUpdated(periods, gen)),
          onError: (Object _) => add(const _DashboardStreamError()),
        );

    _accountsSubscription = _accountRepository
        .watchAccounts(_budgetId)
        .listen(
          (accounts) => add(_AccountsUpdated(accounts, gen)),
          onError: (Object _) => add(const _DashboardStreamError()),
        );

    _envelopesSubscription = _envelopeRepository
        .watchEnvelopes(_budgetId)
        .listen(
          (envelopes) => add(_EnvelopesUpdated(envelopes, gen)),
          onError: (Object _) => add(const _DashboardStreamError()),
        );

    _groupsSubscription = _envelopeRepository
        .watchCategoryGroups(_budgetId)
        .listen(
          (groups) => add(_CategoryGroupsUpdated(groups, gen)),
          onError: (Object _) => add(const _DashboardStreamError()),
        );

    _transactionsSubscription = _transactionRepository
        .watchTransactions(budgetId: _budgetId)
        .listen(
          (transactions) => add(_RecentTransactionsUpdated(transactions, gen)),
          onError: (Object _) => add(const _DashboardStreamError()),
        );
  }

  Future<void> _onBudgetUpdated(
    _BudgetUpdated event,
    Emitter<DashboardState> emit,
  ) async {
    if (event.generation != _generation) return;

    final anchor = (event.budget.openingBalance, event.budget.openingDate);
    if (_lastOpeningAnchor == anchor) return;
    final previousAnchor = _lastOpeningAnchor;
    _lastOpeningAnchor = anchor;

    // Periods stream not yet emitted → no period to refresh RTA for. The
    // cache is still updated above so future identical emissions dedup
    // correctly; `_onPeriodsUpdated` will read the current budget when it
    // computes the initial RTA, so the new anchor lands without us
    // recomputing here.
    final selected = state.selectedPeriod;
    if (selected == null) return;

    // First non-trivial emission with a selected period — `_onPeriodsUpdated`
    // already computed RTA against this anchor, no extra refresh needed.
    if (previousAnchor == null) return;

    try {
      final readyToAssign = await _budgetRepository.calculateReadyToAssign(
        selected.id,
      );
      emit(state.copyWith(readyToAssign: readyToAssign));
    } on BudgetException {
      // Keep previous value.
    }
  }

  Future<void> _onPeriodsUpdated(
    _PeriodsUpdated event,
    Emitter<DashboardState> emit,
  ) async {
    if (event.generation != _generation) return;
    _periodsReceived = true;

    final sortedPeriods = [...event.periods]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    // Select the current (non-closed) period containing today.
    BudgetPeriod? selected;
    if (sortedPeriods.isNotEmpty) {
      final now = DateUtils.dateOnly(_now());
      // If the latest period ends before "now", create the missing periods
      // forward and bail; the watch stream will re-fire this handler with
      // the new period list. Compare date-only so a period ending today
      // (endDate stored at 00:00) isn't treated as "before" a wall-clock
      // `now` later in the same day.
      final latest = sortedPeriods.last;
      if (DateUtils.dateOnly(latest.endDate).isBefore(now)) {
        try {
          await _budgetRepository.ensureCurrentPeriod(_budgetId, asOf: now);
          return;
        } on BudgetException {
          // Fall through to existing selection on failure.
        }
      }
      // Preserve a user-chosen period across stream re-fires, as long as it
      // still exists. Otherwise fall back to the period containing today.
      if (_manualPeriodSelected && state.selectedPeriod != null) {
        selected = sortedPeriods
            .where((p) => p.id == state.selectedPeriod!.id)
            .firstOrNull;
      }
      selected ??= sortedPeriods.firstWhere(
        (p) =>
            !p.isClosed &&
            !DateUtils.dateOnly(p.startDate).isAfter(now) &&
            !DateUtils.dateOnly(p.endDate).isBefore(now),
        orElse: () =>
            sortedPeriods.where((p) => !p.isClosed).lastOrNull ??
            sortedPeriods.last,
      );
    }

    final previousPeriodId = state.selectedPeriod?.id;
    if (selected != null && selected.id != previousPeriodId) {
      _waitingForAllocations = true;
    }

    emit(
      state.copyWith(
        status: _isLoaded ? DashboardStatus.loaded : state.status,
        selectedPeriod: selected,
        periods: sortedPeriods,
      ),
    );

    // Subscribe to allocations for the selected period.
    if (selected != null && selected.id != previousPeriodId) {
      await _subscribeToAllocations(selected.id);
    }

    // Compute ready to assign.
    if (selected != null) {
      try {
        final readyToAssign = await _budgetRepository.calculateReadyToAssign(
          selected.id,
        );
        emit(state.copyWith(readyToAssign: readyToAssign));
      } on BudgetException {
        // Keep previous value.
      }
    }
  }

  Future<void> _onPreviousPeriod(
    DashboardPreviousPeriodRequested event,
    Emitter<DashboardState> emit,
  ) => _selectAdjacentPeriod(emit, -1);

  Future<void> _onNextPeriod(
    DashboardNextPeriodRequested event,
    Emitter<DashboardState> emit,
  ) => _selectAdjacentPeriod(emit, 1);

  /// Moves the selection [delta] periods (oldest-first order) and rebinds the
  /// allocation stream / Ready-to-Assign to the new period. No-op at the ends.
  Future<void> _selectAdjacentPeriod(
    Emitter<DashboardState> emit,
    int delta,
  ) async {
    final sorted = state.sortedPeriods;
    final idx = sorted.indexWhere((p) => p.id == state.selectedPeriod?.id);
    final newIdx = idx + delta;
    if (idx < 0 || newIdx < 0 || newIdx >= sorted.length) return;

    final newPeriod = sorted[newIdx];
    _manualPeriodSelected = true;
    // Keep prior allocations/RTA visible during the refresh so AnimatedCents
    // tweens old→new instead of old→0→new. _onAllocationsUpdated swaps them
    // atomically when the new period's data arrives.
    emit(state.copyWith(selectedPeriod: newPeriod));
    await _subscribeToAllocations(newPeriod.id);
  }

  void _onAccountsUpdated(
    _AccountsUpdated event,
    Emitter<DashboardState> emit,
  ) {
    if (event.generation != _generation) return;
    _accountsReceived = true;
    emit(
      state.copyWith(
        status: _isLoaded ? DashboardStatus.loaded : state.status,
        accounts: event.accounts,
      ),
    );
    unawaited(_fetchCcCreditLimits(event.accounts));
  }

  Future<void> _fetchCcCreditLimits(List<Account> accounts) async {
    final ccAccounts = accounts.where((a) => isCreditCard(a.type)).toList();
    if (ccAccounts.isEmpty) return;
    final limits = <String, int?>{};
    for (final account in ccAccounts) {
      try {
        final debt = await _accountRepository.getDebtAccount(account.id);
        limits[account.id] = debt?.creditLimit;
      } on Exception {
        // Non-critical; skip this account.
      }
    }
    if (!isClosed) add(_CcCreditLimitsLoaded(limits));
  }

  void _onCcCreditLimitsLoaded(
    _CcCreditLimitsLoaded event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(ccCreditLimits: event.limits));
  }

  void _onEnvelopesUpdated(
    _EnvelopesUpdated event,
    Emitter<DashboardState> emit,
  ) {
    if (event.generation != _generation) return;
    _envelopesReceived = true;
    emit(
      state.copyWith(
        status: _isLoaded ? DashboardStatus.loaded : state.status,
        envelopes: event.envelopes,
      ),
    );
  }

  void _onCategoryGroupsUpdated(
    _CategoryGroupsUpdated event,
    Emitter<DashboardState> emit,
  ) {
    if (event.generation != _generation) return;
    _groupsReceived = true;
    emit(
      state.copyWith(
        status: _isLoaded ? DashboardStatus.loaded : state.status,
        categoryGroups: event.categoryGroups,
      ),
    );
  }

  Future<void> _onAllocationsUpdated(
    _AllocationsUpdated event,
    Emitter<DashboardState> emit,
  ) async {
    if (event.generation != _allocationsGeneration) return;
    _waitingForAllocations = false;

    emit(
      state.copyWith(
        status: _isLoaded ? DashboardStatus.loaded : state.status,
        allocations: event.allocations,
      ),
    );

    // Recompute ready to assign when allocations change.
    if (state.selectedPeriod != null) {
      try {
        final readyToAssign = await _budgetRepository.calculateReadyToAssign(
          state.selectedPeriod!.id,
        );
        emit(state.copyWith(readyToAssign: readyToAssign));
      } on BudgetException {
        // Keep previous value.
      }
    }
  }

  void _onRecentTransactionsUpdated(
    _RecentTransactionsUpdated event,
    Emitter<DashboardState> emit,
  ) {
    if (event.generation != _generation) return;
    final wasAlreadyReceived = _transactionsReceived;
    _transactionsReceived = true;

    // Sort by date descending and take last 5.
    final sorted = [...event.transactions]
      ..sort((a, b) => b.date.compareTo(a.date));
    final recent = sorted.take(5).toList();

    emit(
      state.copyWith(
        status: _isLoaded ? DashboardStatus.loaded : state.status,
        recentTransactions: recent,
        transactions: sorted,
      ),
    );

    // Refresh allocations so envelope available amounts reflect the change.
    if (wasAlreadyReceived && state.selectedPeriod != null) {
      unawaited(
        _envelopeRepository.refreshAllocations(state.selectedPeriod!.id),
      );
    }
  }

  void _onStreamError(
    _DashboardStreamError event,
    Emitter<DashboardState> emit,
  ) {
    // Reset waiting flag so the dashboard doesn't get stuck in loading
    // if the allocations stream was the one that errored.
    _waitingForAllocations = false;

    emit(
      state.copyWith(
        status: DashboardStatus.error,
        error: DashboardError.loadFailed,
      ),
    );
    emit(state.copyWith(status: DashboardStatus.loaded, error: null));
  }

  Future<void> _onRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final futures = <Future<void>>[
      _safeRefresh(
        () => _budgetRepository.refreshBudgetPeriods(_budgetId),
      ),
      _safeRefresh(
        () => _accountRepository.refreshAccounts(_budgetId),
      ),
      _safeRefresh(
        () => _envelopeRepository.refreshEnvelopes(_budgetId),
      ),
      _safeRefresh(
        () => _envelopeRepository.refreshCategoryGroups(_budgetId),
      ),
      _safeRefresh(
        () => _transactionRepository.refreshTransactions(_budgetId),
      ),
    ];
    if (state.selectedPeriod != null) {
      futures.add(
        _safeRefresh(
          () =>
              _envelopeRepository.refreshAllocations(state.selectedPeriod!.id),
        ),
      );
    }
    await Future.wait(futures);
  }

  Future<void> _onQuickAllocationRequested(
    QuickAllocationRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final periodId = state.selectedPeriod?.id;
    if (periodId == null) return;

    try {
      // Look up the current allocation from state to avoid stale data.
      final currentAllocation = state.allocations
          .where((a) => a.envelopeId == event.envelopeId)
          .firstOrNull;

      if (currentAllocation != null) {
        await _envelopeRepository.updateAllocation(
          currentAllocation.copyWith(allocatedAmount: event.amount),
        );
      } else {
        await _envelopeRepository.allocate(
          envelopeId: event.envelopeId,
          budgetPeriodId: periodId,
          amount: event.amount,
        );
      }

      // Recompute ready to assign after allocation change.
      try {
        final readyToAssign = await _budgetRepository.calculateReadyToAssign(
          periodId,
        );
        emit(state.copyWith(readyToAssign: readyToAssign));
      } on BudgetException {
        // Keep previous value.
      }
    } on EnvelopeException {
      emit(
        state.copyWith(
          status: DashboardStatus.error,
          error: DashboardError.allocationFailed,
        ),
      );
      emit(state.copyWith(status: DashboardStatus.loaded, error: null));
    }
  }

  Future<void> _onBudgetDeleteRequested(
    BudgetDeleteRequested event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      await _budgetRepository.deleteBudget(_budgetId);
      emit(state.copyWith(status: DashboardStatus.budgetDeleted));
    } on BudgetException {
      emit(
        state.copyWith(
          status: DashboardStatus.error,
          error: DashboardError.loadFailed,
        ),
      );
      emit(state.copyWith(status: DashboardStatus.loaded, error: null));
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Calls [fn] and swallows any repository exception so that a single
  /// failing refresh does not prevent other parallel refreshes from running.
  Future<void> _safeRefresh(Future<void> Function() fn) async {
    try {
      await fn();
    } on Exception {
      // Local watch streams will still show cached data.
    }
  }

  Future<void> _subscribeToAllocations(String periodId) async {
    _waitingForAllocations = true;
    _allocationsGeneration++;
    await _allocationsSubscription?.cancel();

    // Refresh from API before subscribing so the first watch emission has
    // fresh spentAmount values (avoids a stale flash when navigating back).
    try {
      await _envelopeRepository.refreshAllocations(periodId);
    } on EnvelopeException {
      // Keep cached data if refresh fails.
    }

    // Resubscribe allocation Realtime channel for the new period.
    _allocationRealtimeChannel?.unsubscribe();
    _allocationRealtimeChannel = _envelopeRepository
        .subscribeToAllocationChanges(periodId);

    final gen = _allocationsGeneration;
    _allocationsSubscription = _envelopeRepository
        .watchAllocations(periodId)
        .listen(
          (allocations) => add(_AllocationsUpdated(allocations, gen)),
          onError: (Object _) => add(const _DashboardStreamError()),
        );
  }

  // Stops remote-update snackbars from cascade-delete events on sign-out.
  void cancelRealtimeSubscriptions() {
    _signedOut = true;
    for (final ch in _realtimeChannels) {
      unawaited(ch.unsubscribe());
    }
    unawaited(_allocationRealtimeChannel?.unsubscribe() ?? Future.value());
    unawaited(_remoteChangeSubscription?.cancel() ?? Future.value());
  }

  Future<void> _onRemoteChangeReceived(
    _RemoteChangeReceived event,
    Emitter<DashboardState> emit,
  ) async {
    if (_signedOut) return;
    emit(state.copyWith(hasRemoteUpdate: true));
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!isClosed) {
      emit(state.copyWith(hasRemoteUpdate: false));
    }
  }

  Stream<void> _mergeRemoteChangeStreams() {
    final streams = <Stream<void>>[
      _accountRepository.onRemoteChange,
      _budgetRepository.onRemoteChange,
      _envelopeRepository.onRemoteChange,
      _transactionRepository.onRemoteChange,
    ];
    final subscriptions = <StreamSubscription<void>>[];
    late final StreamController<void> controller;
    controller = StreamController<void>.broadcast(
      onListen: () {
        for (final stream in streams) {
          subscriptions.add(
            stream.listen((_) {
              if (!controller.isClosed) controller.add(null);
            }),
          );
        }
      },
      onCancel: () {
        for (final sub in subscriptions) {
          sub.cancel();
        }
      },
    );
    _remoteChangeMergeController = controller;
    return controller.stream;
  }

  @override
  Future<void> close() async {
    // Unsubscribe Realtime channels first so no new events arrive during
    // the remaining async cleanup steps.
    await Future.wait([
      for (final ch in _realtimeChannels) ch.unsubscribe(),
      if (_allocationRealtimeChannel != null)
        _allocationRealtimeChannel!.unsubscribe(),
    ]);
    await _remoteChangeSubscription?.cancel();
    await _remoteChangeMergeController?.close();

    await _budgetSubscription?.cancel();
    await _periodsSubscription?.cancel();
    await _accountsSubscription?.cancel();
    await _envelopesSubscription?.cancel();
    await _groupsSubscription?.cancel();
    await _allocationsSubscription?.cancel();
    await _transactionsSubscription?.cancel();
    return super.close();
  }
}
