// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_contribution.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GoalContribution {
  String get id;
  String get goalId;
  int get amountCents;
  DateTime get createdAt;
  String? get note;

  /// Create a copy of GoalContribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoalContributionCopyWith<GoalContribution> get copyWith =>
      _$GoalContributionCopyWithImpl<GoalContribution>(
        this as GoalContribution,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoalContribution &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.amountCents, amountCents) ||
                other.amountCents == amountCents) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, goalId, amountCents, createdAt, note);

  @override
  String toString() {
    return 'GoalContribution(id: $id, goalId: $goalId, amountCents: $amountCents, createdAt: $createdAt, note: $note)';
  }
}

/// @nodoc
abstract mixin class $GoalContributionCopyWith<$Res> {
  factory $GoalContributionCopyWith(
    GoalContribution value,
    $Res Function(GoalContribution) _then,
  ) = _$GoalContributionCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String goalId,
    int amountCents,
    DateTime createdAt,
    String? note,
  });
}

/// @nodoc
class _$GoalContributionCopyWithImpl<$Res>
    implements $GoalContributionCopyWith<$Res> {
  _$GoalContributionCopyWithImpl(this._self, this._then);

  final GoalContribution _self;
  final $Res Function(GoalContribution) _then;

  /// Create a copy of GoalContribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? goalId = null,
    Object? amountCents = null,
    Object? createdAt = null,
    Object? note = freezed,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        goalId: null == goalId
            ? _self.goalId
            : goalId // ignore: cast_nullable_to_non_nullable
                  as String,
        amountCents: null == amountCents
            ? _self.amountCents
            : amountCents // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        note: freezed == note
            ? _self.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [GoalContribution].
extension GoalContributionPatterns on GoalContribution {
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
    TResult Function(_GoalContribution value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalContribution() when $default != null:
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
    TResult Function(_GoalContribution value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalContribution():
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
    TResult? Function(_GoalContribution value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalContribution() when $default != null:
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
      String goalId,
      int amountCents,
      DateTime createdAt,
      String? note,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalContribution() when $default != null:
        return $default(
          _that.id,
          _that.goalId,
          _that.amountCents,
          _that.createdAt,
          _that.note,
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
      String goalId,
      int amountCents,
      DateTime createdAt,
      String? note,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalContribution():
        return $default(
          _that.id,
          _that.goalId,
          _that.amountCents,
          _that.createdAt,
          _that.note,
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
      String goalId,
      int amountCents,
      DateTime createdAt,
      String? note,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalContribution() when $default != null:
        return $default(
          _that.id,
          _that.goalId,
          _that.amountCents,
          _that.createdAt,
          _that.note,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GoalContribution implements GoalContribution {
  const _GoalContribution({
    required this.id,
    required this.goalId,
    required this.amountCents,
    required this.createdAt,
    this.note,
  });

  @override
  final String id;
  @override
  final String goalId;
  @override
  final int amountCents;
  @override
  final DateTime createdAt;
  @override
  final String? note;

  /// Create a copy of GoalContribution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GoalContributionCopyWith<_GoalContribution> get copyWith =>
      __$GoalContributionCopyWithImpl<_GoalContribution>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GoalContribution &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.amountCents, amountCents) ||
                other.amountCents == amountCents) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, goalId, amountCents, createdAt, note);

  @override
  String toString() {
    return 'GoalContribution(id: $id, goalId: $goalId, amountCents: $amountCents, createdAt: $createdAt, note: $note)';
  }
}

/// @nodoc
abstract mixin class _$GoalContributionCopyWith<$Res>
    implements $GoalContributionCopyWith<$Res> {
  factory _$GoalContributionCopyWith(
    _GoalContribution value,
    $Res Function(_GoalContribution) _then,
  ) = __$GoalContributionCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String goalId,
    int amountCents,
    DateTime createdAt,
    String? note,
  });
}

/// @nodoc
class __$GoalContributionCopyWithImpl<$Res>
    implements _$GoalContributionCopyWith<$Res> {
  __$GoalContributionCopyWithImpl(this._self, this._then);

  final _GoalContribution _self;
  final $Res Function(_GoalContribution) _then;

  /// Create a copy of GoalContribution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? goalId = null,
    Object? amountCents = null,
    Object? createdAt = null,
    Object? note = freezed,
  }) {
    return _then(
      _GoalContribution(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        goalId: null == goalId
            ? _self.goalId
            : goalId // ignore: cast_nullable_to_non_nullable
                  as String,
        amountCents: null == amountCents
            ? _self.amountCents
            : amountCents // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        note: freezed == note
            ? _self.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
