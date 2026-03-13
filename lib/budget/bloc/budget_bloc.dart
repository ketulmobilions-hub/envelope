import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';

part 'budget_event.dart';
part 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc({
    required BudgetRepository budgetRepository,
    required EnvelopeRepository envelopeRepository,
    required String budgetId,
  })  : _budgetRepository = budgetRepository,
        _envelopeRepository = envelopeRepository,
        _budgetId = budgetId,
        super(BudgetState()) {
    on<BudgetStarted>(_onStarted);
    on<_PeriodsUpdated>(_onPeriodsUpdated);
    on<_AllocationsUpdated>(_onAllocationsUpdated);
    on<_CategoryGroupsUpdated>(_onCategoryGroupsUpdated);
    on<_EnvelopesUpdated>(_onEnvelopesUpdated);
    on<_TemplatesUpdated>(_onTemplatesUpdated);
    on<_BudgetStreamError>(_onStreamError);
    on<BudgetRefreshRequested>(_onRefreshRequested);
    on<BudgetPreviousPeriodRequested>(_onPreviousPeriod);
    on<BudgetNextPeriodRequested>(_onNextPeriod);
    on<AllocationAmountChanged>(_onAllocationAmountChanged);
    on<AllocationsSaveRequested>(_onAllocationsSaveRequested);
    on<EnvelopeTransferRequested>(_onTransferRequested);
    on<AllocationTemplateApplied>(_onTemplateApplied);
    on<AllocationTemplateCreated>(_onTemplateCreated);
    on<AllocationTemplateUpdated>(_onTemplateUpdated);
    on<AllocationTemplateDeleted>(_onTemplateDeleted);
    on<BudgetDuplicateFromPreviousPeriodRequested>(_onDuplicateFromPrevious);
  }

  final BudgetRepository _budgetRepository;
  final EnvelopeRepository _envelopeRepository;
  final String _budgetId;

  StreamSubscription<List<BudgetPeriod>>? _periodsSubscription;
  StreamSubscription<List<EnvelopeAllocation>>? _allocationsSubscription;
  StreamSubscription<List<CategoryGroup>>? _groupsSubscription;
  StreamSubscription<List<Envelope>>? _envelopesSubscription;
  StreamSubscription<List<AllocationTemplate>>? _templatesSubscription;

  // Incremented on each BudgetStarted to discard stale events from prior
  // budget-level subscriptions.
  int _generation = 0;

  // Incremented on each BudgetStarted or period change to discard stale
  // allocation events from the prior period subscription.
  int _allocationsGeneration = 0;

  bool _periodsReceived = false;
  bool _groupsReceived = false;
  bool _envelopesReceived = false;
  bool _templatesReceived = false;

  // True while waiting for the first allocations emission for the current
  // period. Prevents status flipping to loaded before allocations arrive.
  bool _waitingForAllocations = false;

  /// True once all four budget-level streams have emitted at least once AND
  /// the current period's allocations have been received.
  bool get _isLoaded =>
      _periodsReceived &&
      _groupsReceived &&
      _envelopesReceived &&
      _templatesReceived &&
      !_waitingForAllocations;

  Future<void> _onStarted(
    BudgetStarted event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading));

    _generation++;
    _allocationsGeneration++;
    _periodsReceived = false;
    _groupsReceived = false;
    _envelopesReceived = false;
    _templatesReceived = false;
    _waitingForAllocations = false;

    await Future.wait([
      _periodsSubscription?.cancel() ?? Future<void>.value(),
      _allocationsSubscription?.cancel() ?? Future<void>.value(),
      _groupsSubscription?.cancel() ?? Future<void>.value(),
      _envelopesSubscription?.cancel() ?? Future<void>.value(),
      _templatesSubscription?.cancel() ?? Future<void>.value(),
    ]);

    final gen = _generation;

    _periodsSubscription = _budgetRepository
        .watchBudgetPeriods(_budgetId)
        .listen(
          (periods) => add(_PeriodsUpdated(periods, gen)),
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

    try {
      await Future.wait([
        _budgetRepository.refreshBudgetPeriods(_budgetId),
        _envelopeRepository.refreshCategoryGroups(_budgetId),
        _envelopeRepository.refreshEnvelopes(_budgetId),
        _budgetRepository.refreshAllocationTemplates(_budgetId),
      ]);
    } on BudgetException {
      // Local watch will still show cached data.
    } on EnvelopeException {
      // Local watch will still show cached data.
    }
  }

  Future<void> _onPeriodsUpdated(
    _PeriodsUpdated event,
    Emitter<BudgetState> emit,
  ) async {
    if (event.generation != _generation) return;
    _periodsReceived = true;

    final sortedPeriods = [...event.periods]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    var selected = state.selectedPeriod;
    final previousSelectedId = state.selectedPeriod?.id;

    if (selected == null && sortedPeriods.isNotEmpty) {
      // Auto-select the period that contains today, or fall back to latest.
      final now = DateTime.now();
      selected = sortedPeriods.firstWhere(
        (p) => !p.startDate.isAfter(now) && !p.endDate.isBefore(now),
        orElse: () => sortedPeriods.last,
      );
    } else if (selected != null) {
      // Refresh selected period reference with latest data from stream.
      final fresh = sortedPeriods
          .where((p) => p.id == selected!.id)
          .firstOrNull;
      if (fresh != null) {
        selected = fresh;
      } else if (sortedPeriods.isNotEmpty) {
        // Period was removed — fall back to latest.
        selected = sortedPeriods.last;
      }
    }

    // Signal that we're waiting for allocations before marking loaded.
    if (selected != null && selected.id != previousSelectedId) {
      _waitingForAllocations = true;
    }

    emit(state.copyWith(
      status: _isLoaded ? BudgetStatus.loaded : state.status,
      periods: event.periods,
      selectedPeriod: selected,
    ));

    // Subscribe to allocations when period is determined or changed.
    if (selected != null && selected.id != previousSelectedId) {
      await _subscribeToAllocations(selected.id);
    }
  }

  Future<void> _onAllocationsUpdated(
    _AllocationsUpdated event,
    Emitter<BudgetState> emit,
  ) async {
    if (event.generation != _allocationsGeneration) return;
    _waitingForAllocations = false;

    var readyToAssign = state.readyToAssign;
    if (state.selectedPeriod != null) {
      try {
        readyToAssign = await _budgetRepository
            .calculateReadyToAssign(state.selectedPeriod!.id);
      } on BudgetException {
        // Keep previous value on error.
      }
    }

    emit(state.copyWith(
      status: _isLoaded ? BudgetStatus.loaded : state.status,
      allocations: event.allocations,
      readyToAssign: readyToAssign,
    ));
  }

  void _onCategoryGroupsUpdated(
    _CategoryGroupsUpdated event,
    Emitter<BudgetState> emit,
  ) {
    if (event.generation != _generation) return;
    _groupsReceived = true;
    emit(state.copyWith(
      status: _isLoaded ? BudgetStatus.loaded : state.status,
      categoryGroups: event.categoryGroups,
    ));
  }

  void _onEnvelopesUpdated(
    _EnvelopesUpdated event,
    Emitter<BudgetState> emit,
  ) {
    if (event.generation != _generation) return;
    _envelopesReceived = true;
    emit(state.copyWith(
      status: _isLoaded ? BudgetStatus.loaded : state.status,
      envelopes: event.envelopes,
    ));
  }

  void _onTemplatesUpdated(
    _TemplatesUpdated event,
    Emitter<BudgetState> emit,
  ) {
    if (event.generation != _generation) return;
    _templatesReceived = true;
    emit(state.copyWith(
      status: _isLoaded ? BudgetStatus.loaded : state.status,
      templates: event.templates,
    ));
  }

  void _onStreamError(
    _BudgetStreamError event,
    Emitter<BudgetState> emit,
  ) {
    emit(state.copyWith(
      status: BudgetStatus.error,
      error: BudgetError.loadFailed,
    ));
    emit(state.copyWith(status: BudgetStatus.loaded, error: null));
  }

  Future<void> _onRefreshRequested(
    BudgetRefreshRequested event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading));
    try {
      final futures = <Future<void>>[
        _budgetRepository.refreshBudgetPeriods(_budgetId),
        _envelopeRepository.refreshCategoryGroups(_budgetId),
        _envelopeRepository.refreshEnvelopes(_budgetId),
        _budgetRepository.refreshAllocationTemplates(_budgetId),
      ];
      if (state.selectedPeriod != null) {
        futures.add(
          _envelopeRepository.refreshAllocations(state.selectedPeriod!.id),
        );
      }
      await Future.wait(futures);
    } on BudgetException {
      emit(state.copyWith(status: BudgetStatus.loaded));
    } on EnvelopeException {
      emit(state.copyWith(status: BudgetStatus.loaded));
    }
  }

  Future<void> _onPreviousPeriod(
    BudgetPreviousPeriodRequested event,
    Emitter<BudgetState> emit,
  ) async {
    final sorted = state.sortedPeriods;
    final idx = sorted.indexWhere((p) => p.id == state.selectedPeriod?.id);
    if (idx <= 0) return;

    final newPeriod = sorted[idx - 1];
    emit(state.copyWith(
      selectedPeriod: newPeriod,
      allocations: const [],
      localAllocations: const {},
      readyToAssign: 0,
    ));
    await _subscribeToAllocations(newPeriod.id);
  }

  Future<void> _onNextPeriod(
    BudgetNextPeriodRequested event,
    Emitter<BudgetState> emit,
  ) async {
    final sorted = state.sortedPeriods;
    final idx = sorted.indexWhere((p) => p.id == state.selectedPeriod?.id);
    if (idx < 0 || idx >= sorted.length - 1) return;

    final newPeriod = sorted[idx + 1];
    emit(state.copyWith(
      selectedPeriod: newPeriod,
      allocations: const [],
      localAllocations: const {},
      readyToAssign: 0,
    ));
    await _subscribeToAllocations(newPeriod.id);
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
    if (state.selectedPeriod == null || state.localAllocations.isEmpty) return;

    final periodId = state.selectedPeriod!.id;

    // Track which entries have NOT yet been saved so that on partial failure
    // the user can retry only the unsaved ones.
    final remaining = Map<String, int>.from(state.localAllocations);

    try {
      for (final entry in state.localAllocations.entries) {
        final envelopeId = entry.key;
        final amount = entry.value;

        final existing = state.allocations
            .where((a) => a.envelopeId == envelopeId)
            .firstOrNull;

        if (existing != null) {
          await _envelopeRepository
              .updateAllocation(existing.copyWith(allocatedAmount: amount));
        } else {
          await _envelopeRepository.allocate(
            envelopeId: envelopeId,
            budgetPeriodId: periodId,
            amount: amount,
          );
        }
        remaining.remove(envelopeId);
      }
      emit(state.copyWith(localAllocations: const {}));
    } on EnvelopeException {
      // Preserve only the entries that were not yet written so the user can
      // retry without re-sending allocations that already succeeded.
      emit(state.copyWith(
        localAllocations: remaining,
        status: BudgetStatus.error,
        error: BudgetError.allocationFailed,
      ));
      emit(state.copyWith(
        localAllocations: remaining,
        status: BudgetStatus.loaded,
        error: null,
      ));
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
      emit(state.copyWith(
        status: BudgetStatus.error,
        error: BudgetError.transferFailed,
      ));
      emit(state.copyWith(status: BudgetStatus.loaded, error: null));
    }
  }

  Future<void> _onTemplateApplied(
    AllocationTemplateApplied event,
    Emitter<BudgetState> emit,
  ) async {
    if (state.selectedPeriod == null) return;
    try {
      await _budgetRepository.applyAllocationTemplate(
        templateId: event.templateId,
        budgetPeriodId: state.selectedPeriod!.id,
        totalAmount: event.totalAmount,
      );
    } on BudgetException {
      emit(state.copyWith(
        status: BudgetStatus.error,
        error: BudgetError.templateFailed,
      ));
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
      emit(state.copyWith(
        status: BudgetStatus.error,
        error: BudgetError.templateFailed,
      ));
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
      emit(state.copyWith(
        status: BudgetStatus.error,
        error: BudgetError.templateFailed,
      ));
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
      emit(state.copyWith(
        status: BudgetStatus.error,
        error: BudgetError.templateFailed,
      ));
      emit(state.copyWith(status: BudgetStatus.loaded, error: null));
    }
  }

  Future<void> _onDuplicateFromPrevious(
    BudgetDuplicateFromPreviousPeriodRequested event,
    Emitter<BudgetState> emit,
  ) async {
    if (state.selectedPeriod == null || !state.hasPreviousPeriod) return;

    final sorted = state.sortedPeriods;
    final idx = sorted.indexWhere((p) => p.id == state.selectedPeriod!.id);
    final previousPeriodId = sorted[idx - 1].id;

    try {
      await _budgetRepository.duplicateAllocations(
        fromPeriodId: previousPeriodId,
        toPeriodId: state.selectedPeriod!.id,
      );
    } on BudgetException {
      emit(state.copyWith(
        status: BudgetStatus.error,
        error: BudgetError.allocationFailed,
      ));
      emit(state.copyWith(status: BudgetStatus.loaded, error: null));
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  Future<void> _subscribeToAllocations(String periodId) async {
    _waitingForAllocations = true;
    _allocationsGeneration++;
    await _allocationsSubscription?.cancel();

    final gen = _allocationsGeneration;
    _allocationsSubscription = _envelopeRepository
        .watchAllocations(periodId)
        .listen(
          (allocations) => add(_AllocationsUpdated(allocations, gen)),
          onError: (Object _) => add(const _BudgetStreamError()),
        );

    try {
      await _envelopeRepository.refreshAllocations(periodId);
    } on EnvelopeException {
      // Local watch will still show cached data.
    }
  }

  @override
  Future<void> close() async {
    await _periodsSubscription?.cancel();
    await _allocationsSubscription?.cancel();
    await _groupsSubscription?.cancel();
    await _envelopesSubscription?.cancel();
    await _templatesSubscription?.cancel();
    return super.close();
  }
}
