// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_vs_actual_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetVsActualReport {
  String get budgetPeriodId;
  DateTime get startDate;
  DateTime get endDate;
  int get totalAllocated;
  int get totalSpent;
  List<BudgetVsActualItem> get items;

  /// Create a copy of BudgetVsActualReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetVsActualReportCopyWith<BudgetVsActualReport> get copyWith =>
      _$BudgetVsActualReportCopyWithImpl<BudgetVsActualReport>(
        this as BudgetVsActualReport,
        _$identity,
      );

  /// Serializes this BudgetVsActualReport to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetVsActualReport &&
            (identical(other.budgetPeriodId, budgetPeriodId) ||
                other.budgetPeriodId == budgetPeriodId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.totalAllocated, totalAllocated) ||
                other.totalAllocated == totalAllocated) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            const DeepCollectionEquality().equals(other.items, items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    budgetPeriodId,
    startDate,
    endDate,
    totalAllocated,
    totalSpent,
    const DeepCollectionEquality().hash(items),
  );

  @override
  String toString() {
    return 'BudgetVsActualReport(budgetPeriodId: $budgetPeriodId, startDate: $startDate, endDate: $endDate, totalAllocated: $totalAllocated, totalSpent: $totalSpent, items: $items)';
  }
}

/// @nodoc
abstract mixin class $BudgetVsActualReportCopyWith<$Res> {
  factory $BudgetVsActualReportCopyWith(
    BudgetVsActualReport value,
    $Res Function(BudgetVsActualReport) _then,
  ) = _$BudgetVsActualReportCopyWithImpl;
  @useResult
  $Res call({
    String budgetPeriodId,
    DateTime startDate,
    DateTime endDate,
    int totalAllocated,
    int totalSpent,
    List<BudgetVsActualItem> items,
  });
}

