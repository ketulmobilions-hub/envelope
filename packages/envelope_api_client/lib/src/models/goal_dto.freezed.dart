// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GoalDto {
  String get id;
  @JsonKey(name: 'budget_id')
  String get budgetId;
  String get type;
  String get name;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @JsonKey(name: 'current_amount')
  int get currentAmount;
  @JsonKey(name: 'is_completed')
  bool get isCompleted;
  @JsonKey(name: 'envelope_id')
  String? get envelopeId;
  @JsonKey(name: 'account_id')
  String? get accountId;
  @JsonKey(name: 'target_amount')
  int? get targetAmount;
  @JsonKey(name: 'target_date')
  DateTime? get targetDate;
  @JsonKey(name: 'monthly_contribution')
  int? get monthlyContribution;

  /// Create a copy of GoalDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoalDtoCopyWith<GoalDto> get copyWith =>
      _$GoalDtoCopyWithImpl<GoalDto>(this as GoalDto, _$identity);

  /// Serializes this GoalDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoalDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.currentAmount, currentAmount) ||
                other.currentAmount == currentAmount) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.monthlyContribution, monthlyContribution) ||
                other.monthlyContribution == monthlyContribution));
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
    currentAmount,
    isCompleted,
    envelopeId,
    accountId,
    targetAmount,
    targetDate,
    monthlyContribution,
  );

  @override
  String toString() {
    return 'GoalDto(id: $id, budgetId: $budgetId, type: $type, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, currentAmount: $currentAmount, isCompleted: $isCompleted, envelopeId: $envelopeId, accountId: $accountId, targetAmount: $targetAmount, targetDate: $targetDate, monthlyContribution: $monthlyContribution)';
  }
}

/// @nodoc
abstract mixin class $GoalDtoCopyWith<$Res> {
  factory $GoalDtoCopyWith(GoalDto value, $Res Function(GoalDto) _then) =
      _$GoalDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    String type,
    String name,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'current_amount') int currentAmount,
    @JsonKey(name: 'is_completed') bool isCompleted,
    @JsonKey(name: 'envelope_id') String? envelopeId,
    @JsonKey(name: 'account_id') String? accountId,
    @JsonKey(name: 'target_amount') int? targetAmount,
    @JsonKey(name: 'target_date') DateTime? targetDate,
    @JsonKey(name: 'monthly_contribution') int? monthlyContribution,
  });
}

/// @nodoc
class _$GoalDtoCopyWithImpl<$Res> implements $GoalDtoCopyWith<$Res> {
  _$GoalDtoCopyWithImpl(this._self, this._then);

  final GoalDto _self;
  final $Res Function(GoalDto) _then;

