// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_template_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionTemplateDto _$TransactionTemplateDtoFromJson(
  Map<String, dynamic> json,
) => _TransactionTemplateDto(
  id: json['id'] as String,
  budgetId: json['budget_id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  accountId: json['account_id'] as String?,
  envelopeId: json['envelope_id'] as String?,
  amountCents: (json['amount_cents'] as num?)?.toInt(),
  payee: json['payee'] as String?,
  notes: json['notes'] as String?,
  currency: json['currency'] as String?,
  tagIdsJson: json['tag_ids_json'] as String?,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
);

Map<String, dynamic> _$TransactionTemplateDtoToJson(
  _TransactionTemplateDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'budget_id': instance.budgetId,
  'name': instance.name,
  'type': instance.type,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'account_id': instance.accountId,
  'envelope_id': instance.envelopeId,
  'amount_cents': instance.amountCents,
  'payee': instance.payee,
  'notes': instance.notes,
  'currency': instance.currency,
  'tag_ids_json': instance.tagIdsJson,
  'sort_order': instance.sortOrder,
  'deleted_at': instance.deletedAt?.toIso8601String(),
};
