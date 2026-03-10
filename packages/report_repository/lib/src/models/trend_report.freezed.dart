// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trend_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrendReport {
  List<TrendDataPoint> get dataPoints;

  /// Create a copy of TrendReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TrendReportCopyWith<TrendReport> get copyWith =>
      _$TrendReportCopyWithImpl<TrendReport>(this as TrendReport, _$identity);

  /// Serializes this TrendReport to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TrendReport &&
            const DeepCollectionEquality().equals(
              other.dataPoints,
              dataPoints,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(dataPoints));

  @override
  String toString() {
    return 'TrendReport(dataPoints: $dataPoints)';
  }
}

/// @nodoc
abstract mixin class $TrendReportCopyWith<$Res> {
  factory $TrendReportCopyWith(
    TrendReport value,
    $Res Function(TrendReport) _then,
  ) = _$TrendReportCopyWithImpl;
  @useResult
  $Res call({List<TrendDataPoint> dataPoints});
}

/// @nodoc
class _$TrendReportCopyWithImpl<$Res> implements $TrendReportCopyWith<$Res> {
  _$TrendReportCopyWithImpl(this._self, this._then);

  final TrendReport _self;
  final $Res Function(TrendReport) _then;

  /// Create a copy of TrendReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dataPoints = null}) {
    return _then(
      _self.copyWith(
        dataPoints: null == dataPoints
            ? _self.dataPoints
            : dataPoints // ignore: cast_nullable_to_non_nullable
                  as List<TrendDataPoint>,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [TrendReport].
extension TrendReportPatterns on TrendReport {
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
    TResult Function(_TrendReport value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrendReport() when $default != null:
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
    TResult Function(_TrendReport value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrendReport():
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
    TResult? Function(_TrendReport value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrendReport() when $default != null:
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
    TResult Function(List<TrendDataPoint> dataPoints)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrendReport() when $default != null:
        return $default(_that.dataPoints);
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
    TResult Function(List<TrendDataPoint> dataPoints) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrendReport():
        return $default(_that.dataPoints);
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
    TResult? Function(List<TrendDataPoint> dataPoints)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrendReport() when $default != null:
        return $default(_that.dataPoints);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TrendReport implements TrendReport {
  const _TrendReport({required final List<TrendDataPoint> dataPoints})
    : _dataPoints = dataPoints;
  factory _TrendReport.fromJson(Map<String, dynamic> json) =>
      _$TrendReportFromJson(json);

  final List<TrendDataPoint> _dataPoints;
  @override
  List<TrendDataPoint> get dataPoints {
    if (_dataPoints is EqualUnmodifiableListView) return _dataPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dataPoints);
  }

  /// Create a copy of TrendReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TrendReportCopyWith<_TrendReport> get copyWith =>
      __$TrendReportCopyWithImpl<_TrendReport>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TrendReportToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TrendReport &&
            const DeepCollectionEquality().equals(
              other._dataPoints,
              _dataPoints,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_dataPoints),
  );

  @override
  String toString() {
    return 'TrendReport(dataPoints: $dataPoints)';
  }
}

/// @nodoc
abstract mixin class _$TrendReportCopyWith<$Res>
    implements $TrendReportCopyWith<$Res> {
  factory _$TrendReportCopyWith(
    _TrendReport value,
    $Res Function(_TrendReport) _then,
  ) = __$TrendReportCopyWithImpl;
  @override
  @useResult
  $Res call({List<TrendDataPoint> dataPoints});
}

/// @nodoc
class __$TrendReportCopyWithImpl<$Res> implements _$TrendReportCopyWith<$Res> {
  __$TrendReportCopyWithImpl(this._self, this._then);

  final _TrendReport _self;
  final $Res Function(_TrendReport) _then;

  /// Create a copy of TrendReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? dataPoints = null}) {
    return _then(
      _TrendReport(
        dataPoints: null == dataPoints
            ? _self._dataPoints
            : dataPoints // ignore: cast_nullable_to_non_nullable
                  as List<TrendDataPoint>,
      ),
    );
  }
}

/// @nodoc
mixin _$TrendDataPoint {
  DateTime get date;
  int get income;
  int get spending;
  int get netSavings;

  /// Create a copy of TrendDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TrendDataPointCopyWith<TrendDataPoint> get copyWith =>
      _$TrendDataPointCopyWithImpl<TrendDataPoint>(
        this as TrendDataPoint,
        _$identity,
      );

  /// Serializes this TrendDataPoint to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TrendDataPoint &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.spending, spending) ||
                other.spending == spending) &&
            (identical(other.netSavings, netSavings) ||
                other.netSavings == netSavings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, income, spending, netSavings);

  @override
  String toString() {
    return 'TrendDataPoint(date: $date, income: $income, spending: $spending, netSavings: $netSavings)';
  }
}

/// @nodoc
abstract mixin class $TrendDataPointCopyWith<$Res> {
  factory $TrendDataPointCopyWith(
    TrendDataPoint value,
    $Res Function(TrendDataPoint) _then,
  ) = _$TrendDataPointCopyWithImpl;
  @useResult
  $Res call({DateTime date, int income, int spending, int netSavings});
}

/// @nodoc
class _$TrendDataPointCopyWithImpl<$Res>
    implements $TrendDataPointCopyWith<$Res> {
  _$TrendDataPointCopyWithImpl(this._self, this._then);

  final TrendDataPoint _self;
  final $Res Function(TrendDataPoint) _then;

  /// Create a copy of TrendDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? income = null,
    Object? spending = null,
    Object? netSavings = null,
  }) {
    return _then(
      _self.copyWith(
        date: null == date
            ? _self.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        income: null == income
            ? _self.income
            : income // ignore: cast_nullable_to_non_nullable
                  as int,
        spending: null == spending
            ? _self.spending
            : spending // ignore: cast_nullable_to_non_nullable
                  as int,
        netSavings: null == netSavings
            ? _self.netSavings
            : netSavings // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [TrendDataPoint].
extension TrendDataPointPatterns on TrendDataPoint {
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
    TResult Function(_TrendDataPoint value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrendDataPoint() when $default != null:
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
    TResult Function(_TrendDataPoint value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrendDataPoint():
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
    TResult? Function(_TrendDataPoint value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrendDataPoint() when $default != null:
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
    TResult Function(DateTime date, int income, int spending, int netSavings)?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrendDataPoint() when $default != null:
        return $default(
          _that.date,
          _that.income,
          _that.spending,
          _that.netSavings,
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
    TResult Function(DateTime date, int income, int spending, int netSavings)
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrendDataPoint():
        return $default(
          _that.date,
          _that.income,
          _that.spending,
          _that.netSavings,
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
    TResult? Function(DateTime date, int income, int spending, int netSavings)?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrendDataPoint() when $default != null:
        return $default(
          _that.date,
          _that.income,
          _that.spending,
          _that.netSavings,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TrendDataPoint implements TrendDataPoint {
  const _TrendDataPoint({
    required this.date,
    required this.income,
    required this.spending,
    required this.netSavings,
  });
  factory _TrendDataPoint.fromJson(Map<String, dynamic> json) =>
      _$TrendDataPointFromJson(json);

  @override
  final DateTime date;
  @override
  final int income;
  @override
  final int spending;
  @override
  final int netSavings;

  /// Create a copy of TrendDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TrendDataPointCopyWith<_TrendDataPoint> get copyWith =>
      __$TrendDataPointCopyWithImpl<_TrendDataPoint>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TrendDataPointToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TrendDataPoint &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.spending, spending) ||
                other.spending == spending) &&
            (identical(other.netSavings, netSavings) ||
                other.netSavings == netSavings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, income, spending, netSavings);

  @override
  String toString() {
    return 'TrendDataPoint(date: $date, income: $income, spending: $spending, netSavings: $netSavings)';
  }
}

/// @nodoc
abstract mixin class _$TrendDataPointCopyWith<$Res>
    implements $TrendDataPointCopyWith<$Res> {
  factory _$TrendDataPointCopyWith(
    _TrendDataPoint value,
    $Res Function(_TrendDataPoint) _then,
  ) = __$TrendDataPointCopyWithImpl;
  @override
  @useResult
  $Res call({DateTime date, int income, int spending, int netSavings});
}

/// @nodoc
class __$TrendDataPointCopyWithImpl<$Res>
    implements _$TrendDataPointCopyWith<$Res> {
  __$TrendDataPointCopyWithImpl(this._self, this._then);

  final _TrendDataPoint _self;
  final $Res Function(_TrendDataPoint) _then;

  /// Create a copy of TrendDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? income = null,
    Object? spending = null,
    Object? netSavings = null,
  }) {
    return _then(
      _TrendDataPoint(
        date: null == date
            ? _self.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        income: null == income
            ? _self.income
            : income // ignore: cast_nullable_to_non_nullable
                  as int,
        spending: null == spending
            ? _self.spending
            : spending // ignore: cast_nullable_to_non_nullable
                  as int,
        netSavings: null == netSavings
            ? _self.netSavings
            : netSavings // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
