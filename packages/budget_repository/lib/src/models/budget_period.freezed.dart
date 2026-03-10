// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_period.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetPeriod {
  String get id;
  String get budgetId;
  DateTime get startDate;
  DateTime get endDate;
  DateTime get createdAt;
  int get totalIncome;
  int get totalAllocated;
  bool get isClosed;

  /// Create a copy of BudgetPeriod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetPeriodCopyWith<BudgetPeriod> get copyWith =>
      _$BudgetPeriodCopyWithImpl<BudgetPeriod>(
        this as BudgetPeriod,
        _$identity,
      );

  /// Serializes this BudgetPeriod to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetPeriod &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalAllocated, totalAllocated) ||
                other.totalAllocated == totalAllocated) &&
            (identical(other.isClosed, isClosed) ||
                other.isClosed == isClosed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    startDate,
    endDate,
    createdAt,
    totalIncome,
    totalAllocated,
    isClosed,
  );

  @override
  String toString() {
    return 'BudgetPeriod(id: $id, budgetId: $budgetId, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, totalIncome: $totalIncome, totalAllocated: $totalAllocated, isClosed: $isClosed)';
  }
}

/// @nodoc
abstract mixin class $BudgetPeriodCopyWith<$Res> {
  factory $BudgetPeriodCopyWith(
    BudgetPeriod value,
    $Res Function(BudgetPeriod) _then,
  ) = _$BudgetPeriodCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String budgetId,
    DateTime startDate,
    DateTime endDate,
    DateTime createdAt,
    int totalIncome,
    int totalAllocated,
    bool isClosed,
  });
}

/// @nodoc
class _$BudgetPeriodCopyWithImpl<$Res> implements $BudgetPeriodCopyWith<$Res> {
  _$BudgetPeriodCopyWithImpl(this._self, this._then);

  final BudgetPeriod _self;
  final $Res Function(BudgetPeriod) _then;

  /// Create a copy of BudgetPeriod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? createdAt = null,
    Object? totalIncome = null,
    Object? totalAllocated = null,
    Object? isClosed = null,
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
        startDate: null == startDate
            ? _self.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _self.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalIncome: null == totalIncome
            ? _self.totalIncome
            : totalIncome // ignore: cast_nullable_to_non_nullable
                  as int,
        totalAllocated: null == totalAllocated
            ? _self.totalAllocated
            : totalAllocated // ignore: cast_nullable_to_non_nullable
                  as int,
        isClosed: null == isClosed
            ? _self.isClosed
            : isClosed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [BudgetPeriod].
extension BudgetPeriodPatterns on BudgetPeriod {
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
    TResult Function(_BudgetPeriod value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetPeriod() when $default != null:
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
    TResult Function(_BudgetPeriod value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetPeriod():
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
    TResult? Function(_BudgetPeriod value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetPeriod() when $default != null:
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
      DateTime startDate,
      DateTime endDate,
      DateTime createdAt,
      int totalIncome,
      int totalAllocated,
      bool isClosed,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetPeriod() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.startDate,
          _that.endDate,
          _that.createdAt,
          _that.totalIncome,
          _that.totalAllocated,
          _that.isClosed,
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
      DateTime startDate,
      DateTime endDate,
      DateTime createdAt,
      int totalIncome,
      int totalAllocated,
      bool isClosed,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetPeriod():
        return $default(
          _that.id,
          _that.budgetId,
          _that.startDate,
          _that.endDate,
          _that.createdAt,
          _that.totalIncome,
          _that.totalAllocated,
          _that.isClosed,
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
      DateTime startDate,
      DateTime endDate,
      DateTime createdAt,
      int totalIncome,
      int totalAllocated,
      bool isClosed,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetPeriod() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.startDate,
          _that.endDate,
          _that.createdAt,
          _that.totalIncome,
          _that.totalAllocated,
          _that.isClosed,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BudgetPeriod implements BudgetPeriod {
  const _BudgetPeriod({
    required this.id,
    required this.budgetId,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    this.totalIncome = 0,
    this.totalAllocated = 0,
    this.isClosed = false,
  });
  factory _BudgetPeriod.fromJson(Map<String, dynamic> json) =>
      _$BudgetPeriodFromJson(json);

  @override
  final String id;
  @override
  final String budgetId;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final int totalIncome;
  @override
  @JsonKey()
  final int totalAllocated;
  @override
  @JsonKey()
  final bool isClosed;

  /// Create a copy of BudgetPeriod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetPeriodCopyWith<_BudgetPeriod> get copyWith =>
      __$BudgetPeriodCopyWithImpl<_BudgetPeriod>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BudgetPeriodToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BudgetPeriod &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalAllocated, totalAllocated) ||
                other.totalAllocated == totalAllocated) &&
            (identical(other.isClosed, isClosed) ||
                other.isClosed == isClosed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    startDate,
    endDate,
    createdAt,
    totalIncome,
    totalAllocated,
    isClosed,
  );

  @override
  String toString() {
    return 'BudgetPeriod(id: $id, budgetId: $budgetId, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, totalIncome: $totalIncome, totalAllocated: $totalAllocated, isClosed: $isClosed)';
  }
}

/// @nodoc
abstract mixin class _$BudgetPeriodCopyWith<$Res>
    implements $BudgetPeriodCopyWith<$Res> {
  factory _$BudgetPeriodCopyWith(
    _BudgetPeriod value,
    $Res Function(_BudgetPeriod) _then,
  ) = __$BudgetPeriodCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String budgetId,
    DateTime startDate,
    DateTime endDate,
    DateTime createdAt,
    int totalIncome,
    int totalAllocated,
    bool isClosed,
  });
}

/// @nodoc
class __$BudgetPeriodCopyWithImpl<$Res>
    implements _$BudgetPeriodCopyWith<$Res> {
  __$BudgetPeriodCopyWithImpl(this._self, this._then);

  final _BudgetPeriod _self;
  final $Res Function(_BudgetPeriod) _then;

  /// Create a copy of BudgetPeriod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? createdAt = null,
    Object? totalIncome = null,
    Object? totalAllocated = null,
    Object? isClosed = null,
  }) {
    return _then(
      _BudgetPeriod(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        budgetId: null == budgetId
            ? _self.budgetId
            : budgetId // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _self.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _self.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalIncome: null == totalIncome
            ? _self.totalIncome
            : totalIncome // ignore: cast_nullable_to_non_nullable
                  as int,
        totalAllocated: null == totalAllocated
            ? _self.totalAllocated
            : totalAllocated // ignore: cast_nullable_to_non_nullable
                  as int,
        isClosed: null == isClosed
            ? _self.isClosed
            : isClosed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
