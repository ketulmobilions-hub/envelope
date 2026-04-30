import 'package:freezed_annotation/freezed_annotation.dart';

part 'envelope.freezed.dart';
part 'envelope.g.dart';

@freezed
abstract class Envelope with _$Envelope {
  const factory Envelope({
    required String id,
    required String categoryGroupId,
    required String budgetId,
    required String name,
    required DateTime createdAt,
    @Default(0) int sortOrder,
    @Default(false) bool isArchived,
    @Default(null) String? color,
    @Default(null) String? linkedAccountId,
  }) = _Envelope;

  factory Envelope.fromJson(Map<String, dynamic> json) =>
      _$EnvelopeFromJson(json);
}
