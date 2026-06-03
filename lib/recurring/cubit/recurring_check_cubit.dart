import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/transactions/widgets/transaction_helpers.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show DateUtils;
import 'package:transaction_repository/transaction_repository.dart';

/// State for the background recurring check.
class RecurringCheckState extends Equatable {
  const RecurringCheckState({
    this.pendingRules = const [],
    this.upcomingBills = const [],
    this.isChecking = false,
  });

  /// Manual rules that are due but not auto-posted.
  final List<RecurringRule> pendingRules;

  /// Bill reminders within their reminder window.
  final List<BillReminder> upcomingBills;

  /// Whether a check is currently in progress.
  final bool isChecking;

  bool get hasPendingItems =>
      pendingRules.isNotEmpty || upcomingBills.isNotEmpty;

  RecurringCheckState copyWith({
    List<RecurringRule>? pendingRules,
    List<BillReminder>? upcomingBills,
    bool? isChecking,
  }) {
    return RecurringCheckState(
      pendingRules: pendingRules ?? this.pendingRules,
      upcomingBills: upcomingBills ?? this.upcomingBills,
      isChecking: isChecking ?? this.isChecking,
    );
  }

  @override
  List<Object> get props => [pendingRules, upcomingBills, isChecking];
}

/// Cubit that checks for due recurring rules and upcoming bill reminders.
///
/// Should be provided at the dashboard/home level to run checks on app open.
class RecurringCheckCubit extends Cubit<RecurringCheckState> {
  RecurringCheckCubit({
    required TransactionRepository transactionRepository,
    required String budgetId,
    required String userId,
    BudgetRepository? budgetRepository,
    EnvelopeRepository? envelopeRepository,
    DateTime Function()? nowProvider,
  }) : _transactionRepository = transactionRepository,
       _budgetRepository = budgetRepository,
       _envelopeRepository = envelopeRepository,
       _budgetId = budgetId,
       _userId = userId,
       _nowProvider = nowProvider ?? DateTime.now,
       super(const RecurringCheckState());

  final TransactionRepository _transactionRepository;
  final BudgetRepository? _budgetRepository;
  final EnvelopeRepository? _envelopeRepository;
  final String _budgetId;
  final String _userId;
  final DateTime Function() _nowProvider;

