import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc({
    required TransactionRepository transactionRepository,
    required String budgetId,
  })  : _transactionRepository = transactionRepository,
        _budgetId = budgetId,
        super(const TransactionsState()) {
    on<TransactionsStarted>(_onStarted);
    on<_TransactionsUpdated>(_onUpdated);
    on<_TransactionsStreamError>(_onStreamError);
    on<TransactionsRefreshRequested>(_onRefreshRequested);
    on<TransactionDeleted>(_onDeleted);
    on<TransactionUndoDeleteRequested>(_onUndoDelete);
    on<TransactionsFilterChanged>(_onFilterChanged);
  }

  final TransactionRepository _transactionRepository;
  final String _budgetId;
  StreamSubscription<List<Transaction>>? _transactionsSubscription;
  Transaction? _lastDeleted;

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
    // Store for undo before deleting.
    _lastDeleted = state.transactions.cast<Transaction?>().firstWhere(
          (t) => t!.id == event.id,
          orElse: () => null,
        );

    try {
      await _transactionRepository.deleteTransaction(event.id);
    } on TransactionException {
      emit(
        state.copyWith(
          status: TransactionsStatus.error,
          error: TransactionsError.deleteFailed,
        ),
      );
      emit(state.copyWith(status: TransactionsStatus.loaded, error: null));
    }
  }

  Future<void> _onUndoDelete(
    TransactionUndoDeleteRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    final deleted = _lastDeleted;
    if (deleted == null) return;
    _lastDeleted = null;

    try {
      await _transactionRepository.createTransaction(
        budgetId: deleted.budgetId,
        accountId: deleted.accountId,
        type: deleted.type,
        amount: deleted.amount,
        currency: deleted.currency,
        date: deleted.date,
        createdBy: deleted.createdBy,
        envelopeId: deleted.envelopeId,
        exchangeRate: deleted.exchangeRate,
        payee: deleted.payee,
        notes: deleted.notes,
        transferPairId: deleted.transferPairId,
      );
    } on TransactionException {
      emit(
        state.copyWith(
          status: TransactionsStatus.error,
          error: TransactionsError.undoFailed,
        ),
      );
      emit(state.copyWith(status: TransactionsStatus.loaded, error: null));
    }
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
    return super.close();
  }
}
