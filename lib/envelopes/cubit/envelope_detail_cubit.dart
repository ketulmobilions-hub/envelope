import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'envelope_detail_state.dart';

class EnvelopeDetailCubit extends Cubit<EnvelopeDetailState> {
  EnvelopeDetailCubit({
    required EnvelopeRepository envelopeRepository,
    required TransactionRepository transactionRepository,
    required AccountRepository accountRepository,
    required Envelope envelope,
  }) : _envelopeRepository = envelopeRepository,
       _transactionRepository = transactionRepository,
       _accountRepository = accountRepository,
       super(EnvelopeDetailState(envelope: envelope)) {
    _transactionSubscription = transactionRepository
        .watchTransactions(
          budgetId: envelope.budgetId,
          accountId: envelope.linkedAccountId,
          envelopeId: envelope.linkedAccountId == null ? envelope.id : null,
        )
        .listen((txns) {
          if (isClosed) return;
          emit(state.copyWith(transactions: txns));
        });

    _allocationSubscription = _envelopeRepository
        .watchAllocationByEnvelopeId(envelope.id)
        .listen((allocation) {
          if (isClosed) return;
          emit(state.copyWith(allocation: allocation));
        });

    _spentSubscription = _envelopeRepository
        .watchSpentByEnvelopeForBudget(envelope.budgetId)
        .listen((map) {
          if (isClosed) return;
          emit(state.copyWith(spentTotalCents: map[envelope.id] ?? 0));
        });

    final linkedAccountId = envelope.linkedAccountId;
    if (linkedAccountId != null) {
      _accountsSubscription = _accountRepository
          .watchAccounts(envelope.budgetId)
          .listen((accounts) {
            if (isClosed) return;
            final linked = accounts
                .where((a) => a.id == linkedAccountId)
                .firstOrNull;
            if (linked != null) emit(state.copyWith(linkedAccount: linked));
          });
      unawaited(_loadCreditLimit(linkedAccountId));
    }

    unawaited(_refreshTransactions());
  }

  final EnvelopeRepository _envelopeRepository;
  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;
  StreamSubscription<List<Transaction>>? _transactionSubscription;
  StreamSubscription<EnvelopeAllocation?>? _allocationSubscription;
  StreamSubscription<Map<String, int>>? _spentSubscription;
  StreamSubscription<List<Account>>? _accountsSubscription;

  Future<void> _loadCreditLimit(String accountId) async {
    try {
      final debt = await _accountRepository.getDebtAccount(accountId);
      if (isClosed) return;
      emit(state.copyWith(ccCreditLimit: debt?.creditLimit));
    } on Exception {
      // Best-effort.
    }
  }

  Future<void> _refreshTransactions() async {
    try {
      await _transactionRepository.refreshTransactions(state.envelope.budgetId);
    } on TransactionException {
      // Keep showing whatever is cached if refresh fails.
    }
  }

  Future<void> refresh() async {
    try {
      final updated = await _envelopeRepository.getEnvelope(state.envelope.id);
      emit(state.copyWith(envelope: updated));
    } on EnvelopeException {
      // Keep current data if refresh fails.
    }
  }

  Future<bool> deleteEnvelope() async {
    try {
      await _envelopeRepository.deleteEnvelope(state.envelope.id);
      return true;
    } on EnvelopeException {
      return false;
    }
  }

  @override
  Future<void> close() async {
    await _transactionSubscription?.cancel();
    await _allocationSubscription?.cancel();
    await _spentSubscription?.cancel();
    await _accountsSubscription?.cancel();
    return super.close();
  }
}
