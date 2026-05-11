// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Goal {
  String get id;
  String get budgetId;
  String get type;
  String get name;
  DateTime get createdAt;
  DateTime get updatedAt;
  String? get envelopeId;
  String? get accountId;
  int? get targetAmount;
  DateTime? get targetDate;
  int? get monthlyContribution;
  int get currentAmount;
  bool get isCompleted;

  /// Annual percentage rate in basis points (e.g. 1799 = 17.99%).
  /// Only meaningful for `debt_payoff` goals; null for other types.
  int? get aprBps;

  /// Lender-required minimum monthly payment in cents.
  /// Only meaningful for `debt_payoff` goals; null for other types.
  int? get minPaymentCents;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoalCopyWith<Goal> get copyWith =>
      _$GoalCopyWithImpl<Goal>(this as Goal, _$identity);

  /// Serializes this Goal to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Goal &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.monthlyContribution, monthlyContribution) ||
                other.monthlyContribution == monthlyContribution) &&
            (identical(other.currentAmount, currentAmount) ||
                other.currentAmount == currentAmount) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.aprBps, aprBps) || other.aprBps == aprBps) &&
            (identical(other.minPaymentCents, minPaymentCents) ||
                other.minPaymentCents == minPaymentCents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    type,
    name,
    createdAt,
    updatedAt,
    envelopeId,
    accountId,
    targetAmount,
    targetDate,
    monthlyContribution,
    currentAmount,
    isCompleted,
    aprBps,
    minPaymentCents,
  );

  @override
  String toString() {
    return 'Goal(id: $id, budgetId: $budgetId, type: $type, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, envelopeId: $envelopeId, accountId: $accountId, targetAmount: $targetAmount, targetDate: $targetDate, monthlyContribution: $monthlyContribution, currentAmount: $currentAmount, isCompleted: $isCompleted, aprBps: $aprBps, minPaymentCents: $minPaymentCents)';
  }
}

/// @nodoc
abstract mixin class $GoalCopyWith<$Res> {
  factory $GoalCopyWith(Goal value, $Res Function(Goal) _then) =
      _$GoalCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String budgetId,
    String type,
    String name,
    DateTime createdAt,
    DateTime updatedAt,
    String? envelopeId,
    String? accountId,
    int? targetAmount,
    DateTime? targetDate,
    int? monthlyContribution,
    int currentAmount,
    bool isCompleted,
    int? aprBps,
    int? minPaymentCents,
  });
}

/// @nodoc
class _$GoalCopyWithImpl<$Res> implements $GoalCopyWith<$Res> {
  _$GoalCopyWithImpl(this._self, this._then);