  /// Create a copy of GoalDto
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
    Object? currentAmount = null,
    Object? isCompleted = null,
    Object? envelopeId = freezed,
    Object? accountId = freezed,
    Object? targetAmount = freezed,
    Object? targetDate = freezed,
    Object? monthlyContribution = freezed,
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
        currentAmount: null == currentAmount
            ? _self.currentAmount
            : currentAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        isCompleted: null == isCompleted
            ? _self.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
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
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [GoalDto].
extension GoalDtoPatterns on GoalDto {
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
    TResult Function(_GoalDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalDto() when $default != null:
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
    TResult Function(_GoalDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalDto():
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
    TResult? Function(_GoalDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalDto() when $default != null:
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
      String type,
      String name,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'current_amount') int currentAmount,
      @JsonKey(name: 'is_completed') bool isCompleted,
      @JsonKey(name: 'envelope_id') String? envelopeId,
      @JsonKey(name: 'account_id') String? accountId,
      @JsonKey(name: 'target_amount') int? targetAmount,
      @JsonKey(name: 'target_date') DateTime? targetDate,
      @JsonKey(name: 'monthly_contribution') int? monthlyContribution,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.type,
          _that.name,
          _that.createdAt,
          _that.updatedAt,
          _that.currentAmount,
          _that.isCompleted,
          _that.envelopeId,
          _that.accountId,
          _that.targetAmount,
          _that.targetDate,
          _that.monthlyContribution,
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
      String type,
      String name,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'current_amount') int currentAmount,
      @JsonKey(name: 'is_completed') bool isCompleted,
      @JsonKey(name: 'envelope_id') String? envelopeId,
      @JsonKey(name: 'account_id') String? accountId,
      @JsonKey(name: 'target_amount') int? targetAmount,
      @JsonKey(name: 'target_date') DateTime? targetDate,
      @JsonKey(name: 'monthly_contribution') int? monthlyContribution,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalDto():
        return $default(
          _that.id,
          _that.budgetId,
          _that.type,
          _that.name,
          _that.createdAt,
          _that.updatedAt,
          _that.currentAmount,
          _that.isCompleted,
          _that.envelopeId,
          _that.accountId,
          _that.targetAmount,
          _that.targetDate,
          _that.monthlyContribution,
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
      String type,
      String name,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'current_amount') int currentAmount,
      @JsonKey(name: 'is_completed') bool isCompleted,
      @JsonKey(name: 'envelope_id') String? envelopeId,
      @JsonKey(name: 'account_id') String? accountId,
      @JsonKey(name: 'target_amount') int? targetAmount,
      @JsonKey(name: 'target_date') DateTime? targetDate,
      @JsonKey(name: 'monthly_contribution') int? monthlyContribution,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.type,
          _that.name,
          _that.createdAt,
          _that.updatedAt,
          _that.currentAmount,
          _that.isCompleted,
          _that.envelopeId,
          _that.accountId,
          _that.targetAmount,
          _that.targetDate,
          _that.monthlyContribution,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GoalDto implements GoalDto {
  const _GoalDto({
    required this.id,
    @JsonKey(name: 'budget_id') required this.budgetId,
    required this.type,
    required this.name,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(name: 'current_amount') this.currentAmount = 0,
    @JsonKey(name: 'is_completed') this.isCompleted = false,
    @JsonKey(name: 'envelope_id') this.envelopeId,
    @JsonKey(name: 'account_id') this.accountId,
    @JsonKey(name: 'target_amount') this.targetAmount,
    @JsonKey(name: 'target_date') this.targetDate,
    @JsonKey(name: 'monthly_contribution') this.monthlyContribution,
  });
  factory _GoalDto.fromJson(Map<String, dynamic> json) =>
      _$GoalDtoFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'budget_id')
  final String budgetId;
  @override
  final String type;
  @override
  final String name;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'current_amount')
  final int currentAmount;
  @override
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @override
  @JsonKey(name: 'envelope_id')
  final String? envelopeId;
  @override
  @JsonKey(name: 'account_id')
  final String? accountId;
  @override
  @JsonKey(name: 'target_amount')
  final int? targetAmount;
  @override
  @JsonKey(name: 'target_date')
  final DateTime? targetDate;
  @override
  @JsonKey(name: 'monthly_contribution')
  final int? monthlyContribution;

  /// Create a copy of GoalDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GoalDtoCopyWith<_GoalDto> get copyWith =>
      __$GoalDtoCopyWithImpl<_GoalDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GoalDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GoalDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.currentAmount, currentAmount) ||
                other.currentAmount == currentAmount) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.monthlyContribution, monthlyContribution) ||
                other.monthlyContribution == monthlyContribution));
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
    currentAmount,
    isCompleted,
    envelopeId,
    accountId,
    targetAmount,
    targetDate,
    monthlyContribution,
  );

  @override
  String toString() {
    return 'GoalDto(id: $id, budgetId: $budgetId, type: $type, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, currentAmount: $currentAmount, isCompleted: $isCompleted, envelopeId: $envelopeId, accountId: $accountId, targetAmount: $targetAmount, targetDate: $targetDate, monthlyContribution: $monthlyContribution)';
  }
}

/// @nodoc
abstract mixin class _$GoalDtoCopyWith<$Res> implements $GoalDtoCopyWith<$Res> {
  factory _$GoalDtoCopyWith(_GoalDto value, $Res Function(_GoalDto) _then) =
      __$GoalDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    String type,
    String name,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'current_amount') int currentAmount,
    @JsonKey(name: 'is_completed') bool isCompleted,
    @JsonKey(name: 'envelope_id') String? envelopeId,
    @JsonKey(name: 'account_id') String? accountId,
    @JsonKey(name: 'target_amount') int? targetAmount,
    @JsonKey(name: 'target_date') DateTime? targetDate,
    @JsonKey(name: 'monthly_contribution') int? monthlyContribution,
  });
}

/// @nodoc
class __$GoalDtoCopyWithImpl<$Res> implements _$GoalDtoCopyWith<$Res> {
  __$GoalDtoCopyWithImpl(this._self, this._then);

  final _GoalDto _self;
  final $Res Function(_GoalDto) _then;

  /// Create a copy of GoalDto
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
    Object? currentAmount = null,
    Object? isCompleted = null,
    Object? envelopeId = freezed,
    Object? accountId = freezed,
    Object? targetAmount = freezed,
    Object? targetDate = freezed,
    Object? monthlyContribution = freezed,
  }) {
    return _then(
      _GoalDto(
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
        currentAmount: null == currentAmount
            ? _self.currentAmount
            : currentAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        isCompleted: null == isCompleted
            ? _self.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
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
      ),
    );
  }
}
