// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_log_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityLogDto {
  String get id;
  @JsonKey(name: 'budget_id')
  String get budgetId;
  @JsonKey(name: 'user_id')
  String get userId;
  String get action;
  @JsonKey(name: 'entity_type')
  String get entityType;
  @JsonKey(name: 'entity_id')
  String get entityId;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  String? get details;

  /// Create a copy of ActivityLogDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActivityLogDtoCopyWith<ActivityLogDto> get copyWith =>
      _$ActivityLogDtoCopyWithImpl<ActivityLogDto>(
        this as ActivityLogDto,
        _$identity,
      );

  /// Serializes this ActivityLogDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActivityLogDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.details, details) || other.details == details));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    userId,
    action,
    entityType,
    entityId,
    createdAt,
    details,
  );

  @override
  String toString() {
    return 'ActivityLogDto(id: $id, budgetId: $budgetId, userId: $userId, action: $action, entityType: $entityType, entityId: $entityId, createdAt: $createdAt, details: $details)';
  }
}

/// @nodoc
abstract mixin class $ActivityLogDtoCopyWith<$Res> {
  factory $ActivityLogDtoCopyWith(
    ActivityLogDto value,
    $Res Function(ActivityLogDto) _then,
  ) = _$ActivityLogDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    @JsonKey(name: 'user_id') String userId,
    String action,
    @JsonKey(name: 'entity_type') String entityType,
    @JsonKey(name: 'entity_id') String entityId,
    @JsonKey(name: 'created_at') DateTime createdAt,
    String? details,
  });
}

/// @nodoc
class _$ActivityLogDtoCopyWithImpl<$Res>
    implements $ActivityLogDtoCopyWith<$Res> {
  _$ActivityLogDtoCopyWithImpl(this._self, this._then);

  final ActivityLogDto _self;
  final $Res Function(ActivityLogDto) _then;

  /// Create a copy of ActivityLogDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? userId = null,
    Object? action = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? createdAt = null,
    Object? details = freezed,
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
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        entityType: null == entityType
            ? _self.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        entityId: null == entityId
            ? _self.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        details: freezed == details
            ? _self.details
            : details // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [ActivityLogDto].
extension ActivityLogDtoPatterns on ActivityLogDto {
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
    TResult Function(_ActivityLogDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityLogDto() when $default != null:
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
    TResult Function(_ActivityLogDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityLogDto():
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
    TResult? Function(_ActivityLogDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityLogDto() when $default != null:
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
      @JsonKey(name: 'user_id') String userId,
      String action,
      @JsonKey(name: 'entity_type') String entityType,
      @JsonKey(name: 'entity_id') String entityId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      String? details,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityLogDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.userId,
          _that.action,
          _that.entityType,
          _that.entityId,
          _that.createdAt,
          _that.details,
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
      @JsonKey(name: 'user_id') String userId,
      String action,
      @JsonKey(name: 'entity_type') String entityType,
      @JsonKey(name: 'entity_id') String entityId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      String? details,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityLogDto():
        return $default(
          _that.id,
          _that.budgetId,
          _that.userId,
          _that.action,
          _that.entityType,
          _that.entityId,
          _that.createdAt,
          _that.details,
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
      @JsonKey(name: 'user_id') String userId,
      String action,
      @JsonKey(name: 'entity_type') String entityType,
      @JsonKey(name: 'entity_id') String entityId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      String? details,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityLogDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.userId,
          _that.action,
          _that.entityType,
          _that.entityId,
          _that.createdAt,
          _that.details,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ActivityLogDto implements ActivityLogDto {
  const _ActivityLogDto({
    required this.id,
    @JsonKey(name: 'budget_id') required this.budgetId,
    @JsonKey(name: 'user_id') required this.userId,
    required this.action,
    @JsonKey(name: 'entity_type') required this.entityType,
    @JsonKey(name: 'entity_id') required this.entityId,
    @JsonKey(name: 'created_at') required this.createdAt,
    this.details,
  });
  factory _ActivityLogDto.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogDtoFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'budget_id')
  final String budgetId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String action;
  @override
  @JsonKey(name: 'entity_type')
  final String entityType;
  @override
  @JsonKey(name: 'entity_id')
  final String entityId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  final String? details;

  /// Create a copy of ActivityLogDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ActivityLogDtoCopyWith<_ActivityLogDto> get copyWith =>
      __$ActivityLogDtoCopyWithImpl<_ActivityLogDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActivityLogDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ActivityLogDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.details, details) || other.details == details));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    userId,
    action,
    entityType,
    entityId,
    createdAt,
    details,
  );

  @override
  String toString() {
    return 'ActivityLogDto(id: $id, budgetId: $budgetId, userId: $userId, action: $action, entityType: $entityType, entityId: $entityId, createdAt: $createdAt, details: $details)';
  }
}

/// @nodoc
abstract mixin class _$ActivityLogDtoCopyWith<$Res>
    implements $ActivityLogDtoCopyWith<$Res> {
  factory _$ActivityLogDtoCopyWith(
    _ActivityLogDto value,
    $Res Function(_ActivityLogDto) _then,
  ) = __$ActivityLogDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    @JsonKey(name: 'user_id') String userId,
    String action,
    @JsonKey(name: 'entity_type') String entityType,
    @JsonKey(name: 'entity_id') String entityId,
    @JsonKey(name: 'created_at') DateTime createdAt,
    String? details,
  });
}

/// @nodoc
class __$ActivityLogDtoCopyWithImpl<$Res>
    implements _$ActivityLogDtoCopyWith<$Res> {
  __$ActivityLogDtoCopyWithImpl(this._self, this._then);

  final _ActivityLogDto _self;
  final $Res Function(_ActivityLogDto) _then;

  /// Create a copy of ActivityLogDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? userId = null,
    Object? action = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? createdAt = null,
    Object? details = freezed,
  }) {
    return _then(
      _ActivityLogDto(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        budgetId: null == budgetId
            ? _self.budgetId
            : budgetId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        entityType: null == entityType
            ? _self.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        entityId: null == entityId
            ? _self.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        details: freezed == details
            ? _self.details
            : details // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
