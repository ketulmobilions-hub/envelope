// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'allocation_template_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AllocationTemplateDto {
  String get id;
  @JsonKey(name: 'budget_id')
  String get budgetId;
  String get name;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of AllocationTemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AllocationTemplateDtoCopyWith<AllocationTemplateDto> get copyWith =>
      _$AllocationTemplateDtoCopyWithImpl<AllocationTemplateDto>(
        this as AllocationTemplateDto,
        _$identity,
      );

  /// Serializes this AllocationTemplateDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AllocationTemplateDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, budgetId, name, createdAt);

  @override
  String toString() {
    return 'AllocationTemplateDto(id: $id, budgetId: $budgetId, name: $name, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $AllocationTemplateDtoCopyWith<$Res> {
  factory $AllocationTemplateDtoCopyWith(
    AllocationTemplateDto value,
    $Res Function(AllocationTemplateDto) _then,
  ) = _$AllocationTemplateDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    String name,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$AllocationTemplateDtoCopyWithImpl<$Res>
    implements $AllocationTemplateDtoCopyWith<$Res> {
  _$AllocationTemplateDtoCopyWithImpl(this._self, this._then);

  final AllocationTemplateDto _self;
  final $Res Function(AllocationTemplateDto) _then;

  /// Create a copy of AllocationTemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? name = null,
    Object? createdAt = null,
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
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [AllocationTemplateDto].
extension AllocationTemplateDtoPatterns on AllocationTemplateDto {
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
    TResult Function(_AllocationTemplateDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateDto() when $default != null:
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
    TResult Function(_AllocationTemplateDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateDto():
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
    TResult? Function(_AllocationTemplateDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateDto() when $default != null:
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
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateDto() when $default != null:
        return $default(_that.id, _that.budgetId, _that.name, _that.createdAt);
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
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateDto():
        return $default(_that.id, _that.budgetId, _that.name, _that.createdAt);
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
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateDto() when $default != null:
        return $default(_that.id, _that.budgetId, _that.name, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AllocationTemplateDto implements AllocationTemplateDto {
  const _AllocationTemplateDto({
    required this.id,
    @JsonKey(name: 'budget_id') required this.budgetId,
    required this.name,
    @JsonKey(name: 'created_at') required this.createdAt,
  });
  factory _AllocationTemplateDto.fromJson(Map<String, dynamic> json) =>
      _$AllocationTemplateDtoFromJson(json);

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

  /// Create a copy of AllocationTemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AllocationTemplateDtoCopyWith<_AllocationTemplateDto> get copyWith =>
      __$AllocationTemplateDtoCopyWithImpl<_AllocationTemplateDto>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$AllocationTemplateDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AllocationTemplateDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, budgetId, name, createdAt);

  @override
  String toString() {
    return 'AllocationTemplateDto(id: $id, budgetId: $budgetId, name: $name, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$AllocationTemplateDtoCopyWith<$Res>
    implements $AllocationTemplateDtoCopyWith<$Res> {
  factory _$AllocationTemplateDtoCopyWith(
    _AllocationTemplateDto value,
    $Res Function(_AllocationTemplateDto) _then,
  ) = __$AllocationTemplateDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    String name,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$AllocationTemplateDtoCopyWithImpl<$Res>
    implements _$AllocationTemplateDtoCopyWith<$Res> {
  __$AllocationTemplateDtoCopyWithImpl(this._self, this._then);

  final _AllocationTemplateDto _self;
  final $Res Function(_AllocationTemplateDto) _then;

  /// Create a copy of AllocationTemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? name = null,
    Object? createdAt = null,
  }) {
    return _then(
      _AllocationTemplateDto(
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
      ),
    );
  }
}
