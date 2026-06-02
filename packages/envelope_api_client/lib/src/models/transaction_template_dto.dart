import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_template_dto.freezed.dart';
part 'transaction_template_dto.g.dart';

/// Data transfer object for the `transaction_templates` table.
@freezed
abstract class TransactionTemplateDto with _$TransactionTemplateDto {
  const factory TransactionTemplateDto({
    required String id,
    @JsonKey(name: 'budget_id') required String budgetId,
    required String name,
    required String type,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'account_id') String? accountId,
    @JsonKey(name: 'envelope_id') String? envelopeId,
    @JsonKey(name: 'amount_cents') int? amountCents,
    String? payee,
    String? notes,
    String? currency,
    @JsonKey(name: 'tag_ids_json') String? tagIdsJson,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
  }) = _TransactionTemplateDto;

  factory TransactionTemplateDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionTemplateDtoFromJson(json);
}
