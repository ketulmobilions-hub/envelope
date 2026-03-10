// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_member_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetMemberDto {
  String get id;
  @JsonKey(name: 'budget_id')
  String get budgetId;
  @JsonKey(name: 'user_id')
  String get userId;
  @JsonKey(name: 'invited_via')
  String get invitedVia;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  String get role;
  @JsonKey(name: 'accepted_at')
  DateTime? get acceptedAt;

  /// Create a copy of BudgetMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetMemberDtoCopyWith<BudgetMemberDto> get copyWith =>
      _$BudgetMemberDtoCopyWithImpl<BudgetMemberDto>(
        this as BudgetMemberDto,
        _$identity,
      );

  /// Serializes this BudgetMemberDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetMemberDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.invitedVia, invitedVia) ||
                other.invitedVia == invitedVia) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    userId,
    invitedVia,
    createdAt,
    role,
    acceptedAt,
  );

  @override
  String toString() {
    return 'BudgetMemberDto(id: $id, budgetId: $budgetId, userId: $userId, invitedVia: $invitedVia, createdAt: $createdAt, role: $role, acceptedAt: $acceptedAt)';
  }
}

/// @nodoc
abstract mixin class $BudgetMemberDtoCopyWith<$Res> {
  factory $BudgetMemberDtoCopyWith(
    BudgetMemberDto value,
    $Res Function(BudgetMemberDto) _then,
  ) = _$BudgetMemberDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'invited_via') String invitedVia,
    @JsonKey(name: 'created_at') DateTime createdAt,
    String role,
    @JsonKey(name: 'accepted_at') DateTime? acceptedAt,
  });
}

/// @nodoc
class _$BudgetMemberDtoCopyWithImpl<$Res>
    implements $BudgetMemberDtoCopyWith<$Res> {
  _$BudgetMemberDtoCopyWithImpl(this._self, this._then);

  final BudgetMemberDto _self;
  final $Res Function(BudgetMemberDto) _then;

  /// Create a copy of BudgetMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? userId = null,
    Object? invitedVia = null,
    Object? createdAt = null,
    Object? role = null,
    Object? acceptedAt = freezed,
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
        invitedVia: null == invitedVia
            ? _self.invitedVia
            : invitedVia // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        role: null == role
            ? _self.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        acceptedAt: freezed == acceptedAt
            ? _self.acceptedAt
            : acceptedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [BudgetMemberDto].
extension BudgetMemberDtoPatterns on BudgetMemberDto {
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
    TResult Function(_BudgetMemberDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetMemberDto() when $default != null:
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
    TResult Function(_BudgetMemberDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetMemberDto():
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
    TResult? Function(_BudgetMemberDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetMemberDto() when $default != null:
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
      @JsonKey(name: 'invited_via') String invitedVia,
      @JsonKey(name: 'created_at') DateTime createdAt,
      String role,
      @JsonKey(name: 'accepted_at') DateTime? acceptedAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetMemberDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.userId,
          _that.invitedVia,
          _that.createdAt,
          _that.role,
          _that.acceptedAt,
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
      @JsonKey(name: 'invited_via') String invitedVia,
      @JsonKey(name: 'created_at') DateTime createdAt,
      String role,
      @JsonKey(name: 'accepted_at') DateTime? acceptedAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetMemberDto():
        return $default(
          _that.id,
          _that.budgetId,
          _that.userId,
          _that.invitedVia,
          _that.createdAt,
          _that.role,
          _that.acceptedAt,
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
      @JsonKey(name: 'invited_via') String invitedVia,
      @JsonKey(name: 'created_at') DateTime createdAt,
      String role,
      @JsonKey(name: 'accepted_at') DateTime? acceptedAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetMemberDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.userId,
          _that.invitedVia,
          _that.createdAt,
          _that.role,
          _that.acceptedAt,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BudgetMemberDto implements BudgetMemberDto {
  const _BudgetMemberDto({
    required this.id,
    @JsonKey(name: 'budget_id') required this.budgetId,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'invited_via') required this.invitedVia,
    @JsonKey(name: 'created_at') required this.createdAt,
    this.role = 'viewer',
    @JsonKey(name: 'accepted_at') this.acceptedAt,
  });
  factory _BudgetMemberDto.fromJson(Map<String, dynamic> json) =>
      _$BudgetMemberDtoFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'budget_id')
  final String budgetId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'invited_via')
  final String invitedVia;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey()
  final String role;
  @override
  @JsonKey(name: 'accepted_at')
  final DateTime? acceptedAt;

  /// Create a copy of BudgetMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetMemberDtoCopyWith<_BudgetMemberDto> get copyWith =>
      __$BudgetMemberDtoCopyWithImpl<_BudgetMemberDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BudgetMemberDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BudgetMemberDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.invitedVia, invitedVia) ||
                other.invitedVia == invitedVia) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    userId,
    invitedVia,
    createdAt,
    role,
    acceptedAt,
  );

  @override
  String toString() {
    return 'BudgetMemberDto(id: $id, budgetId: $budgetId, userId: $userId, invitedVia: $invitedVia, createdAt: $createdAt, role: $role, acceptedAt: $acceptedAt)';
  }
}

/// @nodoc
abstract mixin class _$BudgetMemberDtoCopyWith<$Res>
    implements $BudgetMemberDtoCopyWith<$Res> {
  factory _$BudgetMemberDtoCopyWith(
    _BudgetMemberDto value,
    $Res Function(_BudgetMemberDto) _then,
  ) = __$BudgetMemberDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'invited_via') String invitedVia,
    @JsonKey(name: 'created_at') DateTime createdAt,
    String role,
    @JsonKey(name: 'accepted_at') DateTime? acceptedAt,
  });
}

/// @nodoc
class __$BudgetMemberDtoCopyWithImpl<$Res>
    implements _$BudgetMemberDtoCopyWith<$Res> {
  __$BudgetMemberDtoCopyWithImpl(this._self, this._then);

  final _BudgetMemberDto _self;
  final $Res Function(_BudgetMemberDto) _then;

  /// Create a copy of BudgetMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? userId = null,
    Object? invitedVia = null,
    Object? createdAt = null,
    Object? role = null,
    Object? acceptedAt = freezed,
  }) {
    return _then(
      _BudgetMemberDto(
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
        invitedVia: null == invitedVia
            ? _self.invitedVia
            : invitedVia // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        role: null == role
            ? _self.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        acceptedAt: freezed == acceptedAt
            ? _self.acceptedAt
            : acceptedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
