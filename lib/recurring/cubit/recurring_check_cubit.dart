import 'package:bloc/bloc.dart';
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
    DateTime Function()? nowProvider,
  }) : _transactionRepository = transactionRepository,
       _budgetId = budgetId,
       _userId = userId,
       _nowProvider = nowProvider ?? DateTime.now,
       super(const RecurringCheckState());

  final TransactionRepository _transactionRepository;
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
        final endDate = rule.endDate;
        if (endDate != null && effectiveNow.isAfter(endDate)) continue;

        if (!rule.nextOccurrence.isAfter(effectiveNow)) {
          if (rule.autoPost) {
            await _autoPostRule(rule, effectiveNow);
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
    } on Exception {
      emit(state.copyWith(isChecking: false));
    }
  }

  Future<void> _autoPostRule(RecurringRule rule, DateTime effectiveNow) async {
    // Create the transaction first.
    try {
      await _transactionRepository.createTransaction(
        budgetId: rule.budgetId,
        accountId: rule.accountId,
        type: rule.type,
        amount: rule.amount,
        currency: rule.currency,
        date: effectiveNow,
        createdBy: _userId,
        envelopeId: rule.envelopeId,
        payee: rule.payee,
        notes: rule.notes,
        recurringRuleId: rule.id,
      );
    } on TransactionException {
      // Failed to create transaction; skip advancing nextOccurrence.
      return;
    }

    // Only advance nextOccurrence if the transaction was created.
    try {
      final next = _calculateNextOccurrence(rule);
      await _transactionRepository.updateRecurringRule(
        rule.copyWith(nextOccurrence: next),
      );
    } on TransactionException {
      // Transaction was created but nextOccurrence update failed.
      // Will be retried on next app open.
    }
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
    final interval = rule.customInterval ?? 1;
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
