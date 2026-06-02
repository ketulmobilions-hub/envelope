// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionTemplate {
  String get id;
  String get budgetId;
  String get name;
  String get type;
  DateTime get createdAt;
  DateTime get updatedAt;
  String? get accountId;
  String? get envelopeId;
  int? get amountCents;
  String? get payee;
  String? get notes;
  String? get currency;
  List<String> get tagIds;
  int get sortOrder;
  DateTime? get deletedAt;

  /// Create a copy of TransactionTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionTemplateCopyWith<TransactionTemplate> get copyWith =>
      _$TransactionTemplateCopyWithImpl<TransactionTemplate>(
        this as TransactionTemplate,
        _$identity,
      );

  /// Serializes this TransactionTemplate to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransactionTemplate &&
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
            const DeepCollectionEquality().equals(other.tagIds, tagIds) &&
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
    const DeepCollectionEquality().hash(tagIds),
    sortOrder,
    deletedAt,
  );

  @override
  String toString() {
    return 'TransactionTemplate(id: $id, budgetId: $budgetId, name: $name, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, accountId: $accountId, envelopeId: $envelopeId, amountCents: $amountCents, payee: $payee, notes: $notes, currency: $currency, tagIds: $tagIds, sortOrder: $sortOrder, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class $TransactionTemplateCopyWith<$Res> {
  factory $TransactionTemplateCopyWith(
    TransactionTemplate value,
    $Res Function(TransactionTemplate) _then,
  ) = _$TransactionTemplateCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String budgetId,
    String name,
    String type,
    DateTime createdAt,
    DateTime updatedAt,
    String? accountId,
    String? envelopeId,
    int? amountCents,
    String? payee,
    String? notes,
    String? currency,
    List<String> tagIds,
    int sortOrder,
    DateTime? deletedAt,
  });
}

/// @nodoc
class _$TransactionTemplateCopyWithImpl<$Res>
    implements $TransactionTemplateCopyWith<$Res> {
  _$TransactionTemplateCopyWithImpl(this._self, this._then);

  final TransactionTemplate _self;
  final $Res Function(TransactionTemplate) _then;

  /// Create a copy of TransactionTemplate
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
    Object? tagIds = null,
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
        tagIds: null == tagIds
            ? _self.tagIds
            : tagIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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

/// Adds pattern-matching-related methods to [TransactionTemplate].
extension TransactionTemplatePatterns on TransactionTemplate {
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
    TResult Function(_TransactionTemplate value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransactionTemplate() when $default != null:
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
    TResult Function(_TransactionTemplate value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionTemplate():
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
    TResult? Function(_TransactionTemplate value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionTemplate() when $default != null:
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
      String budgetId,
      String name,
      String type,
      DateTime createdAt,
      DateTime updatedAt,
      String? accountId,
      String? envelopeId,
      int? amountCents,
      String? payee,
      String? notes,
      String? currency,
      List<String> tagIds,
      int sortOrder,
      DateTime? deletedAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransactionTemplate() when $default != null:
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
          _that.tagIds,
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
      String budgetId,
      String name,
      String type,
      DateTime createdAt,
      DateTime updatedAt,
      String? accountId,
      String? envelopeId,
      int? amountCents,
      String? payee,
      String? notes,
      String? currency,
      List<String> tagIds,
      int sortOrder,
      DateTime? deletedAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionTemplate():
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
          _that.tagIds,
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
      String budgetId,
      String name,
      String type,
      DateTime createdAt,
      DateTime updatedAt,
      String? accountId,
      String? envelopeId,
      int? amountCents,
      String? payee,
      String? notes,
      String? currency,
      List<String> tagIds,
      int sortOrder,
      DateTime? deletedAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionTemplate() when $default != null:
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
          _that.tagIds,
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
class _TransactionTemplate implements TransactionTemplate {
  const _TransactionTemplate({
    required this.id,
    required this.budgetId,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.accountId,
    this.envelopeId,
    this.amountCents,
    this.payee,
    this.notes,
    this.currency,
    final List<String> tagIds = const <String>[],
    this.sortOrder = 0,
    this.deletedAt,
  }) : _tagIds = tagIds;
  factory _TransactionTemplate.fromJson(Map<String, dynamic> json) =>
      _$TransactionTemplateFromJson(json);

  @override
  final String id;
  @override
  final String budgetId;
  @override
  final String name;
  @override
  final String type;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? accountId;
  @override
  final String? envelopeId;
  @override
  final int? amountCents;
  @override
  final String? payee;
  @override
  final String? notes;
  @override
  final String? currency;
  final List<String> _tagIds;
  @override
  @JsonKey()
  List<String> get tagIds {
    if (_tagIds is EqualUnmodifiableListView) return _tagIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagIds);
  }

  @override
  @JsonKey()
  final int sortOrder;
  @override
  final DateTime? deletedAt;

  /// Create a copy of TransactionTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransactionTemplateCopyWith<_TransactionTemplate> get copyWith =>
      __$TransactionTemplateCopyWithImpl<_TransactionTemplate>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$TransactionTemplateToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransactionTemplate &&
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
            const DeepCollectionEquality().equals(other._tagIds, _tagIds) &&
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
    const DeepCollectionEquality().hash(_tagIds),
    sortOrder,
    deletedAt,
  );

  @override
  String toString() {
    return 'TransactionTemplate(id: $id, budgetId: $budgetId, name: $name, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, accountId: $accountId, envelopeId: $envelopeId, amountCents: $amountCents, payee: $payee, notes: $notes, currency: $currency, tagIds: $tagIds, sortOrder: $sortOrder, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class _$TransactionTemplateCopyWith<$Res>
    implements $TransactionTemplateCopyWith<$Res> {
  factory _$TransactionTemplateCopyWith(
    _TransactionTemplate value,
    $Res Function(_TransactionTemplate) _then,
  ) = __$TransactionTemplateCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String budgetId,
    String name,
    String type,
    DateTime createdAt,
    DateTime updatedAt,
    String? accountId,
    String? envelopeId,
    int? amountCents,
    String? payee,
    String? notes,
    String? currency,
    List<String> tagIds,
    int sortOrder,
    DateTime? deletedAt,
  });
}

/// @nodoc
class __$TransactionTemplateCopyWithImpl<$Res>
    implements _$TransactionTemplateCopyWith<$Res> {
  __$TransactionTemplateCopyWithImpl(this._self, this._then);

  final _TransactionTemplate _self;
  final $Res Function(_TransactionTemplate) _then;

  /// Create a copy of TransactionTemplate
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
    Object? tagIds = null,
    Object? sortOrder = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _TransactionTemplate(
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
        tagIds: null == tagIds
            ? _self._tagIds
            : tagIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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
