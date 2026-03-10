// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_group_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryGroupDto {
  String get id;
  @JsonKey(name: 'budget_id')
  String get budgetId;
  String get name;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @JsonKey(name: 'is_default')
  bool get isDefault;
  @JsonKey(name: 'is_archived')
  bool get isArchived;

  /// Create a copy of CategoryGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CategoryGroupDtoCopyWith<CategoryGroupDto> get copyWith =>
      _$CategoryGroupDtoCopyWithImpl<CategoryGroupDto>(
        this as CategoryGroupDto,
        _$identity,
      );

  /// Serializes this CategoryGroupDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CategoryGroupDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    name,
    createdAt,
    sortOrder,
    isDefault,
    isArchived,
  );

  @override
  String toString() {
    return 'CategoryGroupDto(id: $id, budgetId: $budgetId, name: $name, createdAt: $createdAt, sortOrder: $sortOrder, isDefault: $isDefault, isArchived: $isArchived)';
  }
}

/// @nodoc
abstract mixin class $CategoryGroupDtoCopyWith<$Res> {
  factory $CategoryGroupDtoCopyWith(
    CategoryGroupDto value,
    $Res Function(CategoryGroupDto) _then,
  ) = _$CategoryGroupDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    String name,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_default') bool isDefault,
    @JsonKey(name: 'is_archived') bool isArchived,
  });
}

/// @nodoc
class _$CategoryGroupDtoCopyWithImpl<$Res>
    implements $CategoryGroupDtoCopyWith<$Res> {
  _$CategoryGroupDtoCopyWithImpl(this._self, this._then);

  final CategoryGroupDto _self;
  final $Res Function(CategoryGroupDto) _then;

  /// Create a copy of CategoryGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? name = null,
    Object? createdAt = null,
    Object? sortOrder = null,
    Object? isDefault = null,
    Object? isArchived = null,
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
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        sortOrder: null == sortOrder
            ? _self.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        isDefault: null == isDefault
            ? _self.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool,
        isArchived: null == isArchived
            ? _self.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [CategoryGroupDto].
extension CategoryGroupDtoPatterns on CategoryGroupDto {
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
    TResult Function(_CategoryGroupDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryGroupDto() when $default != null:
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
    TResult Function(_CategoryGroupDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryGroupDto():
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
    TResult? Function(_CategoryGroupDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryGroupDto() when $default != null:
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
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_default') bool isDefault,
      @JsonKey(name: 'is_archived') bool isArchived,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryGroupDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.createdAt,
          _that.sortOrder,
          _that.isDefault,
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
      @JsonKey(name: 'budget_id') String budgetId,
      String name,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_default') bool isDefault,
      @JsonKey(name: 'is_archived') bool isArchived,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryGroupDto():
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.createdAt,
          _that.sortOrder,
          _that.isDefault,
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
      @JsonKey(name: 'budget_id') String budgetId,
      String name,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_default') bool isDefault,
      @JsonKey(name: 'is_archived') bool isArchived,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryGroupDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.createdAt,
          _that.sortOrder,
          _that.isDefault,
          _that.isArchived,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CategoryGroupDto implements CategoryGroupDto {
  const _CategoryGroupDto({
    required this.id,
    @JsonKey(name: 'budget_id') required this.budgetId,
    required this.name,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    @JsonKey(name: 'is_default') this.isDefault = false,
    @JsonKey(name: 'is_archived') this.isArchived = false,
  });
  factory _CategoryGroupDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryGroupDtoFromJson(json);

  @override
  final String id;
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
  @JsonKey(name: 'is_default')
  final bool isDefault;
  @override
  @JsonKey(name: 'is_archived')
  final bool isArchived;

  /// Create a copy of CategoryGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CategoryGroupDtoCopyWith<_CategoryGroupDto> get copyWith =>
      __$CategoryGroupDtoCopyWithImpl<_CategoryGroupDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CategoryGroupDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CategoryGroupDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    name,
    createdAt,
    sortOrder,
    isDefault,
    isArchived,
  );

  @override
  String toString() {
    return 'CategoryGroupDto(id: $id, budgetId: $budgetId, name: $name, createdAt: $createdAt, sortOrder: $sortOrder, isDefault: $isDefault, isArchived: $isArchived)';
  }
}

/// @nodoc
abstract mixin class _$CategoryGroupDtoCopyWith<$Res>
    implements $CategoryGroupDtoCopyWith<$Res> {
  factory _$CategoryGroupDtoCopyWith(
    _CategoryGroupDto value,
    $Res Function(_CategoryGroupDto) _then,
  ) = __$CategoryGroupDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    String name,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_default') bool isDefault,
    @JsonKey(name: 'is_archived') bool isArchived,
  });
}

/// @nodoc
class __$CategoryGroupDtoCopyWithImpl<$Res>
    implements _$CategoryGroupDtoCopyWith<$Res> {
  __$CategoryGroupDtoCopyWithImpl(this._self, this._then);

  final _CategoryGroupDto _self;
  final $Res Function(_CategoryGroupDto) _then;

  /// Create a copy of CategoryGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? name = null,
    Object? createdAt = null,
    Object? sortOrder = null,
    Object? isDefault = null,
    Object? isArchived = null,
  }) {
    return _then(
      _CategoryGroupDto(
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
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        sortOrder: null == sortOrder
            ? _self.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        isDefault: null == isDefault
            ? _self.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool,
        isArchived: null == isArchived
            ? _self.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
