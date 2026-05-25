import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'transaction_templates_state.dart';

class TransactionTemplatesCubit extends Cubit<TransactionTemplatesState> {
  TransactionTemplatesCubit({
    required TransactionRepository transactionRepository,
    required this.budgetId,
  }) : _transactionRepository = transactionRepository,
       super(const TransactionTemplatesState()) {
    _subscription = _transactionRepository
        .watchTransactionTemplates(budgetId)
        .listen(
          (templates) {
            if (isClosed) return;
            emit(
              state.copyWith(
                status: TransactionTemplatesStatus.loaded,
                templates: templates,
              ),
            );
          },
          onError: (Object error) {
            if (isClosed) return;
            emit(
              state.copyWith(
                status: TransactionTemplatesStatus.error,
                errorMessage: error.toString(),
              ),
            );
          },
        );
    unawaited(_refresh());
  }

  final TransactionRepository _transactionRepository;
  final String budgetId;
  StreamSubscription<List<TransactionTemplate>>? _subscription;

  Future<void> _refresh() async {
    try {
      await _transactionRepository.getTransactionTemplates(budgetId);
    } on Exception {
      // Stream subscription will surface errors if local cache is also empty.
    }
  }

  Future<void> deleteTemplate(String id) async {
    try {
      await _transactionRepository.deleteTransactionTemplate(id);
    } on Exception catch (e) {
      if (isClosed) return;
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
