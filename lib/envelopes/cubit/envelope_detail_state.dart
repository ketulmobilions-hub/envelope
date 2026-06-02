part of 'envelope_detail_cubit.dart';

/// One month-bucket on the envelope detail page: a month header + the
/// transactions that fall into that calendar month.
final class EnvelopeMonthGroup extends Equatable {
  const EnvelopeMonthGroup({required this.month, this.transactions = const []});

  /// First day of the month this group represents.
  final DateTime month;
  final List<Transaction> transactions;

  int get spent {
    var sum = 0;
    for (final t in transactions) {
      if (t.type == 'expense') sum += t.baseCurrencyAmount;
    }
    return sum;
  }

  @override
  List<Object?> get props => [month, transactions];
}

final class EnvelopeDetailState extends Equatable {
  EnvelopeDetailState({
    required this.envelope,
    this.allocation,
    this.transactions = const [],
    this.spentTotalCents = 0,
    this.linkedAccount,
    this.ccCreditLimit,
  });

  final Envelope envelope;
  final EnvelopeAllocation? allocation;
  final List<Transaction> transactions;

  /// Total expenses charged against this envelope (including split-mode
  /// contributions). Sourced from the canonical per-budget DAO stream so the
  /// detail page agrees with the budget/dashboard pages.
  final int spentTotalCents;

  /// The linked credit-card account when this is a CC Payment envelope, else
  /// null.
  final Account? linkedAccount;

  /// The linked CC account's credit limit (cents), if set.
  final int? ccCreditLimit;

  bool get isCreditCardEnvelope => envelope.linkedAccountId != null;

  int get ccDueCents {
    final balance = linkedAccount?.currentBalance ?? 0;
    return balance < 0 ? -balance : 0;
  }

  int? get ccAvailableCreditCents {
    final limit = ccCreditLimit;
    final account = linkedAccount;
    if (limit == null || account == null) return null;
    return limit + account.currentBalance;
  }

  int get allocated => allocation?.allocatedAmount ?? 0;

  int get spent => spentTotalCents;

  int get available => allocated - spent;

  /// Transactions grouped by calendar month, newest month first.
  late final List<EnvelopeMonthGroup> monthGroups = _buildMonthGroups();

  List<EnvelopeMonthGroup> _buildMonthGroups() {
    final byMonth = <DateTime, List<Transaction>>{};
    for (final t in transactions) {
      final key = DateTime(t.date.year, t.date.month);
      (byMonth[key] ??= <Transaction>[]).add(t);
    }
    final months = byMonth.keys.toList()..sort((a, b) => b.compareTo(a));
    return [
      for (final m in months)
        EnvelopeMonthGroup(
          month: m,
          transactions: byMonth[m]!..sort((a, b) => b.date.compareTo(a.date)),
        ),
    ];
  }

  EnvelopeDetailState copyWith({
    Envelope? envelope,
    Object? allocation = _sentinel,
    List<Transaction>? transactions,
    int? spentTotalCents,
    Account? linkedAccount,
    Object? ccCreditLimit = _sentinel,
  }) {
    return EnvelopeDetailState(
      envelope: envelope ?? this.envelope,
      allocation: allocation == _sentinel
          ? this.allocation
          : allocation as EnvelopeAllocation?,
      transactions: transactions ?? this.transactions,
      spentTotalCents: spentTotalCents ?? this.spentTotalCents,
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
    allocation,
    transactions,
    spentTotalCents,
    linkedAccount,
    ccCreditLimit,
  ];
}
