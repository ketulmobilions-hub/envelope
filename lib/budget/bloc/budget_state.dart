part of 'budget_bloc.dart';

enum BudgetStatus { initial, loading, loaded, error }

/// Error codes for budget operations, translated in the UI layer.
enum BudgetError {
  loadFailed,
  allocationFailed,
  transferFailed,
  templateFailed,
  periodFailed,
}

final class BudgetState extends Equatable {
  BudgetState({
    this.status = BudgetStatus.initial,
    this.periods = const [],
    this.selectedPeriod,
    this.allocations = const [],
    this.categoryGroups = const [],
    this.envelopes = const [],
    this.templates = const [],
    this.readyToAssign = 0,
    this.localAllocations = const {},
    this.error,
  });

  final BudgetStatus status;
  final List<BudgetPeriod> periods;
  final BudgetPeriod? selectedPeriod;
  final List<EnvelopeAllocation> allocations;
  final List<CategoryGroup> categoryGroups;
  final List<Envelope> envelopes;
  final List<AllocationTemplate> templates;

  /// Server-computed "Ready to Assign" for the selected period.
  final int readyToAssign;

  /// Locally-edited allocation amounts (envelopeId → cents) not yet saved.
  final Map<String, int> localAllocations;

  final BudgetError? error;

  /// Periods sorted chronologically for navigation (memoized per instance).
  late final List<BudgetPeriod> sortedPeriods =
      [...periods]..sort((a, b) => a.startDate.compareTo(b.startDate));

  int get _selectedIndex =>
      sortedPeriods.indexWhere((p) => p.id == selectedPeriod?.id);

  bool get hasPreviousPeriod => _selectedIndex > 0;

  bool get hasNextPeriod {
    final idx = _selectedIndex;
    return idx >= 0 && idx < sortedPeriods.length - 1;
  }

  /// "Ready to Assign" adjusted for locally-edited (unsaved) allocations.
  ///
  /// For each locally-edited envelope, subtracts the delta between the local
  /// amount and the server-known amount. This provides instant UI feedback as
  /// the user types without any server round-trips.
  int get localReadyToAssign {
    if (localAllocations.isEmpty) return readyToAssign;
    var delta = 0;
    for (final entry in localAllocations.entries) {
      final existing =
          allocations.where((a) => a.envelopeId == entry.key).firstOrNull;
      final serverAmount = existing?.allocatedAmount ?? 0;
      delta += entry.value - serverAmount;
    }
    return readyToAssign - delta;
  }

  /// True when the user has allocated more than the available income.
  bool get isOverAllocated => localReadyToAssign < 0;

  /// Active category groups, each paired with their active envelopes and
  /// the current period's allocation for each envelope (if any).
  List<(CategoryGroup, List<(Envelope, EnvelopeAllocation?)>)>
      get groupedAllocations {
    final activeGroups = categoryGroups
        .where((g) => !g.isArchived)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return activeGroups.map((group) {
      final groupEnvelopes = envelopes
          .where((e) => e.categoryGroupId == group.id && !e.isArchived)
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      final pairs = groupEnvelopes.map((env) {
        final allocation =
            allocations.where((a) => a.envelopeId == env.id).firstOrNull;
        return (env, allocation);
      }).toList();

      return (group, pairs);
    }).toList();
  }

  BudgetState copyWith({
    BudgetStatus? status,
    List<BudgetPeriod>? periods,
    Object? selectedPeriod = _sentinel,
    List<EnvelopeAllocation>? allocations,
    List<CategoryGroup>? categoryGroups,
    List<Envelope>? envelopes,
    List<AllocationTemplate>? templates,
    int? readyToAssign,
    Map<String, int>? localAllocations,
    Object? error = _sentinel,
  }) {
    return BudgetState(
      status: status ?? this.status,
      periods: periods ?? this.periods,
      selectedPeriod: selectedPeriod == _sentinel
          ? this.selectedPeriod
          : selectedPeriod as BudgetPeriod?,
      allocations: allocations ?? this.allocations,
      categoryGroups: categoryGroups ?? this.categoryGroups,
      envelopes: envelopes ?? this.envelopes,
      templates: templates ?? this.templates,
      readyToAssign: readyToAssign ?? this.readyToAssign,
      localAllocations: localAllocations ?? this.localAllocations,
      error: error == _sentinel ? this.error : error as BudgetError?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [
        status,
        periods,
        selectedPeriod,
        allocations,
        categoryGroups,
        envelopes,
        templates,
        readyToAssign,
        localAllocations,
        error,
      ];
}
