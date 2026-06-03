// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Budget {
  String get id;
  String get ownerId;
  String get name;
  String get baseCurrency;
  DateTime get createdAt;
  DateTime get updatedAt;
  String get periodType;
  int get periodStartDay;
  bool get isArchived;

  /// Sum of on-budget account starting balances in cents.
  ///
  /// Added to "Ready to Assign" in whichever period contains
  /// [openingDate] and propagates forward via `carriedRta`. This decouples
  /// seed cash from the onboarding month so backdated transactions can be
  /// covered by allocations.
  int get openingBalance;

  /// Date the opening balance is anchored to. Shifts earlier when a
  /// period is backfilled before it.
  DateTime? get openingDate;

  /// Create a copy of Budget
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetCopyWith<Budget> get copyWith =>
      _$BudgetCopyWithImpl<Budget>(this as Budget, _$identity);

  /// Serializes this Budget to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Budget &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.baseCurrency, baseCurrency) ||
                other.baseCurrency == baseCurrency) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.periodType, periodType) ||
                other.periodType == periodType) &&
            (identical(other.periodStartDay, periodStartDay) ||
                other.periodStartDay == periodStartDay) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.openingBalance, openingBalance) ||
                other.openingBalance == openingBalance) &&
            (identical(other.openingDate, openingDate) ||
                other.openingDate == openingDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    ownerId,
    name,
    baseCurrency,
    createdAt,
    updatedAt,
    periodType,
    periodStartDay,
    isArchived,
    openingBalance,
    openingDate,
  );

  @override
  String toString() {
    return 'Budget(id: $id, ownerId: $ownerId, name: $name, baseCurrency: $baseCurrency, createdAt: $createdAt, updatedAt: $updatedAt, periodType: $periodType, periodStartDay: $periodStartDay, isArchived: $isArchived, openingBalance: $openingBalance, openingDate: $openingDate)';
  }
}

/// @nodoc
abstract mixin class $BudgetCopyWith<$Res> {
  factory $BudgetCopyWith(Budget value, $Res Function(Budget) _then) =
      _$BudgetCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String ownerId,
    String name,
    String baseCurrency,
    DateTime createdAt,
    DateTime updatedAt,
    String periodType,
    int periodStartDay,
    bool isArchived,
    int openingBalance,
    DateTime? openingDate,
  });
}

/// @nodoc
class _$BudgetCopyWithImpl<$Res> implements $BudgetCopyWith<$Res> {
  _$BudgetCopyWithImpl(this._self, this._then);

  final Budget _self;
  final $Res Function(Budget) _then;

