part of 'budget_bloc.dart';

enum BudgetStatus { initial, loading, loaded, error }

/// Error codes for budget operations, translated in the UI layer.
enum BudgetError { loadFailed, allocationFailed, transferFailed, templateFailed }

final class BudgetState extends Equatable {
  BudgetState({
    this.status = BudgetStatus.initial,
    this.allocations = const [],
    this.categoryGroups = const [],
    this.envelopes = const [],
    this.templates = const [],
    this.goals = const [],
    this.readyToAssign = 0,
    this.localAllocations = const {},
    this.spentByEnvelope = const {},
    this.ccPaymentAvailable = const {},
    this.error,
  });

  final BudgetStatus status;
  final List<EnvelopeAllocation> allocations;
  final List<CategoryGroup> categoryGroups;
  final List<Envelope> envelopes;
  final List<AllocationTemplate> templates;
  final List<Goal> goals;

  /// Repository-computed "Ready to Assign" for the budget.
  final int readyToAssign;

  /// Locally-edited allocation amounts (envelopeId → cents) not yet saved.
  final Map<String, int> localAllocations;

  /// Running expense total per envelope (envelopeId → cents). Derived from
  /// transactions; replaces the dropped `spent_amount` column.
  final Map<String, int> spentByEnvelope;

  /// Derived available balance for CC Payment envelopes (envelopeId → cents).
  final Map<String, int> ccPaymentAvailable;

  final BudgetError? error;

  /// Active linked goals grouped by `envelopeId`. Excludes completed goals
  /// and goals without a linked envelope.
  late final Map<String, List<Goal>> goalsByEnvelope = () {
    final map = <String, List<Goal>>{};
    for (final goal in goals) {
      final id = goal.envelopeId;
      if (id == null || goal.isCompleted) continue;
      (map[id] ??= <Goal>[]).add(goal);
    }
    return map;
  }();

  /// "Ready to Assign" adjusted for locally-edited (unsaved) allocations.
  int get localReadyToAssign {
    if (localAllocations.isEmpty) return readyToAssign;
    var delta = 0;
    for (final entry in localAllocations.entries) {
      final existing = allocations
          .where((a) => a.envelopeId == entry.key)
          .firstOrNull;
      final serverAmount = existing?.allocatedAmount ?? 0;
      delta += entry.value - serverAmount;
    }
    return readyToAssign - delta;
  }

  /// True when the user has allocated more than the available income.
  bool get isOverAllocated => localReadyToAssign < 0;

  /// Active category groups, each paired with their active envelopes and the
  /// global allocation for each envelope (if any).
  List<(CategoryGroup, List<(Envelope, EnvelopeAllocation?)>)>
  get groupedAllocations {
    final activeGroups = categoryGroups.where((g) => !g.isArchived).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return activeGroups.map((group) {
      final groupEnvelopes =
          envelopes
              .where((e) => e.categoryGroupId == group.id && !e.isArchived)
              .toList()
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      final pairs = groupEnvelopes.map((env) {
        final allocation = allocations
            .where((a) => a.envelopeId == env.id)
            .firstOrNull;
        return (env, allocation);
      }).toList();

      return (group, pairs);
    }).toList();
  }

  BudgetState copyWith({
    BudgetStatus? status,
    List<EnvelopeAllocation>? allocations,
    List<CategoryGroup>? categoryGroups,
    List<Envelope>? envelopes,
    List<AllocationTemplate>? templates,
    List<Goal>? goals,
    int? readyToAssign,
    Map<String, int>? localAllocations,
    Map<String, int>? spentByEnvelope,
    Map<String, int>? ccPaymentAvailable,
    Object? error = _sentinel,
  }) {
    return BudgetState(
      status: status ?? this.status,
      allocations: allocations ?? this.allocations,
      categoryGroups: categoryGroups ?? this.categoryGroups,
      envelopes: envelopes ?? this.envelopes,
      templates: templates ?? this.templates,
      goals: goals ?? this.goals,
      readyToAssign: readyToAssign ?? this.readyToAssign,
      localAllocations: localAllocations ?? this.localAllocations,
      spentByEnvelope: spentByEnvelope ?? this.spentByEnvelope,
      ccPaymentAvailable: ccPaymentAvailable ?? this.ccPaymentAvailable,
      error: error == _sentinel ? this.error : error as BudgetError?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [
    status,
    allocations,
    categoryGroups,
    envelopes,
    templates,
    goals,
    readyToAssign,
    localAllocations,
    spentByEnvelope,
    ccPaymentAvailable,
    error,
  ];
}
