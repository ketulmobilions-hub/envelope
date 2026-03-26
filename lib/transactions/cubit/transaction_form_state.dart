part of 'transaction_form_cubit.dart';

enum TransactionFormStatus {
  loading,
  loaded,
  submitting,
  success,
  successWithOverspend,
  failure,
}

final class OverspendData extends Equatable {
  const OverspendData({
    required this.envelopeName,
    required this.deficitCents,
    required this.overspentAllocation,
    required this.allocations,
    required this.envelopes,
  });

  final String envelopeName;
  final int deficitCents;
  final EnvelopeAllocation overspentAllocation;
  final List<EnvelopeAllocation> allocations;
  final List<Envelope> envelopes;

  @override
  List<Object?> get props => [
        envelopeName,
        deficitCents,
        overspentAllocation,
        allocations,
        envelopes,
      ];
}

final class TransactionFormState extends Equatable {
  const TransactionFormState({
    this.status = TransactionFormStatus.loading,
    this.accounts = const [],
    this.envelopes = const [],
    this.tags = const [],
    this.selectedTagIds = const [],
    this.errorMessage,
    this.tagError,
    this.overspendData,
  });

  final TransactionFormStatus status;
  final List<Account> accounts;
  final List<Envelope> envelopes;
  final List<Tag> tags;
  final List<String> selectedTagIds;
  final String? errorMessage;
  final String? tagError;
  final OverspendData? overspendData;

  static const Object _sentinel = Object();

  TransactionFormState copyWith({
    TransactionFormStatus? status,
    List<Account>? accounts,
    List<Envelope>? envelopes,
    List<Tag>? tags,
    List<String>? selectedTagIds,
    String? errorMessage,
    String? tagError,
    Object? overspendData = _sentinel,
  }) {
    return TransactionFormState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      envelopes: envelopes ?? this.envelopes,
      tags: tags ?? this.tags,
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
      errorMessage: errorMessage,
      tagError: tagError,
      overspendData: overspendData == _sentinel
          ? this.overspendData
          : overspendData as OverspendData?,
    );
  }

  @override
  List<Object?> get props => [
        status,
        accounts,
        envelopes,
        tags,
        selectedTagIds,
        errorMessage,
        tagError,
        overspendData,
      ];
}
