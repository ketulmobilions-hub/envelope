part of 'envelope_detail_cubit.dart';

/// One row of the envelope detail page: a period header + the allocation and
/// transactions that belong to that period.
///
/// `period == null` is the "uncategorized" bucket — transactions whose date
/// does not fall into any known budget period. It should normally stay empty.
final class EnvelopePeriodGroup extends Equatable {
  const EnvelopePeriodGroup({
    this.period,
    this.allocation,
    this.transactions = const [],
  });

  final BudgetPeriod? period;
  final EnvelopeAllocation? allocation;
  final List<Transaction> transactions;

  int get allocated => allocation?.allocatedAmount ?? 0;
  int get spent => allocation?.spentAmount ?? 0;
  int get available => allocated - spent + (allocation?.rolloverAmount ?? 0);

  @override
  List<Object?> get props => [period, allocation, transactions];
}

final class EnvelopeDetailState extends Equatable {
  EnvelopeDetailState({
    required this.envelope,
    this.periods = const [],
    this.allocations = const [],
    this.transactions = const [],
    this.currentPeriodId,
    this.linkedAccount,
    this.ccCreditLimit,
  });

  final Envelope envelope;
  final List<BudgetPeriod> periods;
  final List<EnvelopeAllocation> allocations;
  final List<Transaction> transactions;

  /// The linked credit-card account when this is a CC Payment envelope
  /// (`envelope.linkedAccountId != null`), else null. Carries `currentBalance`.
  final Account? linkedAccount;

  /// The linked CC account's credit limit (cents), if set; null when unknown
  /// or the account has no limit.
  final int? ccCreditLimit;

  /// True when this envelope is a CC Payment envelope linked to a credit card.
  bool get isCreditCardEnvelope => envelope.linkedAccountId != null;

  /// Amount currently owed on the linked card (cents); 0 when not in debt.
  int get ccDueCents {
    final balance = linkedAccount?.currentBalance ?? 0;
    return balance < 0 ? -balance : 0;
  }

  /// Available credit (limit minus debt) when a credit limit is known, else
  /// null. `currentBalance` is negative when in debt, so `limit + balance`.
  int? get ccAvailableCreditCents {
    final limit = ccCreditLimit;
    final account = linkedAccount;
    if (limit == null || account == null) return null;
    return limit + account.currentBalance;
  }

  /// Id of the period containing "now" — picked by the cubit (which owns the
  /// clock). Used to flag the active group in the UI; the state itself never
  /// reads the wall clock.
  final String? currentPeriodId;

  /// Memoized so the O(periods × transactions) grouping doesn't re-run on
  /// every BlocBuilder rebuild / `currentGroup` lookup.
  late final List<EnvelopePeriodGroup> groups = _buildGroups();

  /// Period sections rendered on the detail page, newest period first.
  ///
  /// Includes a section for every period that has either an allocation or at
  /// least one transaction for this envelope. While the periods stream is
  /// still loading (`periods` empty), returns an empty list so transactions
  /// don't briefly flicker into the "uncategorized" bucket on first paint.
  List<EnvelopePeriodGroup> _buildGroups() {
    if (periods.isEmpty) return const [];

    final allocationByPeriod = <String, EnvelopeAllocation>{
      for (final a in allocations)
        if (a.envelopeId == envelope.id) a.budgetPeriodId: a,
    };
    final txnsByPeriod = <String, List<Transaction>>{};
    final uncategorizedTxns = <Transaction>[];
    for (final txn in transactions) {
      final period = BudgetRepository.periodForDate<BudgetPeriod>(
        txn.date,
        periods,
        startDate: (p) => p.startDate,
        endDate: (p) => p.endDate,
      );
      if (period == null) {
        uncategorizedTxns.add(txn);
      } else {
        (txnsByPeriod[period.id] ??= <Transaction>[]).add(txn);
      }
    }

    final relevantPeriods =
        periods
            .where(
              (p) =>
                  allocationByPeriod.containsKey(p.id) ||
                  txnsByPeriod.containsKey(p.id),
            )
            .toList()
          ..sort((a, b) => b.startDate.compareTo(a.startDate));

    final result = <EnvelopePeriodGroup>[];
    for (final p in relevantPeriods) {
      final txns = (txnsByPeriod[p.id] ?? <Transaction>[])
        ..sort(
          (a, b) => b.date.compareTo(a.date),
        );
      result.add(
        EnvelopePeriodGroup(
          period: p,
          allocation: allocationByPeriod[p.id],
          transactions: txns,
        ),
      );
    }

    if (uncategorizedTxns.isNotEmpty) {
      uncategorizedTxns.sort((a, b) => b.date.compareTo(a.date));
      result.add(EnvelopePeriodGroup(transactions: uncategorizedTxns));
    }

    return result;
  }

  /// Group for the period containing "now", or `null` when there is none
  /// (e.g. the envelope has no allocations/transactions in the current
  /// period yet).
  EnvelopePeriodGroup? get currentGroup {
    final id = currentPeriodId;
    if (id == null) return null;
    for (final g in groups) {
      if (g.period?.id == id) return g;
    }
    return null;
  }

  EnvelopeDetailState copyWith({
    Envelope? envelope,
    List<BudgetPeriod>? periods,
    List<EnvelopeAllocation>? allocations,
    List<Transaction>? transactions,
    Object? currentPeriodId = _sentinel,
    Account? linkedAccount,
    Object? ccCreditLimit = _sentinel,
  }) {
    return EnvelopeDetailState(
      envelope: envelope ?? this.envelope,
      periods: periods ?? this.periods,
      allocations: allocations ?? this.allocations,
      transactions: transactions ?? this.transactions,
      // _sentinel allows explicit null-clearing of currentPeriodId while
      // omission keeps the existing value.
      currentPeriodId: currentPeriodId == _sentinel
          ? this.currentPeriodId
          : currentPeriodId as String?,
      linkedAccount: linkedAccount ?? this.linkedAccount,
      ccCreditLimit: ccCreditLimit == _sentinel
          ? this.ccCreditLimit
          : ccCreditLimit as int?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [
    envelope,
    periods,
    allocations,
    transactions,
    currentPeriodId,
    linkedAccount,
    ccCreditLimit,
  ];
}
