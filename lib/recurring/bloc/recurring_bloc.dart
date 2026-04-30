import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show DateUtils;
import 'package:transaction_repository/transaction_repository.dart';

part 'recurring_event.dart';
part 'recurring_state.dart';

class RecurringBloc extends Bloc<RecurringEvent, RecurringState> {
  RecurringBloc({
    required TransactionRepository transactionRepository,
    required String budgetId,
    required String userId,
    DateTime Function()? now,
  }) : _transactionRepository = transactionRepository,
       _budgetId = budgetId,
       _userId = userId,
       _now = now ?? DateTime.now,
       super(const RecurringState()) {
    on<RecurringStarted>(_onStarted);
    on<_RecurringRulesUpdated>(_onRulesUpdated);
    on<_BillRemindersUpdated>(_onRemindersUpdated);
    on<_RecurringStreamError>(_onRecurringStreamError);
    on<_BillReminderStreamError>(_onBillReminderStreamError);
    on<RecurringRefreshRequested>(_onRefreshRequested);
    on<RecurringRuleDeleted>(_onRuleDeleted);
    on<RecurringRuleUndoDeleteRequested>(_onRuleUndoDelete);
    on<RecurringRulePosted>(_onRulePosted);
    on<RecurringRulePauseToggled>(_onRulePauseToggled);
    on<BillReminderDeleted>(_onReminderDeleted);
    on<BillReminderUndoDeleteRequested>(_onReminderUndoDelete);
  }

  final TransactionRepository _transactionRepository;
  final String _budgetId;
  final String _userId;
  final DateTime Function() _now;
  StreamSubscription<List<RecurringRule>>? _rulesSubscription;
  StreamSubscription<List<BillReminder>>? _remindersSubscription;
  RecurringRule? _lastDeletedRule;
  BillReminder? _lastDeletedReminder;

  /// The budget ID this bloc is watching.
  String get budgetId => _budgetId;

  Future<void> _onStarted(
    RecurringStarted event,
    Emitter<RecurringState> emit,
  ) async {
    emit(state.copyWith(status: RecurringStatus.loading));

    await _rulesSubscription?.cancel();
    _rulesSubscription = _transactionRepository
        .watchRecurringRules(_budgetId)
        .listen(
          (rules) => add(_RecurringRulesUpdated(rules)),
          onError: (Object _) => add(const _RecurringStreamError()),
        );

    await _remindersSubscription?.cancel();
    _remindersSubscription = _transactionRepository
        .watchBillReminders(_budgetId)
        .listen(
          (reminders) => add(_BillRemindersUpdated(reminders)),
          onError: (Object _) => add(const _BillReminderStreamError()),
        );

    try {
      await _transactionRepository.refreshRecurringRules(_budgetId);
    } on TransactionException {
      // Local watch will still show cached data.
    }

    try {
      await _transactionRepository.refreshBillReminders(_budgetId);
    } on TransactionException {
      // Local watch will still show cached data.
    }
  }

  void _onRulesUpdated(
    _RecurringRulesUpdated event,
    Emitter<RecurringState> emit,
  ) {
    emit(
      state.copyWith(
        status: RecurringStatus.loaded,
        recurringRules: event.rules,
      ),
    );
  }

  void _onRemindersUpdated(
    _BillRemindersUpdated event,
    Emitter<RecurringState> emit,
  ) {
    emit(
      state.copyWith(
        status: RecurringStatus.loaded,
        billReminders: event.reminders,
      ),
    );
  }

  void _onRecurringStreamError(
    _RecurringStreamError event,
    Emitter<RecurringState> emit,
  ) {
    emit(
      state.copyWith(
        status: RecurringStatus.error,
        error: RecurringError.loadFailed,
      ),
    );
    emit(state.copyWith(status: RecurringStatus.loaded, error: null));
  }

  void _onBillReminderStreamError(
    _BillReminderStreamError event,
    Emitter<RecurringState> emit,
  ) {
    emit(
      state.copyWith(
        status: RecurringStatus.error,
        error: RecurringError.loadFailed,
      ),
    );
    emit(state.copyWith(status: RecurringStatus.loaded, error: null));
  }

  Future<void> _onRefreshRequested(
    RecurringRefreshRequested event,
    Emitter<RecurringState> emit,
  ) async {
    try {
      await _transactionRepository.refreshRecurringRules(_budgetId);
    } on TransactionException {
      // Stream will update on its own if data changes.
    }
    try {
      await _transactionRepository.refreshBillReminders(_budgetId);
    } on TransactionException {
      // Stream will update on its own if data changes.
    }
  }

  Future<void> _onRuleDeleted(
    RecurringRuleDeleted event,
    Emitter<RecurringState> emit,
  ) async {
    _lastDeletedRule = state.recurringRules
        .where((r) => r.id == event.id)
        .firstOrNull;

    try {
      await _transactionRepository.deleteRecurringRule(event.id);
    } on TransactionException {
      emit(
        state.copyWith(
          status: RecurringStatus.error,
          error: RecurringError.deleteFailed,
        ),
      );
      emit(state.copyWith(status: RecurringStatus.loaded, error: null));
    }
  }