  /// Runs the due-check: auto-posts eligible rules, collects pending
  /// manual rules, and identifies upcoming bills.
  ///
  /// Pass [now] to simulate a future date (useful for debug/testing only).
  Future<void> check({DateTime? now}) async {
    emit(state.copyWith(isChecking: true));

    try {
      final rules = await _transactionRepository
          .watchRecurringRules(_budgetId)
          .first;
      final bills = await _transactionRepository
          .watchBillReminders(_budgetId)
          .first;
      final effectiveNow = now ?? _nowProvider();

      final pendingRules = <RecurringRule>[];

      for (final rule in rules) {
        if (rule.isPaused) continue;

        if (!rule.nextOccurrence.isAfter(effectiveNow)) {
          if (rule.autoPost) {
            await _autoPostMissedOccurrences(rule, effectiveNow);
          } else {
            pendingRules.add(rule);
          }
        }
      }

      final upcomingBills = <BillReminder>[];
      for (final bill in bills) {
        if (_isBillUpcoming(bill, effectiveNow)) {
          upcomingBills.add(bill);
        }
      }

      emit(
        state.copyWith(
          pendingRules: pendingRules,
          upcomingBills: upcomingBills,
          isChecking: false,
        ),
      );
    } on Exception catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(state.copyWith(isChecking: false));
    }
  }

  /// Posts every missed occurrence of [rule] from `rule.nextOccurrence` up to
  /// and including [effectiveNow] (clamped by `rule.endDate`), persisting the
  /// advanced cursor after each post.
  ///
  /// Per-iteration persistence: makes partial progress durable so that an
  /// `updateRecurringRule` failure after N successful posts doesn't cause
  /// those N transactions to be re-posted on the next `check()`.
  Future<void> _autoPostMissedOccurrences(
    RecurringRule rule,
    DateTime effectiveNow,
  ) async {
    final endDate = rule.endDate;
    var cursor = rule;
    while (!cursor.nextOccurrence.isAfter(effectiveNow)) {
      if (endDate != null && cursor.nextOccurrence.isAfter(endDate)) break;

      final posted = await _autoPostOnce(cursor, cursor.nextOccurrence);
      if (!posted) return;

      final next = _calculateNextOccurrence(cursor);
      // Defense against a misconfigured rule producing a non-advancing
      // cursor (e.g. customInterval <= 0) — would otherwise spin forever
      // re-posting the same date.
      if (!next.isAfter(cursor.nextOccurrence)) {
        addError(
          StateError(
            'Non-advancing recurring rule cursor for ${rule.id}; aborting '
            'catch-up to prevent infinite loop.',
          ),
          StackTrace.current,
        );
        return;
      }
      cursor = cursor.copyWith(nextOccurrence: next);

      try {
        await _transactionRepository.updateRecurringRule(cursor);
      } on TransactionException catch (e, stackTrace) {
        // Posted transaction is durable; cursor isn't. Abort the loop so
        // the next check() retries from the unchanged remote cursor — but
        // this means the just-posted occurrence could be duplicated on
        // the next run. Surface so observability catches it.
        addError(e, stackTrace);
        return;
      }
    }
  }

  /// Posts a single transaction for [rule] dated [postingDate]. Returns
  /// `true` on success. Does NOT advance the rule's `nextOccurrence`.
  Future<bool> _autoPostOnce(RecurringRule rule, DateTime postingDate) async {
    Transaction created;
    try {
      created = await _transactionRepository.createTransaction(
        budgetId: rule.budgetId,
        accountId: rule.accountId,
        type: rule.type,
        amount: rule.amount,
        currency: rule.currency,
        exchangeRate: rule.exchangeRate,
        date: postingDate,
        createdBy: _userId,
        envelopeId: rule.envelopeId,
        payee: rule.payee,
        notes: rule.notes,
        recurringRuleId: rule.id,
      );
    } on TransactionException {
      return false;
    }

    // Optimistic local total_income / envelope spent. Awaited (not
    // unawaited) because the underlying period/envelope row is a
    // read-modify-write — concurrent calls from a multi-rule catch-up
    // would lose updates.
    final budgetRepo = _budgetRepository;
    final envelopeRepo = _envelopeRepository;
    if (budgetRepo != null || envelopeRepo != null) {
      final baseAmount = effectiveBaseCurrencyAmount(created);
      if (rule.type == 'income' && budgetRepo != null) {
        try {
          await budgetRepo.addIncomeToPeriod(
            budgetId: rule.budgetId,
            date: postingDate,
            amount: baseAmount,
          );
        } on Exception {
          // Best-effort; refresh on next check() will reconcile.
        }
      } else if (rule.type == 'expense' &&
          rule.envelopeId != null &&
          envelopeRepo != null) {
        try {
          await envelopeRepo.incrementLocalSpentAmount(
            envelopeId: rule.envelopeId!,
            budgetId: rule.budgetId,
            date: postingDate,
            baseCurrencyAmount: baseAmount,
          );
        } on Exception {
          // Best-effort.
        }
      }
    }

    return true;
  }

  bool _isBillUpcoming(BillReminder bill, DateTime effectiveNow) {
    final currentMonthDue = DateTime(
      effectiveNow.year,
      effectiveNow.month,
      _clampDay(bill.dueDay, effectiveNow.year, effectiveNow.month),
    );
    final reminderStart = currentMonthDue.subtract(
      Duration(days: bill.reminderDaysBefore),
    );

    // Within the reminder window for this month.
    final inWindow =
        !effectiveNow.isBefore(reminderStart) &&
        !effectiveNow.isAfter(currentMonthDue);
    if (inWindow) {
      return true;
    }

    // Check next month if we're past due day this month.
    if (effectiveNow.isAfter(currentMonthDue)) {
      final nextMonth = effectiveNow.month + 1;
      final nextYear = nextMonth > 12
          ? effectiveNow.year + 1
          : effectiveNow.year;
      final normalizedMonth = nextMonth > 12 ? 1 : nextMonth;
      final nextMonthDue = DateTime(
        nextYear,
        normalizedMonth,
        _clampDay(bill.dueDay, nextYear, normalizedMonth),
      );
      final nextReminderStart = nextMonthDue.subtract(
        Duration(days: bill.reminderDaysBefore),
      );
      if (!effectiveNow.isBefore(nextReminderStart)) return true;
    }

    return false;
  }

  /// Clamps a day to the number of days in the given month/year.
  static int _clampDay(int day, int year, int month) {
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    return day > daysInMonth ? daysInMonth : day;
  }

  /// Calculates the next occurrence based on the rule's frequency.
  static DateTime _calculateNextOccurrence(RecurringRule rule) {
    final current = rule.nextOccurrence;

    return switch (rule.frequency) {
      'daily' => current.add(const Duration(days: 1)),
      'weekly' => current.add(const Duration(days: 7)),
      'bi-weekly' => current.add(const Duration(days: 14)),
      'monthly' => _addMonths(current, 1),
      'yearly' => _addMonths(current, 12),
      'custom' => _calculateCustomNext(rule),
      _ => current.add(const Duration(days: 30)),
    };
  }

  static DateTime _calculateCustomNext(RecurringRule rule) {
    final current = rule.nextOccurrence;
    // Clamp interval to at least 1 so a misconfigured rule (e.g. 0)
    // can't return a non-advancing date and stall the catch-up loop.
    final interval = (rule.customInterval ?? 1) < 1
        ? 1
        : rule.customInterval!;
    final unit = rule.customUnit ?? 'days';

    return switch (unit) {
      'days' => current.add(Duration(days: interval)),
      'weeks' => current.add(Duration(days: interval * 7)),
      'months' => _addMonths(current, interval),
      _ => current.add(Duration(days: interval)),
    };
  }

  /// Adds [months] to [date], clamping the day to the target month's
  /// maximum to avoid overflow (e.g. Jan 31 + 1 month → Feb 28).
  static DateTime _addMonths(DateTime date, int months) {
    final totalMonths = date.month + months;
    final targetYear = date.year + (totalMonths - 1) ~/ 12;
    final targetMonth = (totalMonths - 1) % 12 + 1;
    final clampedDay = _clampDay(date.day, targetYear, targetMonth);
    return DateTime(
      targetYear,
      targetMonth,
      clampedDay,
      date.hour,
      date.minute,
    );
  }
}
