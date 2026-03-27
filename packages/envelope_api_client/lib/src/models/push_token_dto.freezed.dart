// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_token_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushTokenDto {
  @JsonKey(name: 'user_id')
  String get userId;
  String get token;
  String get platform;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @JsonKey(includeIfNull: false)
  String? get id;

  /// Create a copy of PushTokenDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PushTokenDtoCopyWith<PushTokenDto> get copyWith =>
      _$PushTokenDtoCopyWithImpl<PushTokenDto>(
        this as PushTokenDto,
        _$identity,
      );

  /// Serializes this PushTokenDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PushTokenDto &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    token,
    platform,
    createdAt,
    updatedAt,
    id,
  );

  @override
  String toString() {
    return 'PushTokenDto(userId: $userId, token: $token, platform: $platform, createdAt: $createdAt, updatedAt: $updatedAt, id: $id)';
  }
}

/// @nodoc
abstract mixin class $PushTokenDtoCopyWith<$Res> {
  factory $PushTokenDtoCopyWith(
    PushTokenDto value,
    $Res Function(PushTokenDto) _then,
  ) = _$PushTokenDtoCopyWithImpl;
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    String token,
    String platform,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(includeIfNull: false) String? id,
  });
}

/// @nodoc
class _$PushTokenDtoCopyWithImpl<$Res> implements $PushTokenDtoCopyWith<$Res> {
  _$PushTokenDtoCopyWithImpl(this._self, this._then);

  final PushTokenDto _self;
  final $Res Function(PushTokenDto) _then;

  /// Create a copy of PushTokenDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? token = null,
    Object? platform = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? id = freezed,
  }) {
    return _then(
      _self.copyWith(
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        token: null == token
            ? _self.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        platform: null == platform
            ? _self.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        id: freezed == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [PushTokenDto].
extension PushTokenDtoPatterns on PushTokenDto {
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
    TResult Function(_PushTokenDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PushTokenDto() when $default != null:
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
    TResult Function(_PushTokenDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PushTokenDto():
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
    TResult? Function(_PushTokenDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PushTokenDto() when $default != null:
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
      @JsonKey(name: 'user_id') String userId,
      String token,
      String platform,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(includeIfNull: false) String? id,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PushTokenDto() when $default != null:
        return $default(
          _that.userId,
          _that.token,
          _that.platform,
          _that.createdAt,
          _that.updatedAt,
          _that.id,
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
      @JsonKey(name: 'user_id') String userId,
      String token,
      String platform,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(includeIfNull: false) String? id,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PushTokenDto():
        return $default(
          _that.userId,
          _that.token,
          _that.platform,
          _that.createdAt,
          _that.updatedAt,
          _that.id,
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
      @JsonKey(name: 'user_id') String userId,
      String token,
      String platform,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(includeIfNull: false) String? id,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PushTokenDto() when $default != null:
        return $default(
          _that.userId,
          _that.token,
          _that.platform,
          _that.createdAt,
          _that.updatedAt,
          _that.id,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PushTokenDto implements PushTokenDto {
  const _PushTokenDto({
    @JsonKey(name: 'user_id') required this.userId,
    required this.token,
    required this.platform,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(includeIfNull: false) this.id,
  });
  factory _PushTokenDto.fromJson(Map<String, dynamic> json) =>
      _$PushTokenDtoFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String token;
  @override
  final String platform;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(includeIfNull: false)
  final String? id;

  /// Create a copy of PushTokenDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PushTokenDtoCopyWith<_PushTokenDto> get copyWith =>
      __$PushTokenDtoCopyWithImpl<_PushTokenDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PushTokenDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PushTokenDto &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    token,
    platform,
    createdAt,
    updatedAt,
    id,
  );

  @override
  String toString() {
    return 'PushTokenDto(userId: $userId, token: $token, platform: $platform, createdAt: $createdAt, updatedAt: $updatedAt, id: $id)';
  }
}

/// @nodoc
abstract mixin class _$PushTokenDtoCopyWith<$Res>
    implements $PushTokenDtoCopyWith<$Res> {
  factory _$PushTokenDtoCopyWith(
    _PushTokenDto value,
    $Res Function(_PushTokenDto) _then,
  ) = __$PushTokenDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    String token,
    String platform,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(includeIfNull: false) String? id,
  });
}

/// @nodoc
class __$PushTokenDtoCopyWithImpl<$Res>
    implements _$PushTokenDtoCopyWith<$Res> {
  __$PushTokenDtoCopyWithImpl(this._self, this._then);

  final _PushTokenDto _self;
  final $Res Function(_PushTokenDto) _then;

  /// Create a copy of PushTokenDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? token = null,
    Object? platform = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? id = freezed,
  }) {
    return _then(
      _PushTokenDto(
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        token: null == token
            ? _self.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        platform: null == platform
            ? _self.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        id: freezed == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