/// @nodoc
class _$BudgetVsActualReportCopyWithImpl<$Res>
    implements $BudgetVsActualReportCopyWith<$Res> {
  _$BudgetVsActualReportCopyWithImpl(this._self, this._then);

  final BudgetVsActualReport _self;
  final $Res Function(BudgetVsActualReport) _then;

  /// Create a copy of BudgetVsActualReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgetPeriodId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalAllocated = null,
    Object? totalSpent = null,
    Object? items = null,
  }) {
    return _then(
      _self.copyWith(
        budgetPeriodId: null == budgetPeriodId
            ? _self.budgetPeriodId
            : budgetPeriodId // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _self.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _self.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalAllocated: null == totalAllocated
            ? _self.totalAllocated
            : totalAllocated // ignore: cast_nullable_to_non_nullable
                  as int,
        totalSpent: null == totalSpent
            ? _self.totalSpent
            : totalSpent // ignore: cast_nullable_to_non_nullable
                  as int,
        items: null == items
            ? _self.items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<BudgetVsActualItem>,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [BudgetVsActualReport].
extension BudgetVsActualReportPatterns on BudgetVsActualReport {
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
    TResult Function(_BudgetVsActualReport value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetVsActualReport() when $default != null:
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
    TResult Function(_BudgetVsActualReport value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetVsActualReport():
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
    TResult? Function(_BudgetVsActualReport value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetVsActualReport() when $default != null:
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
      String budgetPeriodId,
      DateTime startDate,
      DateTime endDate,
      int totalAllocated,
      int totalSpent,
      List<BudgetVsActualItem> items,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetVsActualReport() when $default != null:
        return $default(
          _that.budgetPeriodId,
          _that.startDate,
          _that.endDate,
          _that.totalAllocated,
          _that.totalSpent,
          _that.items,
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
      String budgetPeriodId,
      DateTime startDate,
      DateTime endDate,
      int totalAllocated,
      int totalSpent,
      List<BudgetVsActualItem> items,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetVsActualReport():
        return $default(
          _that.budgetPeriodId,
          _that.startDate,
          _that.endDate,
          _that.totalAllocated,
          _that.totalSpent,
          _that.items,
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
      String budgetPeriodId,
      DateTime startDate,
      DateTime endDate,
      int totalAllocated,
      int totalSpent,
      List<BudgetVsActualItem> items,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetVsActualReport() when $default != null:
        return $default(
          _that.budgetPeriodId,
          _that.startDate,
          _that.endDate,
          _that.totalAllocated,
          _that.totalSpent,
          _that.items,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BudgetVsActualReport implements BudgetVsActualReport {
  const _BudgetVsActualReport({
    required this.budgetPeriodId,
    required this.startDate,
    required this.endDate,
    required this.totalAllocated,
    required this.totalSpent,
    final List<BudgetVsActualItem> items = const <BudgetVsActualItem>[],
  }) : _items = items;
  factory _BudgetVsActualReport.fromJson(Map<String, dynamic> json) =>
      _$BudgetVsActualReportFromJson(json);

  @override
  final String budgetPeriodId;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final int totalAllocated;
  @override
  final int totalSpent;
  final List<BudgetVsActualItem> _items;
  @override
  @JsonKey()
  List<BudgetVsActualItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Create a copy of BudgetVsActualReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetVsActualReportCopyWith<_BudgetVsActualReport> get copyWith =>
      __$BudgetVsActualReportCopyWithImpl<_BudgetVsActualReport>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$BudgetVsActualReportToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BudgetVsActualReport &&
            (identical(other.budgetPeriodId, budgetPeriodId) ||
                other.budgetPeriodId == budgetPeriodId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.totalAllocated, totalAllocated) ||
                other.totalAllocated == totalAllocated) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    budgetPeriodId,
    startDate,
    endDate,
    totalAllocated,
    totalSpent,
    const DeepCollectionEquality().hash(_items),
  );

  @override
  String toString() {
    return 'BudgetVsActualReport(budgetPeriodId: $budgetPeriodId, startDate: $startDate, endDate: $endDate, totalAllocated: $totalAllocated, totalSpent: $totalSpent, items: $items)';
  }
}

/// @nodoc
abstract mixin class _$BudgetVsActualReportCopyWith<$Res>
    implements $BudgetVsActualReportCopyWith<$Res> {
  factory _$BudgetVsActualReportCopyWith(
    _BudgetVsActualReport value,
    $Res Function(_BudgetVsActualReport) _then,
  ) = __$BudgetVsActualReportCopyWithImpl;
  @override
  @useResult
  $Res call({
    String budgetPeriodId,
    DateTime startDate,
    DateTime endDate,
    int totalAllocated,
    int totalSpent,
    List<BudgetVsActualItem> items,
  });
}

/// @nodoc
class __$BudgetVsActualReportCopyWithImpl<$Res>
    implements _$BudgetVsActualReportCopyWith<$Res> {
  __$BudgetVsActualReportCopyWithImpl(this._self, this._then);

  final _BudgetVsActualReport _self;
  final $Res Function(_BudgetVsActualReport) _then;

  /// Create a copy of BudgetVsActualReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? budgetPeriodId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalAllocated = null,
    Object? totalSpent = null,
    Object? items = null,
  }) {
    return _then(
      _BudgetVsActualReport(
        budgetPeriodId: null == budgetPeriodId
            ? _self.budgetPeriodId
            : budgetPeriodId // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _self.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _self.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalAllocated: null == totalAllocated
            ? _self.totalAllocated
            : totalAllocated // ignore: cast_nullable_to_non_nullable
                  as int,
        totalSpent: null == totalSpent
            ? _self.totalSpent
            : totalSpent // ignore: cast_nullable_to_non_nullable
                  as int,
        items: null == items
            ? _self._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<BudgetVsActualItem>,
      ),
    );
  }
}

/// @nodoc
mixin _$BudgetVsActualItem {
  String get envelopeId;
  String get envelopeName;
  String get categoryGroupName;
  int get allocated;
  int get spent;
  int get remaining;

  /// Create a copy of BudgetVsActualItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetVsActualItemCopyWith<BudgetVsActualItem> get copyWith =>
      _$BudgetVsActualItemCopyWithImpl<BudgetVsActualItem>(
        this as BudgetVsActualItem,
        _$identity,
      );

  /// Serializes this BudgetVsActualItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetVsActualItem &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.envelopeName, envelopeName) ||
                other.envelopeName == envelopeName) &&
            (identical(other.categoryGroupName, categoryGroupName) ||
                other.categoryGroupName == categoryGroupName) &&
            (identical(other.allocated, allocated) ||
                other.allocated == allocated) &&
            (identical(other.spent, spent) || other.spent == spent) &&
            (identical(other.remaining, remaining) ||
                other.remaining == remaining));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    envelopeId,
    envelopeName,
    categoryGroupName,
    allocated,
    spent,
    remaining,
  );

  @override
  String toString() {
    return 'BudgetVsActualItem(envelopeId: $envelopeId, envelopeName: $envelopeName, categoryGroupName: $categoryGroupName, allocated: $allocated, spent: $spent, remaining: $remaining)';
  }
}

/// @nodoc
abstract mixin class $BudgetVsActualItemCopyWith<$Res> {
  factory $BudgetVsActualItemCopyWith(
    BudgetVsActualItem value,
    $Res Function(BudgetVsActualItem) _then,
  ) = _$BudgetVsActualItemCopyWithImpl;
  @useResult
  $Res call({
    String envelopeId,
    String envelopeName,
    String categoryGroupName,
    int allocated,
    int spent,
    int remaining,
  });
}

/// @nodoc
class _$BudgetVsActualItemCopyWithImpl<$Res>
    implements $BudgetVsActualItemCopyWith<$Res> {
  _$BudgetVsActualItemCopyWithImpl(this._self, this._then);

  final BudgetVsActualItem _self;
  final $Res Function(BudgetVsActualItem) _then;

  /// Create a copy of BudgetVsActualItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? envelopeId = null,
    Object? envelopeName = null,
    Object? categoryGroupName = null,
    Object? allocated = null,
    Object? spent = null,
    Object? remaining = null,
  }) {
    return _then(
      _self.copyWith(
        envelopeId: null == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String,
        envelopeName: null == envelopeName
            ? _self.envelopeName
            : envelopeName // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryGroupName: null == categoryGroupName
            ? _self.categoryGroupName
            : categoryGroupName // ignore: cast_nullable_to_non_nullable
                  as String,
        allocated: null == allocated
            ? _self.allocated
            : allocated // ignore: cast_nullable_to_non_nullable
                  as int,
        spent: null == spent
            ? _self.spent
            : spent // ignore: cast_nullable_to_non_nullable
                  as int,
        remaining: null == remaining
            ? _self.remaining
            : remaining // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [BudgetVsActualItem].
extension BudgetVsActualItemPatterns on BudgetVsActualItem {
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
    TResult Function(_BudgetVsActualItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetVsActualItem() when $default != null:
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
    TResult Function(_BudgetVsActualItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetVsActualItem():
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
    TResult? Function(_BudgetVsActualItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetVsActualItem() when $default != null:
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
      String envelopeId,
      String envelopeName,
      String categoryGroupName,
      int allocated,
      int spent,
      int remaining,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetVsActualItem() when $default != null:
        return $default(
          _that.envelopeId,
          _that.envelopeName,
          _that.categoryGroupName,
          _that.allocated,
          _that.spent,
          _that.remaining,
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
      String envelopeId,
      String envelopeName,
      String categoryGroupName,
      int allocated,
      int spent,
      int remaining,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetVsActualItem():
        return $default(
          _that.envelopeId,
          _that.envelopeName,
          _that.categoryGroupName,
          _that.allocated,
          _that.spent,
          _that.remaining,
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
      String envelopeId,
      String envelopeName,
      String categoryGroupName,
      int allocated,
      int spent,
      int remaining,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetVsActualItem() when $default != null:
        return $default(
          _that.envelopeId,
          _that.envelopeName,
          _that.categoryGroupName,
          _that.allocated,
          _that.spent,
          _that.remaining,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BudgetVsActualItem implements BudgetVsActualItem {
  const _BudgetVsActualItem({
    required this.envelopeId,
    required this.envelopeName,
    required this.categoryGroupName,
    required this.allocated,
    required this.spent,
    required this.remaining,
  });
  factory _BudgetVsActualItem.fromJson(Map<String, dynamic> json) =>
      _$BudgetVsActualItemFromJson(json);

  @override
  final String envelopeId;
  @override
  final String envelopeName;
  @override
  final String categoryGroupName;
  @override
  final int allocated;
  @override
  final int spent;
  @override
  final int remaining;

  /// Create a copy of BudgetVsActualItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetVsActualItemCopyWith<_BudgetVsActualItem> get copyWith =>
      __$BudgetVsActualItemCopyWithImpl<_BudgetVsActualItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BudgetVsActualItemToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BudgetVsActualItem &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.envelopeName, envelopeName) ||
                other.envelopeName == envelopeName) &&
            (identical(other.categoryGroupName, categoryGroupName) ||
                other.categoryGroupName == categoryGroupName) &&
            (identical(other.allocated, allocated) ||
                other.allocated == allocated) &&
            (identical(other.spent, spent) || other.spent == spent) &&
            (identical(other.remaining, remaining) ||
                other.remaining == remaining));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    envelopeId,
    envelopeName,
    categoryGroupName,
    allocated,
    spent,
    remaining,
  );

  @override
  String toString() {
    return 'BudgetVsActualItem(envelopeId: $envelopeId, envelopeName: $envelopeName, categoryGroupName: $categoryGroupName, allocated: $allocated, spent: $spent, remaining: $remaining)';
  }
}

/// @nodoc
abstract mixin class _$BudgetVsActualItemCopyWith<$Res>
    implements $BudgetVsActualItemCopyWith<$Res> {
  factory _$BudgetVsActualItemCopyWith(
    _BudgetVsActualItem value,
    $Res Function(_BudgetVsActualItem) _then,
  ) = __$BudgetVsActualItemCopyWithImpl;
  @override
  @useResult
  $Res call({
    String envelopeId,
    String envelopeName,
    String categoryGroupName,
    int allocated,
    int spent,
    int remaining,
  });
}

/// @nodoc
class __$BudgetVsActualItemCopyWithImpl<$Res>
    implements _$BudgetVsActualItemCopyWith<$Res> {
  __$BudgetVsActualItemCopyWithImpl(this._self, this._then);

  final _BudgetVsActualItem _self;
  final $Res Function(_BudgetVsActualItem) _then;

  /// Create a copy of BudgetVsActualItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? envelopeId = null,
    Object? envelopeName = null,
    Object? categoryGroupName = null,
    Object? allocated = null,
    Object? spent = null,
    Object? remaining = null,
  }) {
    return _then(
      _BudgetVsActualItem(
        envelopeId: null == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String,
        envelopeName: null == envelopeName
            ? _self.envelopeName
            : envelopeName // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryGroupName: null == categoryGroupName
            ? _self.categoryGroupName
            : categoryGroupName // ignore: cast_nullable_to_non_nullable
                  as String,
        allocated: null == allocated
            ? _self.allocated
            : allocated // ignore: cast_nullable_to_non_nullable
                  as int,
        spent: null == spent
            ? _self.spent
            : spent // ignore: cast_nullable_to_non_nullable
                  as int,
        remaining: null == remaining
            ? _self.remaining
            : remaining // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
