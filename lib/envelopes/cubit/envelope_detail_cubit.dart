import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'envelope_detail_state.dart';

class EnvelopeDetailCubit extends Cubit<EnvelopeDetailState> {
  EnvelopeDetailCubit({
    required EnvelopeRepository envelopeRepository,
    required TransactionRepository transactionRepository,
    required Envelope envelope,
    EnvelopeAllocation? allocation,
  })  : _envelopeRepository = envelopeRepository,
        _transactionRepository = transactionRepository,
        super(EnvelopeDetailState(
          envelope: envelope,
          allocation: allocation,
        )) {
    _transactionSubscription = transactionRepository
        .watchTransactions(
          budgetId: envelope.budgetId,
          envelopeId: envelope.id,
        )
        .listen((txns) => emit(state.copyWith(transactions: txns)));
    unawaited(_refreshTransactions());
  }

  final EnvelopeRepository _envelopeRepository;
  final TransactionRepository _transactionRepository;
  StreamSubscription<List<Transaction>>? _transactionSubscription;

  Future<void> _refreshTransactions() async {
    try {
      await _transactionRepository
          .refreshTransactions(state.envelope.budgetId);
    } on TransactionException {
      // Keep showing whatever is cached if refresh fails.
    }
  }

  /// Refreshes the envelope data from the repository.
  Future<void> refresh() async {
    try {
      final updated =
          await _envelopeRepository.getEnvelope(state.envelope.id);
      emit(state.copyWith(envelope: updated));
    } on EnvelopeException {
      // Keep current data if refresh fails.
    }
  }

  /// Deletes the envelope from the repository.
  /// Returns `true` on success, `false` on failure.
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
    return super.close();
  }
}