  final Goal _self;
  final $Res Function(Goal) _then;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? type = null,
    Object? name = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? envelopeId = freezed,
    Object? accountId = freezed,
    Object? targetAmount = freezed,
    Object? targetDate = freezed,
    Object? monthlyContribution = freezed,
    Object? currentAmount = null,
    Object? isCompleted = null,
    Object? aprBps = freezed,
    Object? minPaymentCents = freezed,
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
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        envelopeId: freezed == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        accountId: freezed == accountId
            ? _self.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String?,
        targetAmount: freezed == targetAmount
            ? _self.targetAmount
            : targetAmount // ignore: cast_nullable_to_non_nullable
                  as int?,
        targetDate: freezed == targetDate
            ? _self.targetDate
            : targetDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        monthlyContribution: freezed == monthlyContribution
            ? _self.monthlyContribution
            : monthlyContribution // ignore: cast_nullable_to_non_nullable
                  as int?,
        currentAmount: null == currentAmount
            ? _self.currentAmount
            : currentAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        isCompleted: null == isCompleted
            ? _self.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        aprBps: freezed == aprBps
            ? _self.aprBps
            : aprBps // ignore: cast_nullable_to_non_nullable
                  as int?,
        minPaymentCents: freezed == minPaymentCents
            ? _self.minPaymentCents
            : minPaymentCents // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [Goal].
extension GoalPatterns on Goal {
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
    TResult Function(_Goal value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Goal() when $default != null:
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
  TResult map<TResult extends Object?>(TResult Function(_Goal value) $default) {
    final _that = this;
    switch (_that) {
      case _Goal():
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
    TResult? Function(_Goal value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Goal() when $default != null:
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
      String type,
      String name,
      DateTime createdAt,
      DateTime updatedAt,
      String? envelopeId,
      String? accountId,
      int? targetAmount,
      DateTime? targetDate,
      int? monthlyContribution,
      int currentAmount,
      bool isCompleted,
      int? aprBps,
      int? minPaymentCents,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Goal() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.type,
          _that.name,
          _that.createdAt,
          _that.updatedAt,
          _that.envelopeId,
          _that.accountId,
          _that.targetAmount,
          _that.targetDate,
          _that.monthlyContribution,
          _that.currentAmount,
          _that.isCompleted,
          _that.aprBps,
          _that.minPaymentCents,
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
      String type,
      String name,
      DateTime createdAt,
      DateTime updatedAt,
      String? envelopeId,
      String? accountId,
      int? targetAmount,
      DateTime? targetDate,
      int? monthlyContribution,
      int currentAmount,
      bool isCompleted,
      int? aprBps,
      int? minPaymentCents,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Goal():
        return $default(
          _that.id,
          _that.budgetId,
          _that.type,
          _that.name,
          _that.createdAt,
          _that.updatedAt,
          _that.envelopeId,
          _that.accountId,
          _that.targetAmount,
          _that.targetDate,
          _that.monthlyContribution,
          _that.currentAmount,
          _that.isCompleted,
          _that.aprBps,
          _that.minPaymentCents,
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
      String type,
      String name,
      DateTime createdAt,
      DateTime updatedAt,
      String? envelopeId,
      String? accountId,
      int? targetAmount,
      DateTime? targetDate,
      int? monthlyContribution,
      int currentAmount,
      bool isCompleted,
      int? aprBps,
      int? minPaymentCents,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Goal() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.type,
          _that.name,
          _that.createdAt,
          _that.updatedAt,
          _that.envelopeId,
          _that.accountId,
          _that.targetAmount,
          _that.targetDate,
          _that.monthlyContribution,
          _that.currentAmount,
          _that.isCompleted,
          _that.aprBps,
          _that.minPaymentCents,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Goal implements Goal {
  const _Goal({
    required this.id,
    required this.budgetId,
    required this.type,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.envelopeId,
    this.accountId,
    this.targetAmount,
    this.targetDate,
    this.monthlyContribution,
    this.currentAmount = 0,
    this.isCompleted = false,
    this.aprBps,
    this.minPaymentCents,
  });
  factory _Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

  @override
  final String id;
  @override
  final String budgetId;
  @override
  final String type;
  @override
  final String name;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? envelopeId;
  @override
  final String? accountId;
  @override
  final int? targetAmount;
  @override
  final DateTime? targetDate;
  @override
  final int? monthlyContribution;
  @override
  @JsonKey()
  final int currentAmount;
  @override
  @JsonKey()
  final bool isCompleted;

  /// Annual percentage rate in basis points (e.g. 1799 = 17.99%).
  /// Only meaningful for `debt_payoff` goals; null for other types.
  @override
  final int? aprBps;

  /// Lender-required minimum monthly payment in cents.
  /// Only meaningful for `debt_payoff` goals; null for other types.
  @override
  final int? minPaymentCents;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GoalCopyWith<_Goal> get copyWith =>
      __$GoalCopyWithImpl<_Goal>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GoalToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Goal &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.monthlyContribution, monthlyContribution) ||
                other.monthlyContribution == monthlyContribution) &&
            (identical(other.currentAmount, currentAmount) ||
                other.currentAmount == currentAmount) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.aprBps, aprBps) || other.aprBps == aprBps) &&
            (identical(other.minPaymentCents, minPaymentCents) ||
                other.minPaymentCents == minPaymentCents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    type,
    name,
    createdAt,
    updatedAt,
    envelopeId,
    accountId,
    targetAmount,
    targetDate,
    monthlyContribution,
    currentAmount,
    isCompleted,
    aprBps,
    minPaymentCents,
  );

  @override
  String toString() {
    return 'Goal(id: $id, budgetId: $budgetId, type: $type, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, envelopeId: $envelopeId, accountId: $accountId, targetAmount: $targetAmount, targetDate: $targetDate, monthlyContribution: $monthlyContribution, currentAmount: $currentAmount, isCompleted: $isCompleted, aprBps: $aprBps, minPaymentCents: $minPaymentCents)';
  }
}

/// @nodoc
abstract mixin class _$GoalCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory _$GoalCopyWith(_Goal value, $Res Function(_Goal) _then) =
      __$GoalCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String budgetId,
    String type,
    String name,
    DateTime createdAt,
    DateTime updatedAt,
    String? envelopeId,
    String? accountId,
    int? targetAmount,
    DateTime? targetDate,
    int? monthlyContribution,
    int currentAmount,
    bool isCompleted,
    int? aprBps,
    int? minPaymentCents,
  });
}

/// @nodoc
class __$GoalCopyWithImpl<$Res> implements _$GoalCopyWith<$Res> {
  __$GoalCopyWithImpl(this._self, this._then);

  final _Goal _self;
  final $Res Function(_Goal) _then;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? type = null,
    Object? name = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? envelopeId = freezed,
    Object? accountId = freezed,
    Object? targetAmount = freezed,
    Object? targetDate = freezed,
    Object? monthlyContribution = freezed,
    Object? currentAmount = null,
    Object? isCompleted = null,
    Object? aprBps = freezed,
    Object? minPaymentCents = freezed,
  }) {
    return _then(
      _Goal(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        budgetId: null == budgetId
            ? _self.budgetId
            : budgetId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        envelopeId: freezed == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        accountId: freezed == accountId
            ? _self.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String?,
        targetAmount: freezed == targetAmount
            ? _self.targetAmount
            : targetAmount // ignore: cast_nullable_to_non_nullable
                  as int?,
        targetDate: freezed == targetDate
            ? _self.targetDate
            : targetDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        monthlyContribution: freezed == monthlyContribution
            ? _self.monthlyContribution
            : monthlyContribution // ignore: cast_nullable_to_non_nullable
                  as int?,
        currentAmount: null == currentAmount
            ? _self.currentAmount
            : currentAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        isCompleted: null == isCompleted
            ? _self.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        aprBps: freezed == aprBps
            ? _self.aprBps
            : aprBps // ignore: cast_nullable_to_non_nullable
                  as int?,
        minPaymentCents: freezed == minPaymentCents
            ? _self.minPaymentCents
            : minPaymentCents // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
