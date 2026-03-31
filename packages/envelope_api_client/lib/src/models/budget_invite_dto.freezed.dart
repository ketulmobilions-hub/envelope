// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_invite_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetInviteDto {
  String get id;
  @JsonKey(name: 'budget_id')
  String get budgetId;
  String get role;
  @JsonKey(name: 'created_by')
  String get createdBy;
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt;
  @JsonKey(name: 'redeemed_at')
  DateTime? get redeemedAt;
  @JsonKey(name: 'redeemed_by')
  String? get redeemedBy;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of BudgetInviteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetInviteDtoCopyWith<BudgetInviteDto> get copyWith =>
      _$BudgetInviteDtoCopyWithImpl<BudgetInviteDto>(
        this as BudgetInviteDto,
        _$identity,
      );

  /// Serializes this BudgetInviteDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetInviteDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.redeemedAt, redeemedAt) ||
                other.redeemedAt == redeemedAt) &&
            (identical(other.redeemedBy, redeemedBy) ||
                other.redeemedBy == redeemedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    role,
    createdBy,
    expiresAt,
    redeemedAt,
    redeemedBy,
    createdAt,
  );

  @override
  String toString() {
    return 'BudgetInviteDto(id: $id, budgetId: $budgetId, role: $role, createdBy: $createdBy, expiresAt: $expiresAt, redeemedAt: $redeemedAt, redeemedBy: $redeemedBy, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $BudgetInviteDtoCopyWith<$Res> {
  factory $BudgetInviteDtoCopyWith(
    BudgetInviteDto value,
    $Res Function(BudgetInviteDto) _then,
  ) = _$BudgetInviteDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    String role,
    @JsonKey(name: 'created_by') String createdBy,
    @JsonKey(name: 'expires_at') DateTime expiresAt,
    @JsonKey(name: 'redeemed_at') DateTime? redeemedAt,
    @JsonKey(name: 'redeemed_by') String? redeemedBy,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$BudgetInviteDtoCopyWithImpl<$Res>
    implements $BudgetInviteDtoCopyWith<$Res> {
  _$BudgetInviteDtoCopyWithImpl(this._self, this._then);

  final BudgetInviteDto _self;
  final $Res Function(BudgetInviteDto) _then;

  /// Create a copy of BudgetInviteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? role = null,
    Object? createdBy = null,
    Object? expiresAt = null,
    Object? redeemedAt = freezed,
    Object? redeemedBy = freezed,
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
        role: null == role
            ? _self.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        createdBy: null == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        expiresAt: null == expiresAt
            ? _self.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        redeemedAt: freezed == redeemedAt
            ? _self.redeemedAt
            : redeemedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        redeemedBy: freezed == redeemedBy
            ? _self.redeemedBy
            : redeemedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [BudgetInviteDto].
extension BudgetInviteDtoPatterns on BudgetInviteDto {
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
    TResult Function(_BudgetInviteDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetInviteDto() when $default != null:
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
    TResult Function(_BudgetInviteDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetInviteDto():
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
    TResult? Function(_BudgetInviteDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetInviteDto() when $default != null:
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
      String role,
      @JsonKey(name: 'created_by') String createdBy,
      @JsonKey(name: 'expires_at') DateTime expiresAt,
      @JsonKey(name: 'redeemed_at') DateTime? redeemedAt,
      @JsonKey(name: 'redeemed_by') String? redeemedBy,
      @JsonKey(name: 'created_at') DateTime createdAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetInviteDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.role,
          _that.createdBy,
          _that.expiresAt,
          _that.redeemedAt,
          _that.redeemedBy,
          _that.createdAt,
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
      String role,
      @JsonKey(name: 'created_by') String createdBy,
      @JsonKey(name: 'expires_at') DateTime expiresAt,
      @JsonKey(name: 'redeemed_at') DateTime? redeemedAt,
      @JsonKey(name: 'redeemed_by') String? redeemedBy,
      @JsonKey(name: 'created_at') DateTime createdAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetInviteDto():
        return $default(
          _that.id,
          _that.budgetId,
          _that.role,
          _that.createdBy,
          _that.expiresAt,
          _that.redeemedAt,
          _that.redeemedBy,
          _that.createdAt,
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
      String role,
      @JsonKey(name: 'created_by') String createdBy,
      @JsonKey(name: 'expires_at') DateTime expiresAt,
      @JsonKey(name: 'redeemed_at') DateTime? redeemedAt,
      @JsonKey(name: 'redeemed_by') String? redeemedBy,
      @JsonKey(name: 'created_at') DateTime createdAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetInviteDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.role,
          _that.createdBy,
          _that.expiresAt,
          _that.redeemedAt,
          _that.redeemedBy,
          _that.createdAt,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BudgetInviteDto implements BudgetInviteDto {
  const _BudgetInviteDto({
    required this.id,
    @JsonKey(name: 'budget_id') required this.budgetId,
    this.role = 'viewer',
    @JsonKey(name: 'created_by') required this.createdBy,
    @JsonKey(name: 'expires_at') required this.expiresAt,
    @JsonKey(name: 'redeemed_at') this.redeemedAt,
    @JsonKey(name: 'redeemed_by') this.redeemedBy,
    @JsonKey(name: 'created_at') required this.createdAt,
  });
  factory _BudgetInviteDto.fromJson(Map<String, dynamic> json) =>
      _$BudgetInviteDtoFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'budget_id')
  final String budgetId;
  @override
  @JsonKey()
  final String role;
  @override
  @JsonKey(name: 'created_by')
  final String createdBy;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;
  @override
  @JsonKey(name: 'redeemed_at')
  final DateTime? redeemedAt;
  @override
  @JsonKey(name: 'redeemed_by')
  final String? redeemedBy;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Create a copy of BudgetInviteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetInviteDtoCopyWith<_BudgetInviteDto> get copyWith =>
      __$BudgetInviteDtoCopyWithImpl<_BudgetInviteDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BudgetInviteDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BudgetInviteDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.redeemedAt, redeemedAt) ||
                other.redeemedAt == redeemedAt) &&
            (identical(other.redeemedBy, redeemedBy) ||
                other.redeemedBy == redeemedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    role,
    createdBy,
    expiresAt,
    redeemedAt,
    redeemedBy,
    createdAt,
  );

  @override
  String toString() {
    return 'BudgetInviteDto(id: $id, budgetId: $budgetId, role: $role, createdBy: $createdBy, expiresAt: $expiresAt, redeemedAt: $redeemedAt, redeemedBy: $redeemedBy, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$BudgetInviteDtoCopyWith<$Res>
    implements $BudgetInviteDtoCopyWith<$Res> {
  factory _$BudgetInviteDtoCopyWith(
    _BudgetInviteDto value,
    $Res Function(_BudgetInviteDto) _then,
  ) = __$BudgetInviteDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    String role,
    @JsonKey(name: 'created_by') String createdBy,
    @JsonKey(name: 'expires_at') DateTime expiresAt,
    @JsonKey(name: 'redeemed_at') DateTime? redeemedAt,
    @JsonKey(name: 'redeemed_by') String? redeemedBy,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$BudgetInviteDtoCopyWithImpl<$Res>
    implements _$BudgetInviteDtoCopyWith<$Res> {
  __$BudgetInviteDtoCopyWithImpl(this._self, this._then);

  final _BudgetInviteDto _self;
  final $Res Function(_BudgetInviteDto) _then;

  /// Create a copy of BudgetInviteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? role = null,
    Object? createdBy = null,
    Object? expiresAt = null,
    Object? redeemedAt = freezed,
    Object? redeemedBy = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _BudgetInviteDto(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        budgetId: null == budgetId
            ? _self.budgetId
            : budgetId // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _self.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        createdBy: null == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        expiresAt: null == expiresAt
            ? _self.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        redeemedAt: freezed == redeemedAt
            ? _self.redeemedAt
            : redeemedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        redeemedBy: freezed == redeemedBy
            ? _self.redeemedBy
            : redeemedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
