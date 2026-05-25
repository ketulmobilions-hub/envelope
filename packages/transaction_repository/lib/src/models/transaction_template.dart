import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_template.freezed.dart';
part 'transaction_template.g.dart';

@freezed
abstract class TransactionTemplate with _$TransactionTemplate {
  const factory TransactionTemplate({
    required String id,
    required String budgetId,
    required String name,
    required String type,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? accountId,
    String? envelopeId,
    int? amountCents,
    String? payee,
    String? notes,
    String? currency,
    @Default(<String>[]) List<String> tagIds,
    @Default(0) int sortOrder,
    DateTime? deletedAt,
  }) = _TransactionTemplate;

  factory TransactionTemplate.fromJson(Map<String, dynamic> json) =>
      _$TransactionTemplateFromJson(json);
}
