// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_period_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetPeriodDto {
  String get id;
  @JsonKey(name: 'budget_id')
  String get budgetId;
  @JsonKey(name: 'start_date')
  DateTime get startDate;
  @JsonKey(name: 'end_date')
  DateTime get endDate;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'total_income')
  int get totalIncome;
  @JsonKey(name: 'total_allocated')
  int get totalAllocated;
  @JsonKey(name: 'carried_rta')
  int get carriedRta;
  @JsonKey(name: 'is_closed')
  bool get isClosed;

  /// Create a copy of BudgetPeriodDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetPeriodDtoCopyWith<BudgetPeriodDto> get copyWith =>
      _$BudgetPeriodDtoCopyWithImpl<BudgetPeriodDto>(
        this as BudgetPeriodDto,
        _$identity,
      );

  /// Serializes this BudgetPeriodDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetPeriodDto &&
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
            (identical(other.carriedRta, carriedRta) ||
                other.carriedRta == carriedRta) &&
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
    carriedRta,
    isClosed,
  );

  @override
  String toString() {
    return 'BudgetPeriodDto(id: $id, budgetId: $budgetId, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, totalIncome: $totalIncome, totalAllocated: $totalAllocated, carriedRta: $carriedRta, isClosed: $isClosed)';
  }
}

/// @nodoc
abstract mixin class $BudgetPeriodDtoCopyWith<$Res> {
  factory $BudgetPeriodDtoCopyWith(
    BudgetPeriodDto value,
    $Res Function(BudgetPeriodDto) _then,
  ) = _$BudgetPeriodDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    @JsonKey(name: 'start_date') DateTime startDate,
    @JsonKey(name: 'end_date') DateTime endDate,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'total_income') int totalIncome,
    @JsonKey(name: 'total_allocated') int totalAllocated,
    @JsonKey(name: 'carried_rta') int carriedRta,
    @JsonKey(name: 'is_closed') bool isClosed,
  });
}

