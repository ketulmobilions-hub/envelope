// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'envelope_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EnvelopeDto {
  String get id;
  @JsonKey(name: 'category_group_id')
  String get categoryGroupId;
  @JsonKey(name: 'budget_id')
  String get budgetId;
  String get name;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @JsonKey(name: 'is_archived')
  bool get isArchived;

  /// Create a copy of EnvelopeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EnvelopeDtoCopyWith<EnvelopeDto> get copyWith =>
      _$EnvelopeDtoCopyWithImpl<EnvelopeDto>(this as EnvelopeDto, _$identity);

  /// Serializes this EnvelopeDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnvelopeDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryGroupId, categoryGroupId) ||
                other.categoryGroupId == categoryGroupId) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    categoryGroupId,
    budgetId,
    name,
    createdAt,
    sortOrder,
    isArchived,
  );

  @override
  String toString() {
    return 'EnvelopeDto(id: $id, categoryGroupId: $categoryGroupId, budgetId: $budgetId, name: $name, createdAt: $createdAt, sortOrder: $sortOrder, isArchived: $isArchived)';
  }
}

/// @nodoc
abstract mixin class $EnvelopeDtoCopyWith<$Res> {
  factory $EnvelopeDtoCopyWith(
    EnvelopeDto value,
    $Res Function(EnvelopeDto) _then,
  ) = _$EnvelopeDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'category_group_id') String categoryGroupId,
    @JsonKey(name: 'budget_id') String budgetId,
    String name,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_archived') bool isArchived,
  });
}

/// @nodoc
class _$EnvelopeDtoCopyWithImpl<$Res> implements $EnvelopeDtoCopyWith<$Res> {
  _$EnvelopeDtoCopyWithImpl(this._self, this._then);

  final EnvelopeDto _self;
  final $Res Function(EnvelopeDto) _then;

  /// Create a copy of EnvelopeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryGroupId = null,
    Object? budgetId = null,
    Object? name = null,
    Object? createdAt = null,
    Object? sortOrder = null,
    Object? isArchived = null,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryGroupId: null == categoryGroupId
            ? _self.categoryGroupId
            : categoryGroupId // ignore: cast_nullable_to_non_nullable
                  as String,
        budgetId: null == budgetId
            ? _self.budgetId
            : budgetId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        sortOrder: null == sortOrder
            ? _self.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        isArchived: null == isArchived
            ? _self.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [EnvelopeDto].
extension EnvelopeDtoPatterns on EnvelopeDto {
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
    TResult Function(_EnvelopeDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EnvelopeDto() when $default != null:
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
    TResult Function(_EnvelopeDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvelopeDto():
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
    TResult? Function(_EnvelopeDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvelopeDto() when $default != null:
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
      @JsonKey(name: 'category_group_id') String categoryGroupId,
      @JsonKey(name: 'budget_id') String budgetId,
      String name,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_archived') bool isArchived,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EnvelopeDto() when $default != null:
        return $default(
          _that.id,
          _that.categoryGroupId,
          _that.budgetId,
          _that.name,
          _that.createdAt,
          _that.sortOrder,
          _that.isArchived,
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
      @JsonKey(name: 'category_group_id') String categoryGroupId,
      @JsonKey(name: 'budget_id') String budgetId,
      String name,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_archived') bool isArchived,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvelopeDto():
        return $default(
          _that.id,
          _that.categoryGroupId,
          _that.budgetId,
          _that.name,
          _that.createdAt,
          _that.sortOrder,
          _that.isArchived,
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
      @JsonKey(name: 'category_group_id') String categoryGroupId,
      @JsonKey(name: 'budget_id') String budgetId,
      String name,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_archived') bool isArchived,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvelopeDto() when $default != null:
        return $default(
          _that.id,
          _that.categoryGroupId,
          _that.budgetId,
          _that.name,
          _that.createdAt,
          _that.sortOrder,
          _that.isArchived,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _EnvelopeDto implements EnvelopeDto {
  const _EnvelopeDto({
    required this.id,
    @JsonKey(name: 'category_group_id') required this.categoryGroupId,
    @JsonKey(name: 'budget_id') required this.budgetId,
    required this.name,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    @JsonKey(name: 'is_archived') this.isArchived = false,
  });
  factory _EnvelopeDto.fromJson(Map<String, dynamic> json) =>
      _$EnvelopeDtoFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'category_group_id')
  final String categoryGroupId;
  @override
  @JsonKey(name: 'budget_id')
  final String budgetId;
  @override
  final String name;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'is_archived')
  final bool isArchived;

  /// Create a copy of EnvelopeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EnvelopeDtoCopyWith<_EnvelopeDto> get copyWith =>
      __$EnvelopeDtoCopyWithImpl<_EnvelopeDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EnvelopeDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EnvelopeDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryGroupId, categoryGroupId) ||
                other.categoryGroupId == categoryGroupId) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    categoryGroupId,
    budgetId,
    name,
    createdAt,
    sortOrder,
    isArchived,
  );

  @override
  String toString() {
    return 'EnvelopeDto(id: $id, categoryGroupId: $categoryGroupId, budgetId: $budgetId, name: $name, createdAt: $createdAt, sortOrder: $sortOrder, isArchived: $isArchived)';
  }
}

/// @nodoc
abstract mixin class _$EnvelopeDtoCopyWith<$Res>
    implements $EnvelopeDtoCopyWith<$Res> {
  factory _$EnvelopeDtoCopyWith(
    _EnvelopeDto value,
    $Res Function(_EnvelopeDto) _then,
  ) = __$EnvelopeDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'category_group_id') String categoryGroupId,
    @JsonKey(name: 'budget_id') String budgetId,
    String name,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_archived') bool isArchived,
  });
}

/// @nodoc
class __$EnvelopeDtoCopyWithImpl<$Res> implements _$EnvelopeDtoCopyWith<$Res> {
  __$EnvelopeDtoCopyWithImpl(this._self, this._then);

  final _EnvelopeDto _self;
  final $Res Function(_EnvelopeDto) _then;

  /// Create a copy of EnvelopeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? categoryGroupId = null,
    Object? budgetId = null,
    Object? name = null,
    Object? createdAt = null,
    Object? sortOrder = null,
    Object? isArchived = null,
  }) {
    return _then(
      _EnvelopeDto(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryGroupId: null == categoryGroupId
            ? _self.categoryGroupId
            : categoryGroupId // ignore: cast_nullable_to_non_nullable
                  as String,
        budgetId: null == budgetId
            ? _self.budgetId
            : budgetId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        sortOrder: null == sortOrder
            ? _self.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        isArchived: null == isArchived
            ? _self.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
