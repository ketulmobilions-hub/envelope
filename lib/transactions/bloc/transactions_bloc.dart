import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/transactions/widgets/transaction_helpers.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc({
    required TransactionRepository transactionRepository,
    required AccountRepository accountRepository,
    required EnvelopeRepository envelopeRepository,
    required BudgetRepository budgetRepository,
    required String budgetId,
  }) : _transactionRepository = transactionRepository,
       _accountRepository = accountRepository,
       _envelopeRepository = envelopeRepository,
       _budgetRepository = budgetRepository,
       _budgetId = budgetId,
       super(const TransactionsState()) {
    on<TransactionsStarted>(_onStarted);
    on<_TransactionsUpdated>(_onUpdated);
    on<_AccountsUpdated>(_onAccountsUpdated);
    on<_EnvelopesUpdated>(_onEnvelopesUpdated);
    on<_SplitEnvelopeIdsUpdated>(_onSplitEnvelopeIdsUpdated);
    on<_TransactionsStreamError>(_onStreamError);
    on<TransactionsRefreshRequested>(_onRefreshRequested);
    on<TransactionDeleted>(_onDeleted);
    on<TransactionUndoDeleteRequested>(_onUndoDelete);
    on<TransactionsFilterChanged>(_onFilterChanged);
  }

  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;
  final EnvelopeRepository _envelopeRepository;
  final BudgetRepository _budgetRepository;
  final String _budgetId;
  StreamSubscription<List<Transaction>>? _transactionsSubscription;
  StreamSubscription<List<Account>>? _accountsSubscription;
  StreamSubscription<List<Envelope>>? _envelopesSubscription;
  StreamSubscription<Map<String, List<String>>>? _splitIdsSubscription;
  ({Transaction txn, List<TransactionSplit> splits})? _lastDeleted;

  /// The budget ID this bloc is watching.
  String get budgetId => _budgetId;

  Future<void> _onStarted(
    TransactionsStarted event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(state.copyWith(status: TransactionsStatus.loading));

    await _transactionsSubscription?.cancel();
    _transactionsSubscription = _transactionRepository
        .watchTransactions(budgetId: _budgetId)
        .listen(
          (transactions) => add(_TransactionsUpdated(transactions)),
          onError: (Object _) => add(const _TransactionsStreamError()),
        );

    await _accountsSubscription?.cancel();
    _accountsSubscription = _accountRepository
        .watchAccounts(_budgetId)
        .listen((accounts) => add(_AccountsUpdated(accounts)));

    await _envelopesSubscription?.cancel();
    _envelopesSubscription = _envelopeRepository
        .watchEnvelopes(_budgetId)
        .listen((envelopes) => add(_EnvelopesUpdated(envelopes)));

    await _splitIdsSubscription?.cancel();
    _splitIdsSubscription = _transactionRepository
        .watchSplitEnvelopeIds(_budgetId)
        .listen((ids) => add(_SplitEnvelopeIdsUpdated(ids)));

    try {
      await _transactionRepository.refreshTransactions(_budgetId);
    } on TransactionException {
      // Local watch will still show cached data.
    }
  }

  void _onUpdated(
    _TransactionsUpdated event,
    Emitter<TransactionsState> emit,
  ) {
    emit(
      state.copyWith(
        status: TransactionsStatus.loaded,
        transactions: event.transactions,
      ),
    );
  }

  void _onAccountsUpdated(
    _AccountsUpdated event,
    Emitter<TransactionsState> emit,
  ) {
    emit(state.copyWith(accounts: event.accounts));
  }

  void _onEnvelopesUpdated(
    _EnvelopesUpdated event,
    Emitter<TransactionsState> emit,
  ) {
    emit(state.copyWith(envelopes: event.envelopes));
  }

  void _onSplitEnvelopeIdsUpdated(
    _SplitEnvelopeIdsUpdated event,
    Emitter<TransactionsState> emit,
  ) {
    emit(state.copyWith(splitEnvelopeIds: event.splitEnvelopeIds));
  }

  void _onStreamError(
    _TransactionsStreamError event,
    Emitter<TransactionsState> emit,
  ) {
    emit(
      state.copyWith(
        status: TransactionsStatus.error,
        error: TransactionsError.loadFailed,
      ),
    );
    emit(state.copyWith(status: TransactionsStatus.loaded, error: null));
  }

  Future<void> _onRefreshRequested(
    TransactionsRefreshRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    try {
      await _transactionRepository.refreshTransactions(_budgetId);
    } on TransactionException {
      // Stream will update on its own if data changes.
    }
  }

  Future<void> _onDeleted(
    TransactionDeleted event,
    Emitter<TransactionsState> emit,
  ) async {
    final txn = state.transactions.cast<Transaction?>().firstWhere(
      (t) => t!.id == event.id,
      orElse: () => null,
    );
    if (txn == null) return;

    // Snapshot splits before delete in case undo is requested.
    var splits = const <TransactionSplit>[];
    if (txn.type == 'expense' && txn.envelopeId == null) {
      try {
        splits = await _transactionRepository.getTransactionSplits(txn.id);
      } on TransactionException {
        // Best-effort — splits stay empty, optimistic decrement is skipped.
      }
    }
    _lastDeleted = (txn: txn, splits: splits);

    // Optimistic local update FIRST so the UI reflects the delete instantly.
    // The realtime push from the server-side spent_amount trigger arrives
    // after the await below and is the source of truth — it overwrites
    // whatever optimistic value we set, eliminating the double-decrement
    // race that exists if the optimistic update runs after the await.
    final baseAmount = effectiveBaseCurrencyAmount(txn);
    final optimisticFutures = <Future<void>>[];
    if (txn.type == 'income') {
      optimisticFutures.add(
        _budgetRepository
            .removeIncomeFromPeriod(
              budgetId: txn.budgetId,
              date: txn.date,
              amount: baseAmount,
            )
            .catchError((_) {}),
      );
    } else if (txn.type == 'expense') {
      if (txn.envelopeId != null) {
        optimisticFutures.add(
          _envelopeRepository.decrementLocalSpentAmount(
            envelopeId: txn.envelopeId!,
            budgetId: txn.budgetId,
            date: txn.date,
            amount: baseAmount,
          ),
        );
      } else {
        for (final s in splits) {
          optimisticFutures.add(
            _envelopeRepository.decrementLocalSpentAmount(
              envelopeId: s.envelopeId,
              budgetId: txn.budgetId,
              date: txn.date,
              amount: (s.amount * txn.exchangeRate).round(),
            ),
          );
        }
      }
    }
    await Future.wait(optimisticFutures);

    try {
      await _transactionRepository.deleteTransaction(event.id);
    } on TransactionException {
      // Roll back the optimistic update so local state matches server.
      await _rollbackDeleteOptimistic(txn, splits, baseAmount);
      _lastDeleted = null;
      emit(
        state.copyWith(
          status: TransactionsStatus.error,
          error: TransactionsError.deleteFailed,
        ),
      );
      emit(state.copyWith(status: TransactionsStatus.loaded, error: null));
    }
  }

  Future<void> _rollbackDeleteOptimistic(
    Transaction txn,
    List<TransactionSplit> splits,
    int baseAmount,
  ) async {
    final futures = <Future<void>>[];
    if (txn.type == 'income') {
      // Symmetric inverse of removeIncomeFromPeriod(date) — addIncomeToPeriod
      // hits the same period the optimistic decrement targeted, even for
      // past-dated transactions where the latest period is not the right one.
      futures.add(
        _budgetRepository
            .addIncomeToPeriod(
              budgetId: txn.budgetId,
              date: txn.date,
              amount: baseAmount,
            )
            .catchError((_) {}),
      );
    } else if (txn.type == 'expense') {
      if (txn.envelopeId != null) {
        futures.add(
          _envelopeRepository.incrementLocalSpentAmount(
            envelopeId: txn.envelopeId!,
            budgetId: txn.budgetId,
            date: txn.date,
            baseCurrencyAmount: baseAmount,
          ),
        );
      } else {
        for (final s in splits) {
          futures.add(
            _envelopeRepository.incrementLocalSpentAmount(
              envelopeId: s.envelopeId,
              budgetId: txn.budgetId,
              date: txn.date,
              baseCurrencyAmount: (s.amount * txn.exchangeRate).round(),
            ),
          );
        }
      }
    }
    await Future.wait(futures);
  }

  Future<void> _onUndoDelete(
    TransactionUndoDeleteRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    final snapshot = _lastDeleted;
    if (snapshot == null) return;
    final deleted = snapshot.txn;

    // Optimistic re-add FIRST so RTA / envelope spent restore instantly.
    // Server-side trigger emits the corrected value via realtime after the
    // restore call below completes, overwriting whatever we set.
    final baseAmount = effectiveBaseCurrencyAmount(deleted);
    final optimisticFutures = <Future<void>>[];
    if (deleted.type == 'income') {
      optimisticFutures.add(
        _budgetRepository
            .addIncomeToPeriod(
              budgetId: deleted.budgetId,
              date: deleted.date,
              amount: baseAmount,
            )
            .catchError((_) {}),
      );
    } else if (deleted.type == 'expense') {
      if (deleted.envelopeId != null) {
        optimisticFutures.add(
          _envelopeRepository.incrementLocalSpentAmount(
            envelopeId: deleted.envelopeId!,
            budgetId: deleted.budgetId,
            date: deleted.date,
            baseCurrencyAmount: baseAmount,
          ),
        );
      } else {
        for (final s in snapshot.splits) {
          optimisticFutures.add(
            _envelopeRepository.incrementLocalSpentAmount(
              envelopeId: s.envelopeId,
              budgetId: deleted.budgetId,
              date: deleted.date,
              baseCurrencyAmount: (s.amount * deleted.exchangeRate).round(),
            ),
          );
        }
      }
    }
    await Future.wait(optimisticFutures);

    try {
      // Use restoreTransaction so the original UUID is preserved. Creating a
      // new transaction would orphan transferPairId / recurringRuleId /
      // attachments. Splits, tags, and base_currency_amount survive the
      // soft-delete window server-side. The paired transfer half (if any)
      // was never deleted — `deleteTransaction` only removes the single
      // row and `transferPairId` is a shared marker UUID, not a row id —
      // so no separate pair-restore is needed.
      await _transactionRepository.restoreTransaction(deleted.id);
      _lastDeleted = null;
    } on TransactionException {
      // Roll back the optimistic update so local state matches server.
      await _rollbackUndoOptimistic(deleted, snapshot.splits, baseAmount);
      emit(
        state.copyWith(
          status: TransactionsStatus.error,
          error: TransactionsError.undoFailed,
        ),
      );
      emit(state.copyWith(status: TransactionsStatus.loaded, error: null));
    }
  }

  Future<void> _rollbackUndoOptimistic(
    Transaction txn,
    List<TransactionSplit> splits,
    int baseAmount,
  ) async {
    final futures = <Future<void>>[];
    if (txn.type == 'income') {
      futures.add(
        _budgetRepository
            .removeIncomeFromPeriod(
              budgetId: txn.budgetId,
              date: txn.date,
              amount: baseAmount,
            )
            .catchError((_) {}),
      );
    } else if (txn.type == 'expense') {
      if (txn.envelopeId != null) {
        futures.add(
          _envelopeRepository.decrementLocalSpentAmount(
            envelopeId: txn.envelopeId!,
            budgetId: txn.budgetId,
            date: txn.date,
            amount: baseAmount,
          ),
        );
      } else {
        for (final s in splits) {
          futures.add(
            _envelopeRepository.decrementLocalSpentAmount(
              envelopeId: s.envelopeId,
              budgetId: txn.budgetId,
              date: txn.date,
              amount: (s.amount * txn.exchangeRate).round(),
            ),
          );
        }
      }
    }
    await Future.wait(futures);
  }

  void _onFilterChanged(
    TransactionsFilterChanged event,
    Emitter<TransactionsState> emit,
  ) {
    emit(state.copyWith(filter: event.filter));
  }

  @override
  Future<void> close() async {
    await _transactionsSubscription?.cancel();
    await _accountsSubscription?.cancel();
    await _envelopesSubscription?.cancel();
    await _splitIdsSubscription?.cancel();
    return super.close();
  }
}
