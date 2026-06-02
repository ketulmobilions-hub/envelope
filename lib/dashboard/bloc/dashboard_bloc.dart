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

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required BudgetRepository budgetRepository,
    required AccountRepository accountRepository,
    required EnvelopeRepository envelopeRepository,
    required TransactionRepository transactionRepository,
    required String budgetId,
    SharingRepository? sharingRepository,
  }) : _budgetRepository = budgetRepository,
       _accountRepository = accountRepository,
       _envelopeRepository = envelopeRepository,
       _transactionRepository = transactionRepository,
       _budgetId = budgetId,
       _sharingRepository = sharingRepository,
       super(const DashboardState()) {
    on<DashboardStarted>(_onStarted);
    on<_AccountsUpdated>(_onAccountsUpdated);
    on<_AllocationsUpdated>(_onAllocationsUpdated);
    on<_EnvelopesUpdated>(_onEnvelopesUpdated);
    on<_CategoryGroupsUpdated>(_onCategoryGroupsUpdated);
    on<_RecentTransactionsUpdated>(_onRecentTransactionsUpdated);
    on<_ReadyToAssignUpdated>(_onReadyToAssignUpdated);
    on<_SpentByEnvelopeUpdated>(_onSpentByEnvelopeUpdated);
    on<_RemoteChangeReceived>(_onRemoteChangeReceived);
    on<_DashboardStreamError>(_onStreamError);
    on<DashboardRefreshRequested>(_onRefreshRequested);
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

  StreamSubscription<List<Account>>? _accountsSubscription;
  StreamSubscription<List<Envelope>>? _envelopesSubscription;
  StreamSubscription<List<CategoryGroup>>? _groupsSubscription;
  StreamSubscription<List<EnvelopeAllocation>>? _allocationsSubscription;
  StreamSubscription<List<Transaction>>? _transactionsSubscription;
  StreamSubscription<Map<String, int>>? _spentByEnvelopeSubscription;
  StreamSubscription<int>? _readyToAssignSubscription;
  StreamSubscription<void>? _remoteChangeSubscription;
  StreamController<void>? _remoteChangeMergeController;

  List<RealtimeChannel> _realtimeChannels = [];

  int _generation = 0;

  bool _signedOut = false;

  bool _accountsReceived = false;
  bool _envelopesReceived = false;
  bool _groupsReceived = false;
  bool _allocationsReceived = false;
  bool _transactionsReceived = false;

  bool get _isLoaded =>
      _accountsReceived &&
      _envelopesReceived &&
      _groupsReceived &&
      _allocationsReceived &&
      _transactionsReceived;

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));

    _generation++;
    _accountsReceived = false;
    _envelopesReceived = false;
    _groupsReceived = false;
    _allocationsReceived = false;
    _transactionsReceived = false;

    await Future.wait([
      _accountsSubscription?.cancel() ?? Future<void>.value(),
      _envelopesSubscription?.cancel() ?? Future<void>.value(),
      _groupsSubscription?.cancel() ?? Future<void>.value(),
      _allocationsSubscription?.cancel() ?? Future<void>.value(),
      _transactionsSubscription?.cancel() ?? Future<void>.value(),
      _spentByEnvelopeSubscription?.cancel() ?? Future<void>.value(),
      _readyToAssignSubscription?.cancel() ?? Future<void>.value(),
    ]);

    for (final ch in _realtimeChannels) {
      ch.unsubscribe();
    }
    _realtimeChannels = [
      _accountRepository.subscribeToRealtimeChanges(_budgetId),
      _budgetRepository.subscribeToBudgetChanges(_budgetId),
      _envelopeRepository.subscribeToEnvelopeChanges(_budgetId),
      _envelopeRepository.subscribeToCategoryGroupChanges(_budgetId),
      _envelopeRepository.subscribeToAllocationChanges(_budgetId),
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
      },
    );

    await Future.wait([
      _safeRefresh(() => _accountRepository.refreshAccounts(_budgetId)),
      _safeRefresh(() => _envelopeRepository.refreshEnvelopes(_budgetId)),
      _safeRefresh(() => _envelopeRepository.refreshCategoryGroups(_budgetId)),
      _safeRefresh(() => _envelopeRepository.refreshAllocations(_budgetId)),
      _safeRefresh(() => _transactionRepository.refreshTransactions(_budgetId)),
    ]);

    final gen = _generation;

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

    _allocationsSubscription = _envelopeRepository
        .watchAllocationsByBudgetId(_budgetId)
        .listen(
          (allocations) => add(_AllocationsUpdated(allocations, gen)),
          onError: (Object _) => add(const _DashboardStreamError()),
        );

    _transactionsSubscription = _transactionRepository
        .watchTransactions(budgetId: _budgetId)
        .listen(
          (transactions) => add(_RecentTransactionsUpdated(transactions, gen)),
          onError: (Object _) => add(const _DashboardStreamError()),
        );

    _readyToAssignSubscription = _budgetRepository
        .watchReadyToAssign(_budgetId)
        .listen(
          (rta) => add(_ReadyToAssignUpdated(rta, gen)),
          onError: (Object _) {},
        );

    _spentByEnvelopeSubscription = _envelopeRepository
        .watchSpentByEnvelopeForBudget(_budgetId)
        .listen(
          (spent) => add(_SpentByEnvelopeUpdated(spent, gen)),
          onError: (Object _) => add(const _DashboardStreamError()),
        );
  }

  void _onReadyToAssignUpdated(
    _ReadyToAssignUpdated event,
    Emitter<DashboardState> emit,
  ) {
    if (event.generation != _generation) return;
    emit(state.copyWith(readyToAssign: event.readyToAssign));
  }

  void _onSpentByEnvelopeUpdated(
    _SpentByEnvelopeUpdated event,
    Emitter<DashboardState> emit,
  ) {
    if (event.generation != _generation) return;
    emit(state.copyWith(spentByEnvelope: event.spentByEnvelope));
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

  void _onAllocationsUpdated(
    _AllocationsUpdated event,
    Emitter<DashboardState> emit,
  ) {
    if (event.generation != _generation) return;
    _allocationsReceived = true;
    emit(
      state.copyWith(
        status: _isLoaded ? DashboardStatus.loaded : state.status,
        allocations: event.allocations,
      ),
    );
  }

  void _onRecentTransactionsUpdated(
    _RecentTransactionsUpdated event,
    Emitter<DashboardState> emit,
  ) {
    if (event.generation != _generation) return;
    _transactionsReceived = true;

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
  }

  void _onStreamError(
    _DashboardStreamError event,
    Emitter<DashboardState> emit,
  ) {
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
    await Future.wait([
      _safeRefresh(() => _accountRepository.refreshAccounts(_budgetId)),
      _safeRefresh(() => _envelopeRepository.refreshEnvelopes(_budgetId)),
      _safeRefresh(() => _envelopeRepository.refreshCategoryGroups(_budgetId)),
      _safeRefresh(() => _envelopeRepository.refreshAllocations(_budgetId)),
      _safeRefresh(() => _transactionRepository.refreshTransactions(_budgetId)),
    ]);
  }

  Future<void> _onQuickAllocationRequested(
    QuickAllocationRequested event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      await _envelopeRepository.allocate(
        envelopeId: event.envelopeId,
        amount: event.amount,
      );
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

  Future<void> _safeRefresh(Future<void> Function() fn) async {
    try {
      await fn();
    } on Exception {
      // Local watch streams will still show cached data.
    }
  }

  void cancelRealtimeSubscriptions() {
    _signedOut = true;
    for (final ch in _realtimeChannels) {
      unawaited(ch.unsubscribe());
    }
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
    await Future.wait([for (final ch in _realtimeChannels) ch.unsubscribe()]);
    await _remoteChangeSubscription?.cancel();
    await _remoteChangeMergeController?.close();

    await _accountsSubscription?.cancel();
    await _envelopesSubscription?.cancel();
    await _groupsSubscription?.cancel();
    await _allocationsSubscription?.cancel();
    await _transactionsSubscription?.cancel();
    await _spentByEnvelopeSubscription?.cancel();
    await _readyToAssignSubscription?.cancel();
    return super.close();
  }
}
