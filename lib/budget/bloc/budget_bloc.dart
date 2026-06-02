import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'budget_event.dart';
part 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc({
    required BudgetRepository budgetRepository,
    required EnvelopeRepository envelopeRepository,
    required GoalRepository goalRepository,
    required TransactionRepository transactionRepository,
    required String budgetId,
    DateTime Function()? now,
  }) : _budgetRepository = budgetRepository,
       _envelopeRepository = envelopeRepository,
       _goalRepository = goalRepository,
       _transactionRepository = transactionRepository,
       _budgetId = budgetId,
       super(BudgetState()) {
    on<BudgetStarted>(_onStarted);
    on<_AllocationsUpdated>(_onAllocationsUpdated);
    on<_CategoryGroupsUpdated>(_onCategoryGroupsUpdated);
    on<_EnvelopesUpdated>(_onEnvelopesUpdated);
    on<_TransactionsChanged>(_onTransactionsChanged);
    on<_SpentByEnvelopeUpdated>(_onSpentByEnvelopeUpdated);
    on<_TemplatesUpdated>(_onTemplatesUpdated);
    on<_GoalsUpdated>(_onGoalsUpdated);
    on<_ReadyToAssignUpdated>(_onReadyToAssignUpdated);
    on<_BudgetStreamError>(_onStreamError);
    on<BudgetRefreshRequested>(_onRefreshRequested);
    on<AllocationAmountChanged>(_onAllocationAmountChanged);
    on<AllocationsSaveRequested>(_onAllocationsSaveRequested);
    on<EnvelopeTransferRequested>(_onTransferRequested);
    on<AllocationTemplateApplied>(_onTemplateApplied);
    on<AllocationTemplateCreated>(_onTemplateCreated);
    on<AllocationTemplateUpdated>(_onTemplateUpdated);
    on<AllocationTemplateDeleted>(_onTemplateDeleted);
  }

  final BudgetRepository _budgetRepository;
  final EnvelopeRepository _envelopeRepository;
  final GoalRepository _goalRepository;
  final TransactionRepository _transactionRepository;
  final String _budgetId;

  StreamSubscription<List<EnvelopeAllocation>>? _allocationsSubscription;
  StreamSubscription<List<CategoryGroup>>? _groupsSubscription;
  StreamSubscription<List<Envelope>>? _envelopesSubscription;
  StreamSubscription<List<AllocationTemplate>>? _templatesSubscription;
  StreamSubscription<List<Goal>>? _goalsSubscription;
  StreamSubscription<List<Transaction>>? _transactionsSubscription;
  StreamSubscription<Map<String, int>>? _spentByEnvelopeSubscription;
  StreamSubscription<int>? _readyToAssignSubscription;

  /// Incremented on each BudgetStarted to discard stale events from prior
  /// subscriptions.
  int _generation = 0;

  bool _allocationsReceived = false;
  bool _groupsReceived = false;
  bool _envelopesReceived = false;
  bool _templatesReceived = false;

  /// True once all four budget-level streams have emitted at least once.
  bool get _isLoaded =>
      _allocationsReceived &&
      _groupsReceived &&
      _envelopesReceived &&
      _templatesReceived;

  Future<void> _onStarted(
    BudgetStarted event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading));

    _generation++;
    _allocationsReceived = false;
    _groupsReceived = false;
    _envelopesReceived = false;
    _templatesReceived = false;

    await Future.wait([
      _allocationsSubscription?.cancel() ?? Future<void>.value(),
      _groupsSubscription?.cancel() ?? Future<void>.value(),
      _envelopesSubscription?.cancel() ?? Future<void>.value(),
      _templatesSubscription?.cancel() ?? Future<void>.value(),
      _goalsSubscription?.cancel() ?? Future<void>.value(),
      _transactionsSubscription?.cancel() ?? Future<void>.value(),
      _spentByEnvelopeSubscription?.cancel() ?? Future<void>.value(),
      _readyToAssignSubscription?.cancel() ?? Future<void>.value(),
    ]);

    final gen = _generation;

    _allocationsSubscription = _envelopeRepository
        .watchAllocationsByBudgetId(_budgetId)
        .listen(
          (allocations) => add(_AllocationsUpdated(allocations, gen)),
          onError: (Object _) => add(const _BudgetStreamError()),
        );

    _groupsSubscription = _envelopeRepository
        .watchCategoryGroups(_budgetId)
        .listen(
          (groups) => add(_CategoryGroupsUpdated(groups, gen)),
          onError: (Object _) => add(const _BudgetStreamError()),
        );

    _envelopesSubscription = _envelopeRepository
        .watchEnvelopes(_budgetId)
        .listen(
          (envelopes) => add(_EnvelopesUpdated(envelopes, gen)),
          onError: (Object _) => add(const _BudgetStreamError()),
        );

    _templatesSubscription = _budgetRepository
        .watchAllocationTemplates(_budgetId)
        .listen(
          (templates) => add(_TemplatesUpdated(templates, gen)),
          onError: (Object _) => add(const _BudgetStreamError()),
        );

    _goalsSubscription = _goalRepository
        .watchGoals(_budgetId)
        .listen(
          (goals) => add(_GoalsUpdated(goals, gen)),
          onError: (Object _) => add(const _BudgetStreamError()),
        );

    _transactionsSubscription = _transactionRepository
        .watchTransactions(budgetId: _budgetId)
        .listen(
          (_) => add(_TransactionsChanged(gen)),
          onError: (Object _) => add(const _BudgetStreamError()),
        );

    _spentByEnvelopeSubscription = _envelopeRepository
        .watchSpentByEnvelopeForBudget(_budgetId)
        .listen(
          (spent) => add(_SpentByEnvelopeUpdated(spent, gen)),
          onError: (Object _) => add(const _BudgetStreamError()),
        );

    _readyToAssignSubscription = _budgetRepository
        .watchReadyToAssign(_budgetId)
        .listen(
          (rta) => add(_ReadyToAssignUpdated(rta, gen)),
          onError: (Object _) {},
        );

    try {
      await Future.wait([
        _envelopeRepository.refreshCategoryGroups(_budgetId),
        _envelopeRepository.refreshEnvelopes(_budgetId),
        _envelopeRepository.refreshAllocations(_budgetId),
        _budgetRepository.refreshAllocationTemplates(_budgetId),
        _goalRepository.refreshGoals(_budgetId),
      ]);
    } on BudgetException {
      // Local watch will still show cached data.
    } on EnvelopeException {
      // Local watch will still show cached data.
    } on GoalException {
      // Local watch will still show cached data.
    }
  }

  void _onGoalsUpdated(_GoalsUpdated event, Emitter<BudgetState> emit) {
    if (event.generation != _generation) return;
    emit(state.copyWith(goals: event.goals));
  }

  void _onReadyToAssignUpdated(
    _ReadyToAssignUpdated event,
    Emitter<BudgetState> emit,
  ) {
    if (event.generation != _generation) return;
    emit(state.copyWith(readyToAssign: event.readyToAssign));
  }

  Future<void> _onAllocationsUpdated(
    _AllocationsUpdated event,
    Emitter<BudgetState> emit,
  ) async {
    if (event.generation != _generation) return;
    _allocationsReceived = true;

    final ccAvailable = await _computeCCPaymentAvailable(
      allocations: event.allocations,
      envelopes: state.envelopes,
    );

    emit(
      state.copyWith(
        status: _isLoaded ? BudgetStatus.loaded : state.status,
        allocations: event.allocations,
        ccPaymentAvailable: ccAvailable,
      ),
    );
  }

  Future<Map<String, int>> _computeCCPaymentAvailable({
    required List<EnvelopeAllocation> allocations,
    required List<Envelope> envelopes,
  }) async {
    final ccEnvelopes = envelopes.where((e) => e.linkedAccountId != null);
    final result = <String, int>{};
    // Bound the charges/payments sum to the current calendar month so the
    // value tracks this billing cycle rather than the lifetime delta.
    final now = DateTime.now();
    final periodStart = DateTime(now.year, now.month);
    final periodEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    for (final env in ccEnvelopes) {
      final alloc = allocations
          .where((a) => a.envelopeId == env.id)
          .firstOrNull;
      try {
        result[env.id] = await _envelopeRepository.calculateCCPaymentAvailable(
          allocation: alloc,
          ccAccountId: env.linkedAccountId!,
          periodStart: periodStart,
          periodEnd: periodEnd,
        );
      } on Exception {
        // Best-effort.
      }
    }
    return result;
  }

  Future<void> _onTransactionsChanged(
    _TransactionsChanged event,
    Emitter<BudgetState> emit,
  ) async {
    if (event.generation != _generation) return;
    // CC payment availability depends on transaction history but uses its
    // own DAO query, so just trigger the recompute here. spentByEnvelope is
    // emitted by a separate DAO stream that already folds in splits.
    final ccAvailable = await _computeCCPaymentAvailable(
      allocations: state.allocations,
      envelopes: state.envelopes,
    );
    emit(state.copyWith(ccPaymentAvailable: ccAvailable));
  }

  void _onSpentByEnvelopeUpdated(
    _SpentByEnvelopeUpdated event,
    Emitter<BudgetState> emit,
  ) {
    if (event.generation != _generation) return;
    emit(state.copyWith(spentByEnvelope: event.spentByEnvelope));
  }

  void _onCategoryGroupsUpdated(
    _CategoryGroupsUpdated event,
    Emitter<BudgetState> emit,
  ) {
    if (event.generation != _generation) return;
    _groupsReceived = true;
    emit(
      state.copyWith(
        status: _isLoaded ? BudgetStatus.loaded : state.status,
        categoryGroups: event.categoryGroups,
      ),
    );
  }

  Future<void> _onEnvelopesUpdated(
    _EnvelopesUpdated event,
    Emitter<BudgetState> emit,
  ) async {
    if (event.generation != _generation) return;
    _envelopesReceived = true;
    final ccAvailable = await _computeCCPaymentAvailable(
      allocations: state.allocations,
      envelopes: event.envelopes,
    );
    emit(
      state.copyWith(
        status: _isLoaded ? BudgetStatus.loaded : state.status,
        envelopes: event.envelopes,
        ccPaymentAvailable: ccAvailable,
      ),
    );
  }

  void _onTemplatesUpdated(
    _TemplatesUpdated event,
    Emitter<BudgetState> emit,
  ) {
    if (event.generation != _generation) return;
    _templatesReceived = true;
    emit(
      state.copyWith(
        status: _isLoaded ? BudgetStatus.loaded : state.status,
        templates: event.templates,
      ),
    );
  }

  void _onStreamError(_BudgetStreamError event, Emitter<BudgetState> emit) {
    emit(
      state.copyWith(
        status: BudgetStatus.error,
        error: BudgetError.loadFailed,
      ),
    );
    emit(state.copyWith(status: BudgetStatus.loaded, error: null));
  }

  Future<void> _onRefreshRequested(
    BudgetRefreshRequested event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading));
    try {
      await Future.wait([
        _envelopeRepository.refreshCategoryGroups(_budgetId),
        _envelopeRepository.refreshEnvelopes(_budgetId),
        _envelopeRepository.refreshAllocations(_budgetId),
        _budgetRepository.refreshAllocationTemplates(_budgetId),
        _goalRepository.refreshGoals(_budgetId),
      ]);
      emit(state.copyWith(status: BudgetStatus.loaded));
    } on BudgetException {
      emit(state.copyWith(status: BudgetStatus.loaded));
    } on EnvelopeException {
      emit(state.copyWith(status: BudgetStatus.loaded));
    } on GoalException {
      emit(state.copyWith(status: BudgetStatus.loaded));
    }
  }

  void _onAllocationAmountChanged(
    AllocationAmountChanged event,
    Emitter<BudgetState> emit,
  ) {
    final updated = Map<String, int>.from(state.localAllocations)
      ..[event.envelopeId] = event.amount;
    emit(state.copyWith(localAllocations: updated));
  }

  Future<void> _onAllocationsSaveRequested(
    AllocationsSaveRequested event,
    Emitter<BudgetState> emit,
  ) async {
    if (state.localAllocations.isEmpty) return;

    // Track which entries have NOT yet been saved so the user can retry only
    // the unsaved ones on partial failure.
    final remaining = Map<String, int>.from(state.localAllocations);

    try {
      for (final entry in state.localAllocations.entries) {
        final envelopeId = entry.key;
        final amount = entry.value;
        await _envelopeRepository.allocate(
          envelopeId: envelopeId,
          amount: amount,
        );
        remaining.remove(envelopeId);
      }
      emit(state.copyWith(localAllocations: const {}));
    } on EnvelopeException {
      emit(
        state.copyWith(
          localAllocations: remaining,
          status: BudgetStatus.error,
          error: BudgetError.allocationFailed,
        ),
      );
      emit(
        state.copyWith(
          localAllocations: remaining,
          status: BudgetStatus.loaded,
          error: null,
        ),
      );
    }
  }

  Future<void> _onTransferRequested(
    EnvelopeTransferRequested event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      await _budgetRepository.transferBetweenEnvelopes(
        fromAllocationId: event.fromAllocationId,
        toAllocationId: event.toAllocationId,
        amount: event.amount,
      );
    } on BudgetException {
      emit(
        state.copyWith(
          status: BudgetStatus.error,
          error: BudgetError.transferFailed,
        ),
      );
      emit(state.copyWith(status: BudgetStatus.loaded, error: null));
    }
  }

  Future<void> _onTemplateApplied(
    AllocationTemplateApplied event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      await _budgetRepository.applyAllocationTemplate(
        templateId: event.templateId,
        totalAmount: event.totalAmount,
      );
    } on BudgetException {
      emit(
        state.copyWith(
          status: BudgetStatus.error,
          error: BudgetError.templateFailed,
        ),
      );
      emit(state.copyWith(status: BudgetStatus.loaded, error: null));
    }
  }

  Future<void> _onTemplateCreated(
    AllocationTemplateCreated event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      await _budgetRepository.createAllocationTemplate(
        budgetId: _budgetId,
        name: event.name,
        items: event.items,
      );
    } on BudgetException {
      emit(
        state.copyWith(
          status: BudgetStatus.error,
          error: BudgetError.templateFailed,
        ),
      );
      emit(state.copyWith(status: BudgetStatus.loaded, error: null));
    }
  }

  Future<void> _onTemplateUpdated(
    AllocationTemplateUpdated event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      await _budgetRepository.updateAllocationTemplate(event.template);
    } on BudgetException {
      emit(
        state.copyWith(
          status: BudgetStatus.error,
          error: BudgetError.templateFailed,
        ),
      );
      emit(state.copyWith(status: BudgetStatus.loaded, error: null));
    }
  }

  Future<void> _onTemplateDeleted(
    AllocationTemplateDeleted event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      await _budgetRepository.deleteAllocationTemplate(event.templateId);
    } on BudgetException {
      emit(
        state.copyWith(
          status: BudgetStatus.error,
          error: BudgetError.templateFailed,
        ),
      );
      emit(state.copyWith(status: BudgetStatus.loaded, error: null));
    }
  }

  @override
  Future<void> close() async {
    await _allocationsSubscription?.cancel();
    await _groupsSubscription?.cancel();
    await _envelopesSubscription?.cancel();
    await _templatesSubscription?.cancel();
    await _goalsSubscription?.cancel();
    await _transactionsSubscription?.cancel();
    await _spentByEnvelopeSubscription?.cancel();
    await _readyToAssignSubscription?.cancel();
    return super.close();
  }
}
