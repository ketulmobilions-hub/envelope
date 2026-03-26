// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetMember {
  String get id;
  String get budgetId;
  String? get userId;
  String get invitedVia;
  DateTime get createdAt;
  String get role;
  DateTime? get acceptedAt;

  /// Create a copy of BudgetMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetMemberCopyWith<BudgetMember> get copyWith =>
      _$BudgetMemberCopyWithImpl<BudgetMember>(
        this as BudgetMember,
        _$identity,
      );

  /// Serializes this BudgetMember to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetMember &&
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
    return 'BudgetMember(id: $id, budgetId: $budgetId, userId: $userId, invitedVia: $invitedVia, createdAt: $createdAt, role: $role, acceptedAt: $acceptedAt)';
  }
}

/// @nodoc
abstract mixin class $BudgetMemberCopyWith<$Res> {
  factory $BudgetMemberCopyWith(
    BudgetMember value,
    $Res Function(BudgetMember) _then,
  ) = _$BudgetMemberCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String budgetId,
    String? userId,
    String invitedVia,
    DateTime createdAt,
    String role,
    DateTime? acceptedAt,
  });
}

/// @nodoc
class _$BudgetMemberCopyWithImpl<$Res> implements $BudgetMemberCopyWith<$Res> {
  _$BudgetMemberCopyWithImpl(this._self, this._then);

  final BudgetMember _self;
  final $Res Function(BudgetMember) _then;

  /// Create a copy of BudgetMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? userId = freezed,
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
        userId: freezed == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
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

/// Adds pattern-matching-related methods to [BudgetMember].
extension BudgetMemberPatterns on BudgetMember {
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
    TResult Function(_BudgetMember value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetMember() when $default != null:
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
    TResult Function(_BudgetMember value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetMember():
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
    TResult? Function(_BudgetMember value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetMember() when $default != null:
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
      String? userId,
      String invitedVia,
      DateTime createdAt,
      String role,
      DateTime? acceptedAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetMember() when $default != null:
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
      String budgetId,
      String? userId,
      String invitedVia,
      DateTime createdAt,
      String role,
      DateTime? acceptedAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetMember():
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
      String budgetId,
      String? userId,
      String invitedVia,
      DateTime createdAt,
      String role,
      DateTime? acceptedAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetMember() when $default != null:
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
class _BudgetMember implements BudgetMember {
  const _BudgetMember({
    required this.id,
    required this.budgetId,
    this.userId,
    required this.invitedVia,
    required this.createdAt,
    this.role = 'viewer',
    this.acceptedAt,
  });
  factory _BudgetMember.fromJson(Map<String, dynamic> json) =>
      _$BudgetMemberFromJson(json);

  @override
  final String id;
  @override
  final String budgetId;
  @override
  final String? userId;
  @override
  final String invitedVia;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final String role;
  @override
  final DateTime? acceptedAt;

  /// Create a copy of BudgetMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetMemberCopyWith<_BudgetMember> get copyWith =>
      __$BudgetMemberCopyWithImpl<_BudgetMember>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BudgetMemberToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BudgetMember &&
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
    return 'BudgetMember(id: $id, budgetId: $budgetId, userId: $userId, invitedVia: $invitedVia, createdAt: $createdAt, role: $role, acceptedAt: $acceptedAt)';
  }
}

/// @nodoc
abstract mixin class _$BudgetMemberCopyWith<$Res>
    implements $BudgetMemberCopyWith<$Res> {
  factory _$BudgetMemberCopyWith(
    _BudgetMember value,
    $Res Function(_BudgetMember) _then,
  ) = __$BudgetMemberCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String budgetId,
    String? userId,
    String invitedVia,
    DateTime createdAt,
    String role,
    DateTime? acceptedAt,
  });
}

/// @nodoc
class __$BudgetMemberCopyWithImpl<$Res>
    implements _$BudgetMemberCopyWith<$Res> {
  __$BudgetMemberCopyWithImpl(this._self, this._then);

  final _BudgetMember _self;
  final $Res Function(_BudgetMember) _then;

  /// Create a copy of BudgetMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? userId = freezed,
    Object? invitedVia = null,
    Object? createdAt = null,
    Object? role = null,
    Object? acceptedAt = freezed,
  }) {
    return _then(
      _BudgetMember(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        budgetId: null == budgetId
            ? _self.budgetId
            : budgetId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: freezed == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
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