/// @nodoc
class _$BudgetPeriodDtoCopyWithImpl<$Res>
    implements $BudgetPeriodDtoCopyWith<$Res> {
  _$BudgetPeriodDtoCopyWithImpl(this._self, this._then);

  final BudgetPeriodDto _self;
  final $Res Function(BudgetPeriodDto) _then;

  /// Create a copy of BudgetPeriodDto
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
    Object? carriedRta = null,
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
        carriedRta: null == carriedRta
            ? _self.carriedRta
            : carriedRta // ignore: cast_nullable_to_non_nullable
                  as int,
        isClosed: null == isClosed
            ? _self.isClosed
            : isClosed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [BudgetPeriodDto].
extension BudgetPeriodDtoPatterns on BudgetPeriodDto {
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
    TResult Function(_BudgetPeriodDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetPeriodDto() when $default != null:
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
    TResult Function(_BudgetPeriodDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetPeriodDto():
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
    TResult? Function(_BudgetPeriodDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetPeriodDto() when $default != null:
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
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'end_date') DateTime endDate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'total_income') int totalIncome,
      @JsonKey(name: 'total_allocated') int totalAllocated,
      @JsonKey(name: 'carried_rta') int carriedRta,
      @JsonKey(name: 'is_closed') bool isClosed,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetPeriodDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.startDate,
          _that.endDate,
          _that.createdAt,
          _that.totalIncome,
          _that.totalAllocated,
          _that.carriedRta,
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
      @JsonKey(name: 'budget_id') String budgetId,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'end_date') DateTime endDate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'total_income') int totalIncome,
      @JsonKey(name: 'total_allocated') int totalAllocated,
      @JsonKey(name: 'carried_rta') int carriedRta,
      @JsonKey(name: 'is_closed') bool isClosed,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetPeriodDto():
        return $default(
          _that.id,
          _that.budgetId,
          _that.startDate,
          _that.endDate,
          _that.createdAt,
          _that.totalIncome,
          _that.totalAllocated,
          _that.carriedRta,
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
      @JsonKey(name: 'budget_id') String budgetId,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'end_date') DateTime endDate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'total_income') int totalIncome,
      @JsonKey(name: 'total_allocated') int totalAllocated,
      @JsonKey(name: 'carried_rta') int carriedRta,
      @JsonKey(name: 'is_closed') bool isClosed,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetPeriodDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.startDate,
          _that.endDate,
          _that.createdAt,
          _that.totalIncome,
          _that.totalAllocated,
          _that.carriedRta,
          _that.isClosed,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BudgetPeriodDto implements BudgetPeriodDto {
  const _BudgetPeriodDto({
    required this.id,
    @JsonKey(name: 'budget_id') required this.budgetId,
    @JsonKey(name: 'start_date') required this.startDate,
    @JsonKey(name: 'end_date') required this.endDate,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'total_income') this.totalIncome = 0,
    @JsonKey(name: 'total_allocated') this.totalAllocated = 0,
    @JsonKey(name: 'carried_rta') this.carriedRta = 0,
    @JsonKey(name: 'is_closed') this.isClosed = false,
  });
  factory _BudgetPeriodDto.fromJson(Map<String, dynamic> json) =>
      _$BudgetPeriodDtoFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'budget_id')
  final String budgetId;
  @override
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @override
  @JsonKey(name: 'end_date')
  final DateTime endDate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'total_income')
  final int totalIncome;
  @override
  @JsonKey(name: 'total_allocated')
  final int totalAllocated;
  @override
  @JsonKey(name: 'carried_rta')
  final int carriedRta;
  @override
  @JsonKey(name: 'is_closed')
  final bool isClosed;

  /// Create a copy of BudgetPeriodDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetPeriodDtoCopyWith<_BudgetPeriodDto> get copyWith =>
      __$BudgetPeriodDtoCopyWithImpl<_BudgetPeriodDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BudgetPeriodDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BudgetPeriodDto &&
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
            (identical(other.carriedRta, carriedRta) ||
                other.carriedRta == carriedRta) &&
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
    carriedRta,
    isClosed,
  );

  @override
  String toString() {
    return 'BudgetPeriodDto(id: $id, budgetId: $budgetId, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, totalIncome: $totalIncome, totalAllocated: $totalAllocated, carriedRta: $carriedRta, isClosed: $isClosed)';
  }
}

/// @nodoc
abstract mixin class _$BudgetPeriodDtoCopyWith<$Res>
    implements $BudgetPeriodDtoCopyWith<$Res> {
  factory _$BudgetPeriodDtoCopyWith(
    _BudgetPeriodDto value,
    $Res Function(_BudgetPeriodDto) _then,
  ) = __$BudgetPeriodDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    @JsonKey(name: 'start_date') DateTime startDate,
    @JsonKey(name: 'end_date') DateTime endDate,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'total_income') int totalIncome,
    @JsonKey(name: 'total_allocated') int totalAllocated,
    @JsonKey(name: 'carried_rta') int carriedRta,
    @JsonKey(name: 'is_closed') bool isClosed,
  });
}

/// @nodoc
class __$BudgetPeriodDtoCopyWithImpl<$Res>
    implements _$BudgetPeriodDtoCopyWith<$Res> {
  __$BudgetPeriodDtoCopyWithImpl(this._self, this._then);

  final _BudgetPeriodDto _self;
  final $Res Function(_BudgetPeriodDto) _then;

  /// Create a copy of BudgetPeriodDto
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
    Object? carriedRta = null,
    Object? isClosed = null,
  }) {
    return _then(
      _BudgetPeriodDto(
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
        carriedRta: null == carriedRta
            ? _self.carriedRta
            : carriedRta // ignore: cast_nullable_to_non_nullable
                  as int,
        isClosed: null == isClosed
            ? _self.isClosed
            : isClosed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
