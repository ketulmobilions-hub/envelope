// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionTemplate _$TransactionTemplateFromJson(Map<String, dynamic> json) =>
    _TransactionTemplate(
      id: json['id'] as String,
      budgetId: json['budgetId'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      accountId: json['accountId'] as String?,
      envelopeId: json['envelopeId'] as String?,
      amountCents: (json['amountCents'] as num?)?.toInt(),
      payee: json['payee'] as String?,
      notes: json['notes'] as String?,
      currency: json['currency'] as String?,
      tagIds:
          (json['tagIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$TransactionTemplateToJson(
  _TransactionTemplate instance,
) => <String, dynamic>{
  'id': instance.id,
  'budgetId': instance.budgetId,
  'name': instance.name,
  'type': instance.type,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'accountId': instance.accountId,
  'envelopeId': instance.envelopeId,
  'amountCents': instance.amountCents,
  'payee': instance.payee,
  'notes': instance.notes,
  'currency': instance.currency,
  'tagIds': instance.tagIds,
  'sortOrder': instance.sortOrder,
  'deletedAt': instance.deletedAt?.toIso8601String(),
};