  /// Create a copy of Budget
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? baseCurrency = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? periodType = null,
    Object? periodStartDay = null,
    Object? isArchived = null,
    Object? openingBalance = null,
    Object? openingDate = freezed,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerId: null == ownerId
            ? _self.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        baseCurrency: null == baseCurrency
            ? _self.baseCurrency
            : baseCurrency // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        periodType: null == periodType
            ? _self.periodType
            : periodType // ignore: cast_nullable_to_non_nullable
                  as String,
        periodStartDay: null == periodStartDay
            ? _self.periodStartDay
            : periodStartDay // ignore: cast_nullable_to_non_nullable
                  as int,
        isArchived: null == isArchived
            ? _self.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
        openingBalance: null == openingBalance
            ? _self.openingBalance
            : openingBalance // ignore: cast_nullable_to_non_nullable
                  as int,
        openingDate: freezed == openingDate
            ? _self.openingDate
            : openingDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [Budget].
extension BudgetPatterns on Budget {
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
    TResult Function(_Budget value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Budget() when $default != null:
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
    TResult Function(_Budget value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Budget():
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
    TResult? Function(_Budget value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Budget() when $default != null:
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
      String ownerId,
      String name,
      String baseCurrency,
      DateTime createdAt,
      DateTime updatedAt,
      String periodType,
      int periodStartDay,
      bool isArchived,
      int openingBalance,
      DateTime? openingDate,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Budget() when $default != null:
        return $default(
          _that.id,
          _that.ownerId,
          _that.name,
          _that.baseCurrency,
          _that.createdAt,
          _that.updatedAt,
          _that.periodType,
          _that.periodStartDay,
          _that.isArchived,
          _that.openingBalance,
          _that.openingDate,
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
      String ownerId,
      String name,
      String baseCurrency,
      DateTime createdAt,
      DateTime updatedAt,
      String periodType,
      int periodStartDay,
      bool isArchived,
      int openingBalance,
      DateTime? openingDate,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Budget():
        return $default(
          _that.id,
          _that.ownerId,
          _that.name,
          _that.baseCurrency,
          _that.createdAt,
          _that.updatedAt,
          _that.periodType,
          _that.periodStartDay,
          _that.isArchived,
          _that.openingBalance,
          _that.openingDate,
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
      String ownerId,
      String name,
      String baseCurrency,
      DateTime createdAt,
      DateTime updatedAt,
      String periodType,
      int periodStartDay,
      bool isArchived,
      int openingBalance,
      DateTime? openingDate,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Budget() when $default != null:
        return $default(
          _that.id,
          _that.ownerId,
          _that.name,
          _that.baseCurrency,
          _that.createdAt,
          _that.updatedAt,
          _that.periodType,
          _that.periodStartDay,
          _that.isArchived,
          _that.openingBalance,
          _that.openingDate,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Budget implements Budget {
  const _Budget({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.baseCurrency,
    required this.createdAt,
    required this.updatedAt,
    this.periodType = 'monthly',
    this.periodStartDay = 1,
    this.isArchived = false,
    this.openingBalance = 0,
    this.openingDate,
  });
  factory _Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);

  @override
  final String id;
  @override
  final String ownerId;
  @override
  final String name;
  @override
  final String baseCurrency;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final String periodType;
  @override
  @JsonKey()
  final int periodStartDay;
  @override
  @JsonKey()
  final bool isArchived;

  /// Sum of on-budget account starting balances in cents.
  ///
  /// Added to "Ready to Assign" in whichever period contains
  /// [openingDate] and propagates forward via `carriedRta`. This decouples
  /// seed cash from the onboarding month so backdated transactions can be
  /// covered by allocations.
  @override
  @JsonKey()
  final int openingBalance;

  /// Date the opening balance is anchored to. Shifts earlier when a
  /// period is backfilled before it.
  @override
  final DateTime? openingDate;

  /// Create a copy of Budget
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetCopyWith<_Budget> get copyWith =>
      __$BudgetCopyWithImpl<_Budget>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BudgetToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Budget &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.baseCurrency, baseCurrency) ||
                other.baseCurrency == baseCurrency) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.periodType, periodType) ||
                other.periodType == periodType) &&
            (identical(other.periodStartDay, periodStartDay) ||
                other.periodStartDay == periodStartDay) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.openingBalance, openingBalance) ||
                other.openingBalance == openingBalance) &&
            (identical(other.openingDate, openingDate) ||
                other.openingDate == openingDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    ownerId,
    name,
    baseCurrency,
    createdAt,
    updatedAt,
    periodType,
    periodStartDay,
    isArchived,
    openingBalance,
    openingDate,
  );

  @override
  String toString() {
    return 'Budget(id: $id, ownerId: $ownerId, name: $name, baseCurrency: $baseCurrency, createdAt: $createdAt, updatedAt: $updatedAt, periodType: $periodType, periodStartDay: $periodStartDay, isArchived: $isArchived, openingBalance: $openingBalance, openingDate: $openingDate)';
  }
}

/// @nodoc
abstract mixin class _$BudgetCopyWith<$Res> implements $BudgetCopyWith<$Res> {
  factory _$BudgetCopyWith(_Budget value, $Res Function(_Budget) _then) =
      __$BudgetCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String ownerId,
    String name,
    String baseCurrency,
    DateTime createdAt,
    DateTime updatedAt,
    String periodType,
    int periodStartDay,
    bool isArchived,
    int openingBalance,
    DateTime? openingDate,
  });
}

/// @nodoc
class __$BudgetCopyWithImpl<$Res> implements _$BudgetCopyWith<$Res> {
  __$BudgetCopyWithImpl(this._self, this._then);

  final _Budget _self;
  final $Res Function(_Budget) _then;

  /// Create a copy of Budget
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? baseCurrency = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? periodType = null,
    Object? periodStartDay = null,
    Object? isArchived = null,
    Object? openingBalance = null,
    Object? openingDate = freezed,
  }) {
    return _then(
      _Budget(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerId: null == ownerId
            ? _self.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        baseCurrency: null == baseCurrency
            ? _self.baseCurrency
            : baseCurrency // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        periodType: null == periodType
            ? _self.periodType
            : periodType // ignore: cast_nullable_to_non_nullable
                  as String,
        periodStartDay: null == periodStartDay
            ? _self.periodStartDay
            : periodStartDay // ignore: cast_nullable_to_non_nullable
                  as int,
        isArchived: null == isArchived
            ? _self.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
        openingBalance: null == openingBalance
            ? _self.openingBalance
            : openingBalance // ignore: cast_nullable_to_non_nullable
                  as int,
        openingDate: freezed == openingDate
            ? _self.openingDate
            : openingDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
