// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Subscription {
  String get userId;
  DateTime get createdAt;
  SubscriptionTier get tier;
  DateTime? get expiresAt;
  bool get isActive;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubscriptionCopyWith<Subscription> get copyWith =>
      _$SubscriptionCopyWithImpl<Subscription>(
        this as Subscription,
        _$identity,
      );

  /// Serializes this Subscription to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Subscription &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, createdAt, tier, expiresAt, isActive);

  @override
  String toString() {
    return 'Subscription(userId: $userId, createdAt: $createdAt, tier: $tier, expiresAt: $expiresAt, isActive: $isActive)';
  }
}

/// @nodoc
abstract mixin class $SubscriptionCopyWith<$Res> {
  factory $SubscriptionCopyWith(
    Subscription value,
    $Res Function(Subscription) _then,
  ) = _$SubscriptionCopyWithImpl;
  @useResult
  $Res call({
    String userId,
    DateTime createdAt,
    SubscriptionTier tier,
    DateTime? expiresAt,
    bool isActive,
  });
}

/// @nodoc
class _$SubscriptionCopyWithImpl<$Res> implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._self, this._then);

  final Subscription _self;
  final $Res Function(Subscription) _then;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? createdAt = null,
    Object? tier = null,
    Object? expiresAt = freezed,
    Object? isActive = null,
  }) {
    return _then(
      _self.copyWith(
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        tier: null == tier
            ? _self.tier
            : tier // ignore: cast_nullable_to_non_nullable
                  as SubscriptionTier,
        expiresAt: freezed == expiresAt
            ? _self.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isActive: null == isActive
            ? _self.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [Subscription].
extension SubscriptionPatterns on Subscription {
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
    TResult Function(_Subscription value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Subscription() when $default != null:
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
    TResult Function(_Subscription value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Subscription():
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
    TResult? Function(_Subscription value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Subscription() when $default != null:
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
      String userId,
      DateTime createdAt,
      SubscriptionTier tier,
      DateTime? expiresAt,
      bool isActive,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Subscription() when $default != null:
        return $default(
          _that.userId,
          _that.createdAt,
          _that.tier,
          _that.expiresAt,
          _that.isActive,
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
      String userId,
      DateTime createdAt,
      SubscriptionTier tier,
      DateTime? expiresAt,
      bool isActive,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Subscription():
        return $default(
          _that.userId,
          _that.createdAt,
          _that.tier,
          _that.expiresAt,
          _that.isActive,
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
      String userId,
      DateTime createdAt,
      SubscriptionTier tier,
      DateTime? expiresAt,
      bool isActive,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Subscription() when $default != null:
        return $default(
          _that.userId,
          _that.createdAt,
          _that.tier,
          _that.expiresAt,
          _that.isActive,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Subscription implements Subscription {
  const _Subscription({
    required this.userId,
    required this.createdAt,
    this.tier = SubscriptionTier.free,
    this.expiresAt,
    this.isActive = false,
  });
  factory _Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  @override
  final String userId;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final SubscriptionTier tier;
  @override
  final DateTime? expiresAt;
  @override
  @JsonKey()
  final bool isActive;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SubscriptionCopyWith<_Subscription> get copyWith =>
      __$SubscriptionCopyWithImpl<_Subscription>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SubscriptionToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Subscription &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, createdAt, tier, expiresAt, isActive);

  @override
  String toString() {
    return 'Subscription(userId: $userId, createdAt: $createdAt, tier: $tier, expiresAt: $expiresAt, isActive: $isActive)';
  }
}

/// @nodoc
abstract mixin class _$SubscriptionCopyWith<$Res>
    implements $SubscriptionCopyWith<$Res> {
  factory _$SubscriptionCopyWith(
    _Subscription value,
    $Res Function(_Subscription) _then,
  ) = __$SubscriptionCopyWithImpl;
  @override
  @useResult
  $Res call({
    String userId,
    DateTime createdAt,
    SubscriptionTier tier,
    DateTime? expiresAt,
    bool isActive,
  });
}

/// @nodoc
class __$SubscriptionCopyWithImpl<$Res>
    implements _$SubscriptionCopyWith<$Res> {
  __$SubscriptionCopyWithImpl(this._self, this._then);

  final _Subscription _self;
  final $Res Function(_Subscription) _then;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? createdAt = null,
    Object? tier = null,
    Object? expiresAt = freezed,
    Object? isActive = null,
  }) {
    return _then(
      _Subscription(
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        tier: null == tier
            ? _self.tier
            : tier // ignore: cast_nullable_to_non_nullable
                  as SubscriptionTier,
        expiresAt: freezed == expiresAt
            ? _self.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isActive: null == isActive
            ? _self.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
