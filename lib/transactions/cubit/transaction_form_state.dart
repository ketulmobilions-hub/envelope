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
    this.readyToAssign = 0,
  });

  final String envelopeName;
  final int deficitCents;
  final EnvelopeAllocation overspentAllocation;
  final List<EnvelopeAllocation> allocations;
  final List<Envelope> envelopes;
  final int readyToAssign;

  @override
  List<Object?> get props => [
        envelopeName,
        deficitCents,
        overspentAllocation,
        allocations,
        envelopes,
        readyToAssign,
      ];
}

final class TransactionFormState extends Equatable {
  const TransactionFormState({
    this.status = TransactionFormStatus.loading,
    this.accounts = const [],
    this.envelopes = const [],
    this.tags = const [],
    this.selectedTagIds = const [],
    this.initialSplits = const [],
    this.errorMessage,
    this.tagError,
    this.overspendData,
    this.isRecurring = false,
    this.recurringFrequency = 'monthly',
    this.recurringCustomInterval,
    this.recurringCustomUnit = 'days',
    this.recurringEndDate,
    this.recurringAutoPost = false,
  });

  final TransactionFormStatus status;
  final List<Account> accounts;
  final List<Envelope> envelopes;
  final List<Tag> tags;
  final List<String> selectedTagIds;
  final List<SplitEntry> initialSplits;
  final String? errorMessage;
  final String? tagError;
  final OverspendData? overspendData;

  // Recurring rule fields.
  final bool isRecurring;
  final String recurringFrequency;
  final int? recurringCustomInterval;
  final String recurringCustomUnit;
  final DateTime? recurringEndDate;
  final bool recurringAutoPost;

  static const Object _sentinel = Object();
  static const Object _customIntervalSentinel = Object();
  static const Object _endDateSentinel = Object();

  TransactionFormState copyWith({
    TransactionFormStatus? status,
    List<Account>? accounts,
    List<Envelope>? envelopes,
    List<Tag>? tags,
    List<String>? selectedTagIds,
    List<SplitEntry>? initialSplits,
    String? errorMessage,
    String? tagError,
    Object? overspendData = _sentinel,
    bool? isRecurring,
    String? recurringFrequency,
    Object? recurringCustomInterval = _customIntervalSentinel,
    String? recurringCustomUnit,
    Object? recurringEndDate = _endDateSentinel,
    bool? recurringAutoPost,
  }) {
    return TransactionFormState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      envelopes: envelopes ?? this.envelopes,
      tags: tags ?? this.tags,
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
      initialSplits: initialSplits ?? this.initialSplits,
      errorMessage: errorMessage,
      tagError: tagError,
      overspendData: overspendData == _sentinel
          ? this.overspendData
          : overspendData as OverspendData?,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringFrequency: recurringFrequency ?? this.recurringFrequency,
      recurringCustomInterval:
          recurringCustomInterval == _customIntervalSentinel
              ? this.recurringCustomInterval
              : recurringCustomInterval as int?,
      recurringCustomUnit: recurringCustomUnit ?? this.recurringCustomUnit,
      recurringEndDate: recurringEndDate == _endDateSentinel
          ? this.recurringEndDate
          : recurringEndDate as DateTime?,
      recurringAutoPost: recurringAutoPost ?? this.recurringAutoPost,
    );
  }

  @override
  List<Object?> get props => [
        status,
        accounts,
        envelopes,
        tags,
        selectedTagIds,
        initialSplits,
        errorMessage,
        tagError,
        overspendData,
        isRecurring,
        recurringFrequency,
        recurringCustomInterval,
        recurringCustomUnit,
        recurringEndDate,
        recurringAutoPost,
      ];
}
