// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_invite.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetInvite {
  String get id;
  String get budgetId;
  String get role;
  String get createdBy;
  DateTime get expiresAt;
  DateTime? get redeemedAt;
  String? get redeemedBy;
  DateTime get createdAt;

  /// Create a copy of BudgetInvite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetInviteCopyWith<BudgetInvite> get copyWith =>
      _$BudgetInviteCopyWithImpl<BudgetInvite>(
        this as BudgetInvite,
        _$identity,
      );

  /// Serializes this BudgetInvite to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetInvite &&
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
    return 'BudgetInvite(id: $id, budgetId: $budgetId, role: $role, createdBy: $createdBy, expiresAt: $expiresAt, redeemedAt: $redeemedAt, redeemedBy: $redeemedBy, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $BudgetInviteCopyWith<$Res> {
  factory $BudgetInviteCopyWith(
    BudgetInvite value,
    $Res Function(BudgetInvite) _then,
  ) = _$BudgetInviteCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String budgetId,
    String role,
    String createdBy,
    DateTime expiresAt,
    DateTime? redeemedAt,
    String? redeemedBy,
    DateTime createdAt,
  });
}

/// @nodoc
class _$BudgetInviteCopyWithImpl<$Res> implements $BudgetInviteCopyWith<$Res> {
  _$BudgetInviteCopyWithImpl(this._self, this._then);

  final BudgetInvite _self;
  final $Res Function(BudgetInvite) _then;

  /// Create a copy of BudgetInvite
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

/// Adds pattern-matching-related methods to [BudgetInvite].
extension BudgetInvitePatterns on BudgetInvite {
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
    TResult Function(_BudgetInvite value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetInvite() when $default != null:
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
    TResult Function(_BudgetInvite value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetInvite():
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
    TResult? Function(_BudgetInvite value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetInvite() when $default != null:
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
      String role,
      String createdBy,
      DateTime expiresAt,
      DateTime? redeemedAt,
      String? redeemedBy,
      DateTime createdAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetInvite() when $default != null:
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
      String budgetId,
      String role,
      String createdBy,
      DateTime expiresAt,
      DateTime? redeemedAt,
      String? redeemedBy,
      DateTime createdAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetInvite():
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
      String budgetId,
      String role,
      String createdBy,
      DateTime expiresAt,
      DateTime? redeemedAt,
      String? redeemedBy,
      DateTime createdAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetInvite() when $default != null:
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
class _BudgetInvite implements BudgetInvite {
  const _BudgetInvite({
    required this.id,
    required this.budgetId,
    required this.role,
    required this.createdBy,
    required this.expiresAt,
    this.redeemedAt,
    this.redeemedBy,
    required this.createdAt,
  });
  factory _BudgetInvite.fromJson(Map<String, dynamic> json) =>
      _$BudgetInviteFromJson(json);

  @override
  final String id;
  @override
  final String budgetId;
  @override
  final String role;
  @override
  final String createdBy;
  @override
  final DateTime expiresAt;
  @override
  final DateTime? redeemedAt;
  @override
  final String? redeemedBy;
  @override
  final DateTime createdAt;

  /// Create a copy of BudgetInvite
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetInviteCopyWith<_BudgetInvite> get copyWith =>
      __$BudgetInviteCopyWithImpl<_BudgetInvite>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BudgetInviteToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BudgetInvite &&
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
    return 'BudgetInvite(id: $id, budgetId: $budgetId, role: $role, createdBy: $createdBy, expiresAt: $expiresAt, redeemedAt: $redeemedAt, redeemedBy: $redeemedBy, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$BudgetInviteCopyWith<$Res>
    implements $BudgetInviteCopyWith<$Res> {
  factory _$BudgetInviteCopyWith(
    _BudgetInvite value,
    $Res Function(_BudgetInvite) _then,
  ) = __$BudgetInviteCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String budgetId,
    String role,
    String createdBy,
    DateTime expiresAt,
    DateTime? redeemedAt,
    String? redeemedBy,
    DateTime createdAt,
  });
}

/// @nodoc
class __$BudgetInviteCopyWithImpl<$Res>
    implements _$BudgetInviteCopyWith<$Res> {
  __$BudgetInviteCopyWithImpl(this._self, this._then);

  final _BudgetInvite _self;
  final $Res Function(_BudgetInvite) _then;

  /// Create a copy of BudgetInvite
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
      _BudgetInvite(
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
