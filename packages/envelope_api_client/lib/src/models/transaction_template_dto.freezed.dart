// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_template_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionTemplateDto {
  String get id;
  @JsonKey(name: 'budget_id')
  String get budgetId;
  String get name;
  String get type;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @JsonKey(name: 'account_id')
  String? get accountId;
  @JsonKey(name: 'envelope_id')
  String? get envelopeId;
  @JsonKey(name: 'amount_cents')
  int? get amountCents;
  String? get payee;
  String? get notes;
  String? get currency;
  @JsonKey(name: 'tag_ids_json')
  String? get tagIdsJson;
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt;

  /// Create a copy of TransactionTemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionTemplateDtoCopyWith<TransactionTemplateDto> get copyWith =>
      _$TransactionTemplateDtoCopyWithImpl<TransactionTemplateDto>(
        this as TransactionTemplateDto,
        _$identity,
      );

  /// Serializes this TransactionTemplateDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransactionTemplateDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.amountCents, amountCents) ||
                other.amountCents == amountCents) &&
            (identical(other.payee, payee) || other.payee == payee) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.tagIdsJson, tagIdsJson) ||
                other.tagIdsJson == tagIdsJson) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    name,
    type,
    createdAt,
    updatedAt,
    accountId,
    envelopeId,
    amountCents,
    payee,
    notes,
    currency,
    tagIdsJson,
    sortOrder,
    deletedAt,
  );

  @override
  String toString() {
    return 'TransactionTemplateDto(id: $id, budgetId: $budgetId, name: $name, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, accountId: $accountId, envelopeId: $envelopeId, amountCents: $amountCents, payee: $payee, notes: $notes, currency: $currency, tagIdsJson: $tagIdsJson, sortOrder: $sortOrder, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class $TransactionTemplateDtoCopyWith<$Res> {
  factory $TransactionTemplateDtoCopyWith(
    TransactionTemplateDto value,
    $Res Function(TransactionTemplateDto) _then,
  ) = _$TransactionTemplateDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    String name,
    String type,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'account_id') String? accountId,
    @JsonKey(name: 'envelope_id') String? envelopeId,
    @JsonKey(name: 'amount_cents') int? amountCents,
    String? payee,
    String? notes,
    String? currency,
    @JsonKey(name: 'tag_ids_json') String? tagIdsJson,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
  });
}

