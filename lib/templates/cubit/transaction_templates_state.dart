part of 'transaction_templates_cubit.dart';

enum TransactionTemplatesStatus { loading, loaded, error }

final class TransactionTemplatesState extends Equatable {
  const TransactionTemplatesState({
    this.status = TransactionTemplatesStatus.loading,
    this.templates = const [],
    this.errorMessage,
  });

  final TransactionTemplatesStatus status;
  final List<TransactionTemplate> templates;
  final String? errorMessage;

  TransactionTemplatesState copyWith({
    TransactionTemplatesStatus? status,
    List<TransactionTemplate>? templates,
    String? errorMessage,
  }) {
    return TransactionTemplatesState(
      status: status ?? this.status,
      templates: templates ?? this.templates,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, templates, errorMessage];
}