  Future<void> _onRuleUndoDelete(
    RecurringRuleUndoDeleteRequested event,
    Emitter<RecurringState> emit,
  ) async {
    final deleted = _lastDeletedRule;
    if (deleted == null) return;
    _lastDeletedRule = null;

    try {
      await _transactionRepository.createRecurringRule(
        budgetId: deleted.budgetId,
        accountId: deleted.accountId,
        type: deleted.type,
        amount: deleted.amount,
        currency: deleted.currency,
        frequency: deleted.frequency,
        startDate: deleted.startDate,
        envelopeId: deleted.envelopeId,
        payee: deleted.payee,
        notes: deleted.notes,
        customInterval: deleted.customInterval,
        customUnit: deleted.customUnit,
        endDate: deleted.endDate,
        autoPost: deleted.autoPost,
      );
    } on TransactionException {
      emit(
        state.copyWith(
          status: RecurringStatus.error,
          error: RecurringError.undoFailed,
        ),
      );
      emit(state.copyWith(status: RecurringStatus.loaded, error: null));
    }
  }

  Future<void> _onRulePosted(
    RecurringRulePosted event,
    Emitter<RecurringState> emit,
  ) async {
    final rule = state.recurringRules
        .where((r) => r.id == event.id)
        .firstOrNull;
    if (rule == null) return;

    try {
      await _transactionRepository.createTransaction(
        budgetId: rule.budgetId,
        accountId: rule.accountId,
        type: rule.type,
        amount: rule.amount,
        currency: rule.currency,
        date: _now(),
        createdBy: _userId,
        envelopeId: rule.envelopeId,
        payee: rule.payee,
        notes: rule.notes,
        recurringRuleId: rule.id,
      );
    } on TransactionException {
      emit(
        state.copyWith(
          status: RecurringStatus.error,
          error: RecurringError.postFailed,
        ),
      );
      emit(state.copyWith(status: RecurringStatus.loaded, error: null));
      return;
    }

    // Advance nextOccurrence so the rule doesn't stay pending.
    try {
      final next = _calculateNextOccurrence(rule);
      await _transactionRepository.updateRecurringRule(
        rule.copyWith(nextOccurrence: next),
      );
    } on TransactionException {
      // Transaction was created; nextOccurrence update failed.
      // Will self-correct on next app open.
    }
  }

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

  static DateTime _addMonths(DateTime date, int months) {
    final total = date.month + months;
    final y = date.year + (total - 1) ~/ 12;
    final m = (total - 1) % 12 + 1;
    final daysInMonth = DateUtils.getDaysInMonth(y, m);
    final d = date.day > daysInMonth ? daysInMonth : date.day;
    return DateTime(y, m, d, date.hour, date.minute);
  }

  Future<void> _onRulePauseToggled(
    RecurringRulePauseToggled event,
    Emitter<RecurringState> emit,
  ) async {
    try {
      final rule = state.recurringRules
          .where((r) => r.id == event.id)
          .firstOrNull;
      if (rule == null) return;
      if (rule.isPaused) {
        await _transactionRepository.resumeRecurringRule(event.id);
      } else {
        await _transactionRepository.pauseRecurringRule(event.id);
      }
    } on TransactionException {
      emit(
        state.copyWith(
          status: RecurringStatus.error,
          error: RecurringError.pauseFailed,
        ),
      );
      emit(state.copyWith(status: RecurringStatus.loaded, error: null));
    }
  }

  Future<void> _onReminderDeleted(
    BillReminderDeleted event,
    Emitter<RecurringState> emit,
  ) async {
    _lastDeletedReminder = state.billReminders
        .where((r) => r.id == event.id)
        .firstOrNull;

    try {
      await _transactionRepository.deleteBillReminder(event.id);
    } on TransactionException {
      emit(
        state.copyWith(
          status: RecurringStatus.error,
          error: RecurringError.deleteFailed,
        ),
      );
      emit(state.copyWith(status: RecurringStatus.loaded, error: null));
    }
  }

  Future<void> _onReminderUndoDelete(
    BillReminderUndoDeleteRequested event,
    Emitter<RecurringState> emit,
  ) async {
    final deleted = _lastDeletedReminder;
    if (deleted == null) return;
    _lastDeletedReminder = null;

    try {
      await _transactionRepository.createBillReminder(
        budgetId: deleted.budgetId,
        name: deleted.name,
        estimatedAmount: deleted.estimatedAmount,
        dueDay: deleted.dueDay,
        frequency: deleted.frequency,
        envelopeId: deleted.envelopeId,
        reminderDaysBefore: deleted.reminderDaysBefore,
      );
    } on TransactionException {
      emit(
        state.copyWith(
          status: RecurringStatus.error,
          error: RecurringError.undoFailed,
        ),
      );
      emit(state.copyWith(status: RecurringStatus.loaded, error: null));
    }
  }

  @override
  Future<void> close() async {
    await _rulesSubscription?.cancel();
    await _remindersSubscription?.cancel();
    return super.close();
  }
}