/// @nodoc
class _$TransactionTemplateDtoCopyWithImpl<$Res>
    implements $TransactionTemplateDtoCopyWith<$Res> {
  _$TransactionTemplateDtoCopyWithImpl(this._self, this._then);

  final TransactionTemplateDto _self;
  final $Res Function(TransactionTemplateDto) _then;

  /// Create a copy of TransactionTemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? name = null,
    Object? type = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? accountId = freezed,
    Object? envelopeId = freezed,
    Object? amountCents = freezed,
    Object? payee = freezed,
    Object? notes = freezed,
    Object? currency = freezed,
    Object? tagIdsJson = freezed,
    Object? sortOrder = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        budgetId: null == budgetId
            ? _self.budgetId
            : budgetId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        accountId: freezed == accountId
            ? _self.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String?,
        envelopeId: freezed == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        amountCents: freezed == amountCents
            ? _self.amountCents
            : amountCents // ignore: cast_nullable_to_non_nullable
                  as int?,
        payee: freezed == payee
            ? _self.payee
            : payee // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _self.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        currency: freezed == currency
            ? _self.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String?,
        tagIdsJson: freezed == tagIdsJson
            ? _self.tagIdsJson
            : tagIdsJson // ignore: cast_nullable_to_non_nullable
                  as String?,
        sortOrder: null == sortOrder
            ? _self.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        deletedAt: freezed == deletedAt
            ? _self.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [TransactionTemplateDto].
extension TransactionTemplateDtoPatterns on TransactionTemplateDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TransactionTemplateDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransactionTemplateDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TransactionTemplateDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionTemplateDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TransactionTemplateDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionTemplateDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String id,
      @JsonKey(name: 'budget_id') String budgetId,
      String name,
      String type,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'account_id') String? accountId,
      @JsonKey(name: 'envelope_id') String? envelopeId,
      @JsonKey(name: 'amount_cents') int? amountCents,
      String? payee,
      String? notes,
      String? currency,
      @JsonKey(name: 'tag_ids_json') String? tagIdsJson,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransactionTemplateDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.type,
          _that.createdAt,
          _that.updatedAt,
          _that.accountId,
          _that.envelopeId,
          _that.amountCents,
          _that.payee,
          _that.notes,
          _that.currency,
          _that.tagIdsJson,
          _that.sortOrder,
          _that.deletedAt,
        );
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String id,
      @JsonKey(name: 'budget_id') String budgetId,
      String name,
      String type,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'account_id') String? accountId,
      @JsonKey(name: 'envelope_id') String? envelopeId,
      @JsonKey(name: 'amount_cents') int? amountCents,
      String? payee,
      String? notes,
      String? currency,
      @JsonKey(name: 'tag_ids_json') String? tagIdsJson,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionTemplateDto():
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.type,
          _that.createdAt,
          _that.updatedAt,
          _that.accountId,
          _that.envelopeId,
          _that.amountCents,
          _that.payee,
          _that.notes,
          _that.currency,
          _that.tagIdsJson,
          _that.sortOrder,
          _that.deletedAt,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String id,
      @JsonKey(name: 'budget_id') String budgetId,
      String name,
      String type,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'account_id') String? accountId,
      @JsonKey(name: 'envelope_id') String? envelopeId,
      @JsonKey(name: 'amount_cents') int? amountCents,
      String? payee,
      String? notes,
      String? currency,
      @JsonKey(name: 'tag_ids_json') String? tagIdsJson,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionTemplateDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.type,
          _that.createdAt,
          _that.updatedAt,
          _that.accountId,
          _that.envelopeId,
          _that.amountCents,
          _that.payee,
          _that.notes,
          _that.currency,
          _that.tagIdsJson,
          _that.sortOrder,
          _that.deletedAt,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TransactionTemplateDto implements TransactionTemplateDto {
  const _TransactionTemplateDto({
    required this.id,
    @JsonKey(name: 'budget_id') required this.budgetId,
    required this.name,
    required this.type,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(name: 'account_id') this.accountId,
    @JsonKey(name: 'envelope_id') this.envelopeId,
    @JsonKey(name: 'amount_cents') this.amountCents,
    this.payee,
    this.notes,
    this.currency,
    @JsonKey(name: 'tag_ids_json') this.tagIdsJson,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    @JsonKey(name: 'deleted_at') this.deletedAt,
  });
  factory _TransactionTemplateDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionTemplateDtoFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'budget_id')
  final String budgetId;
  @override
  final String name;
  @override
  final String type;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'account_id')
  final String? accountId;
  @override
  @JsonKey(name: 'envelope_id')
  final String? envelopeId;
  @override
  @JsonKey(name: 'amount_cents')
  final int? amountCents;
  @override
  final String? payee;
  @override
  final String? notes;
  @override
  final String? currency;
  @override
  @JsonKey(name: 'tag_ids_json')
  final String? tagIdsJson;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  /// Create a copy of TransactionTemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransactionTemplateDtoCopyWith<_TransactionTemplateDto> get copyWith =>
      __$TransactionTemplateDtoCopyWithImpl<_TransactionTemplateDto>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$TransactionTemplateDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransactionTemplateDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.amountCents, amountCents) ||
                other.amountCents == amountCents) &&
            (identical(other.payee, payee) || other.payee == payee) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.tagIdsJson, tagIdsJson) ||
                other.tagIdsJson == tagIdsJson) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    name,
    type,
    createdAt,
    updatedAt,
    accountId,
    envelopeId,
    amountCents,
    payee,
    notes,
    currency,
    tagIdsJson,
    sortOrder,
    deletedAt,
  );

  @override
  String toString() {
    return 'TransactionTemplateDto(id: $id, budgetId: $budgetId, name: $name, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, accountId: $accountId, envelopeId: $envelopeId, amountCents: $amountCents, payee: $payee, notes: $notes, currency: $currency, tagIdsJson: $tagIdsJson, sortOrder: $sortOrder, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class _$TransactionTemplateDtoCopyWith<$Res>
    implements $TransactionTemplateDtoCopyWith<$Res> {
  factory _$TransactionTemplateDtoCopyWith(
    _TransactionTemplateDto value,
    $Res Function(_TransactionTemplateDto) _then,
  ) = __$TransactionTemplateDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    String name,
    String type,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'account_id') String? accountId,
    @JsonKey(name: 'envelope_id') String? envelopeId,
    @JsonKey(name: 'amount_cents') int? amountCents,
    String? payee,
    String? notes,
    String? currency,
    @JsonKey(name: 'tag_ids_json') String? tagIdsJson,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
  });
}

/// @nodoc
class __$TransactionTemplateDtoCopyWithImpl<$Res>
    implements _$TransactionTemplateDtoCopyWith<$Res> {
  __$TransactionTemplateDtoCopyWithImpl(this._self, this._then);

  final _TransactionTemplateDto _self;
  final $Res Function(_TransactionTemplateDto) _then;

  /// Create a copy of TransactionTemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? name = null,
    Object? type = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? accountId = freezed,
    Object? envelopeId = freezed,
    Object? amountCents = freezed,
    Object? payee = freezed,
    Object? notes = freezed,
    Object? currency = freezed,
    Object? tagIdsJson = freezed,
    Object? sortOrder = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _TransactionTemplateDto(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        budgetId: null == budgetId
            ? _self.budgetId
            : budgetId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        accountId: freezed == accountId
            ? _self.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String?,
        envelopeId: freezed == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        amountCents: freezed == amountCents
            ? _self.amountCents
            : amountCents // ignore: cast_nullable_to_non_nullable
                  as int?,
        payee: freezed == payee
            ? _self.payee
            : payee // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _self.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        currency: freezed == currency
            ? _self.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String?,
        tagIdsJson: freezed == tagIdsJson
            ? _self.tagIdsJson
            : tagIdsJson // ignore: cast_nullable_to_non_nullable
                  as String?,
        sortOrder: null == sortOrder
            ? _self.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        deletedAt: freezed == deletedAt
            ? _self.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
