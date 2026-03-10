// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spending_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpendingReport {
  DateTime get startDate;
  DateTime get endDate;
  int get totalSpent;
  int get totalIncome;
  List<SpendingByCategory> get byCategory;

  /// Create a copy of SpendingReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SpendingReportCopyWith<SpendingReport> get copyWith =>
      _$SpendingReportCopyWithImpl<SpendingReport>(
        this as SpendingReport,
        _$identity,
      );

  /// Serializes this SpendingReport to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SpendingReport &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            const DeepCollectionEquality().equals(
              other.byCategory,
              byCategory,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    startDate,
    endDate,
    totalSpent,
    totalIncome,
    const DeepCollectionEquality().hash(byCategory),
  );

  @override
  String toString() {
    return 'SpendingReport(startDate: $startDate, endDate: $endDate, totalSpent: $totalSpent, totalIncome: $totalIncome, byCategory: $byCategory)';
  }
}

/// @nodoc
abstract mixin class $SpendingReportCopyWith<$Res> {
  factory $SpendingReportCopyWith(
    SpendingReport value,
    $Res Function(SpendingReport) _then,
  ) = _$SpendingReportCopyWithImpl;
  @useResult
  $Res call({
    DateTime startDate,
    DateTime endDate,
    int totalSpent,
    int totalIncome,
    List<SpendingByCategory> byCategory,
  });
}

/// @nodoc
class _$SpendingReportCopyWithImpl<$Res>
    implements $SpendingReportCopyWith<$Res> {
  _$SpendingReportCopyWithImpl(this._self, this._then);

  final SpendingReport _self;
  final $Res Function(SpendingReport) _then;

  /// Create a copy of SpendingReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? totalSpent = null,
    Object? totalIncome = null,
    Object? byCategory = null,
  }) {
    return _then(
      _self.copyWith(
        startDate: null == startDate
            ? _self.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _self.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalSpent: null == totalSpent
            ? _self.totalSpent
            : totalSpent // ignore: cast_nullable_to_non_nullable
                  as int,
        totalIncome: null == totalIncome
            ? _self.totalIncome
            : totalIncome // ignore: cast_nullable_to_non_nullable
                  as int,
        byCategory: null == byCategory
            ? _self.byCategory
            : byCategory // ignore: cast_nullable_to_non_nullable
                  as List<SpendingByCategory>,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [SpendingReport].
extension SpendingReportPatterns on SpendingReport {
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
    TResult Function(_SpendingReport value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SpendingReport() when $default != null:
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
    TResult Function(_SpendingReport value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SpendingReport():
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
    TResult? Function(_SpendingReport value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SpendingReport() when $default != null:
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
      DateTime startDate,
      DateTime endDate,
      int totalSpent,
      int totalIncome,
      List<SpendingByCategory> byCategory,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SpendingReport() when $default != null:
        return $default(
          _that.startDate,
          _that.endDate,
          _that.totalSpent,
          _that.totalIncome,
          _that.byCategory,
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
      DateTime startDate,
      DateTime endDate,
      int totalSpent,
      int totalIncome,
      List<SpendingByCategory> byCategory,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SpendingReport():
        return $default(
          _that.startDate,
          _that.endDate,
          _that.totalSpent,
          _that.totalIncome,
          _that.byCategory,
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
      DateTime startDate,
      DateTime endDate,
      int totalSpent,
      int totalIncome,
      List<SpendingByCategory> byCategory,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SpendingReport() when $default != null:
        return $default(
          _that.startDate,
          _that.endDate,
          _that.totalSpent,
          _that.totalIncome,
          _that.byCategory,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SpendingReport implements SpendingReport {
  const _SpendingReport({
    required this.startDate,
    required this.endDate,
    required this.totalSpent,
    required this.totalIncome,
    final List<SpendingByCategory> byCategory = const <SpendingByCategory>[],
  }) : _byCategory = byCategory;
  factory _SpendingReport.fromJson(Map<String, dynamic> json) =>
      _$SpendingReportFromJson(json);

  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final int totalSpent;
  @override
  final int totalIncome;
  final List<SpendingByCategory> _byCategory;
  @override
  @JsonKey()
  List<SpendingByCategory> get byCategory {
    if (_byCategory is EqualUnmodifiableListView) return _byCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byCategory);
  }

  /// Create a copy of SpendingReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SpendingReportCopyWith<_SpendingReport> get copyWith =>
      __$SpendingReportCopyWithImpl<_SpendingReport>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SpendingReportToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SpendingReport &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            const DeepCollectionEquality().equals(
              other._byCategory,
              _byCategory,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    startDate,
    endDate,
    totalSpent,
    totalIncome,
    const DeepCollectionEquality().hash(_byCategory),
  );

  @override
  String toString() {
    return 'SpendingReport(startDate: $startDate, endDate: $endDate, totalSpent: $totalSpent, totalIncome: $totalIncome, byCategory: $byCategory)';
  }
}

/// @nodoc
abstract mixin class _$SpendingReportCopyWith<$Res>
    implements $SpendingReportCopyWith<$Res> {
  factory _$SpendingReportCopyWith(
    _SpendingReport value,
    $Res Function(_SpendingReport) _then,
  ) = __$SpendingReportCopyWithImpl;
  @override
  @useResult
  $Res call({
    DateTime startDate,
    DateTime endDate,
    int totalSpent,
    int totalIncome,
    List<SpendingByCategory> byCategory,
  });
}

/// @nodoc
class __$SpendingReportCopyWithImpl<$Res>
    implements _$SpendingReportCopyWith<$Res> {
  __$SpendingReportCopyWithImpl(this._self, this._then);

  final _SpendingReport _self;
  final $Res Function(_SpendingReport) _then;

  /// Create a copy of SpendingReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? totalSpent = null,
    Object? totalIncome = null,
    Object? byCategory = null,
  }) {
    return _then(
      _SpendingReport(
        startDate: null == startDate
            ? _self.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _self.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalSpent: null == totalSpent
            ? _self.totalSpent
            : totalSpent // ignore: cast_nullable_to_non_nullable
                  as int,
        totalIncome: null == totalIncome
            ? _self.totalIncome
            : totalIncome // ignore: cast_nullable_to_non_nullable
                  as int,
        byCategory: null == byCategory
            ? _self._byCategory
            : byCategory // ignore: cast_nullable_to_non_nullable
                  as List<SpendingByCategory>,
      ),
    );
  }
}

/// @nodoc
mixin _$SpendingByCategory {
  String get categoryGroupId;
  String get categoryGroupName;
  int get amount;
  List<SpendingByEnvelope> get envelopes;

  /// Create a copy of SpendingByCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SpendingByCategoryCopyWith<SpendingByCategory> get copyWith =>
      _$SpendingByCategoryCopyWithImpl<SpendingByCategory>(
        this as SpendingByCategory,
        _$identity,
      );

  /// Serializes this SpendingByCategory to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SpendingByCategory &&
            (identical(other.categoryGroupId, categoryGroupId) ||
                other.categoryGroupId == categoryGroupId) &&
            (identical(other.categoryGroupName, categoryGroupName) ||
                other.categoryGroupName == categoryGroupName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            const DeepCollectionEquality().equals(other.envelopes, envelopes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    categoryGroupId,
    categoryGroupName,
    amount,
    const DeepCollectionEquality().hash(envelopes),
  );

  @override
  String toString() {
    return 'SpendingByCategory(categoryGroupId: $categoryGroupId, categoryGroupName: $categoryGroupName, amount: $amount, envelopes: $envelopes)';
  }
}

/// @nodoc
abstract mixin class $SpendingByCategoryCopyWith<$Res> {
  factory $SpendingByCategoryCopyWith(
    SpendingByCategory value,
    $Res Function(SpendingByCategory) _then,
  ) = _$SpendingByCategoryCopyWithImpl;
  @useResult
  $Res call({
    String categoryGroupId,
    String categoryGroupName,
    int amount,
    List<SpendingByEnvelope> envelopes,
  });
}

/// @nodoc
class _$SpendingByCategoryCopyWithImpl<$Res>
    implements $SpendingByCategoryCopyWith<$Res> {
  _$SpendingByCategoryCopyWithImpl(this._self, this._then);

  final SpendingByCategory _self;
  final $Res Function(SpendingByCategory) _then;

  /// Create a copy of SpendingByCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryGroupId = null,
    Object? categoryGroupName = null,
    Object? amount = null,
    Object? envelopes = null,
  }) {
    return _then(
      _self.copyWith(
        categoryGroupId: null == categoryGroupId
            ? _self.categoryGroupId
            : categoryGroupId // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryGroupName: null == categoryGroupName
            ? _self.categoryGroupName
            : categoryGroupName // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _self.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        envelopes: null == envelopes
            ? _self.envelopes
            : envelopes // ignore: cast_nullable_to_non_nullable
                  as List<SpendingByEnvelope>,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [SpendingByCategory].
extension SpendingByCategoryPatterns on SpendingByCategory {
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
    TResult Function(_SpendingByCategory value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SpendingByCategory() when $default != null:
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
    TResult Function(_SpendingByCategory value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SpendingByCategory():
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
    TResult? Function(_SpendingByCategory value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SpendingByCategory() when $default != null:
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
      String categoryGroupId,
      String categoryGroupName,
      int amount,
      List<SpendingByEnvelope> envelopes,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SpendingByCategory() when $default != null:
        return $default(
          _that.categoryGroupId,
          _that.categoryGroupName,
          _that.amount,
          _that.envelopes,
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
      String categoryGroupId,
      String categoryGroupName,
      int amount,
      List<SpendingByEnvelope> envelopes,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SpendingByCategory():
        return $default(
          _that.categoryGroupId,
          _that.categoryGroupName,
          _that.amount,
          _that.envelopes,
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
      String categoryGroupId,
      String categoryGroupName,
      int amount,
      List<SpendingByEnvelope> envelopes,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SpendingByCategory() when $default != null:
        return $default(
          _that.categoryGroupId,
          _that.categoryGroupName,
          _that.amount,
          _that.envelopes,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SpendingByCategory implements SpendingByCategory {
  const _SpendingByCategory({
    required this.categoryGroupId,
    required this.categoryGroupName,
    required this.amount,
    final List<SpendingByEnvelope> envelopes = const <SpendingByEnvelope>[],
  }) : _envelopes = envelopes;
  factory _SpendingByCategory.fromJson(Map<String, dynamic> json) =>
      _$SpendingByCategoryFromJson(json);

  @override
  final String categoryGroupId;
  @override
  final String categoryGroupName;
  @override
  final int amount;
  final List<SpendingByEnvelope> _envelopes;
  @override
  @JsonKey()
  List<SpendingByEnvelope> get envelopes {
    if (_envelopes is EqualUnmodifiableListView) return _envelopes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_envelopes);
  }

  /// Create a copy of SpendingByCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SpendingByCategoryCopyWith<_SpendingByCategory> get copyWith =>
      __$SpendingByCategoryCopyWithImpl<_SpendingByCategory>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SpendingByCategoryToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SpendingByCategory &&
            (identical(other.categoryGroupId, categoryGroupId) ||
                other.categoryGroupId == categoryGroupId) &&
            (identical(other.categoryGroupName, categoryGroupName) ||
                other.categoryGroupName == categoryGroupName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            const DeepCollectionEquality().equals(
              other._envelopes,
              _envelopes,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    categoryGroupId,
    categoryGroupName,
    amount,
    const DeepCollectionEquality().hash(_envelopes),
  );

  @override
  String toString() {
    return 'SpendingByCategory(categoryGroupId: $categoryGroupId, categoryGroupName: $categoryGroupName, amount: $amount, envelopes: $envelopes)';
  }
}

/// @nodoc
abstract mixin class _$SpendingByCategoryCopyWith<$Res>
    implements $SpendingByCategoryCopyWith<$Res> {
  factory _$SpendingByCategoryCopyWith(
    _SpendingByCategory value,
    $Res Function(_SpendingByCategory) _then,
  ) = __$SpendingByCategoryCopyWithImpl;
  @override
  @useResult
  $Res call({
    String categoryGroupId,
    String categoryGroupName,
    int amount,
    List<SpendingByEnvelope> envelopes,
  });
}

/// @nodoc
class __$SpendingByCategoryCopyWithImpl<$Res>
    implements _$SpendingByCategoryCopyWith<$Res> {
  __$SpendingByCategoryCopyWithImpl(this._self, this._then);

  final _SpendingByCategory _self;
  final $Res Function(_SpendingByCategory) _then;

  /// Create a copy of SpendingByCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? categoryGroupId = null,
    Object? categoryGroupName = null,
    Object? amount = null,
    Object? envelopes = null,
  }) {
    return _then(
      _SpendingByCategory(
        categoryGroupId: null == categoryGroupId
            ? _self.categoryGroupId
            : categoryGroupId // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryGroupName: null == categoryGroupName
            ? _self.categoryGroupName
            : categoryGroupName // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _self.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        envelopes: null == envelopes
            ? _self._envelopes
            : envelopes // ignore: cast_nullable_to_non_nullable
                  as List<SpendingByEnvelope>,
      ),
    );
  }
}

/// @nodoc
mixin _$SpendingByEnvelope {
  String get envelopeId;
  String get envelopeName;
  int get amount;

  /// Create a copy of SpendingByEnvelope
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SpendingByEnvelopeCopyWith<SpendingByEnvelope> get copyWith =>
      _$SpendingByEnvelopeCopyWithImpl<SpendingByEnvelope>(
        this as SpendingByEnvelope,
        _$identity,
      );

  /// Serializes this SpendingByEnvelope to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SpendingByEnvelope &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.envelopeName, envelopeName) ||
                other.envelopeName == envelopeName) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, envelopeId, envelopeName, amount);

  @override
  String toString() {
    return 'SpendingByEnvelope(envelopeId: $envelopeId, envelopeName: $envelopeName, amount: $amount)';
  }
}

/// @nodoc
abstract mixin class $SpendingByEnvelopeCopyWith<$Res> {
  factory $SpendingByEnvelopeCopyWith(
    SpendingByEnvelope value,
    $Res Function(SpendingByEnvelope) _then,
  ) = _$SpendingByEnvelopeCopyWithImpl;
  @useResult
  $Res call({String envelopeId, String envelopeName, int amount});
}

/// @nodoc
class _$SpendingByEnvelopeCopyWithImpl<$Res>
    implements $SpendingByEnvelopeCopyWith<$Res> {
  _$SpendingByEnvelopeCopyWithImpl(this._self, this._then);

  final SpendingByEnvelope _self;
  final $Res Function(SpendingByEnvelope) _then;

  /// Create a copy of SpendingByEnvelope
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? envelopeId = null,
    Object? envelopeName = null,
    Object? amount = null,
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
        amount: null == amount
            ? _self.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [SpendingByEnvelope].
extension SpendingByEnvelopePatterns on SpendingByEnvelope {
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
    TResult Function(_SpendingByEnvelope value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SpendingByEnvelope() when $default != null:
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
    TResult Function(_SpendingByEnvelope value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SpendingByEnvelope():
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
    TResult? Function(_SpendingByEnvelope value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SpendingByEnvelope() when $default != null:
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
    TResult Function(String envelopeId, String envelopeName, int amount)?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SpendingByEnvelope() when $default != null:
        return $default(_that.envelopeId, _that.envelopeName, _that.amount);
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
    TResult Function(String envelopeId, String envelopeName, int amount)
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SpendingByEnvelope():
        return $default(_that.envelopeId, _that.envelopeName, _that.amount);
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
    TResult? Function(String envelopeId, String envelopeName, int amount)?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SpendingByEnvelope() when $default != null:
        return $default(_that.envelopeId, _that.envelopeName, _that.amount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SpendingByEnvelope implements SpendingByEnvelope {
  const _SpendingByEnvelope({
    required this.envelopeId,
    required this.envelopeName,
    required this.amount,
  });
  factory _SpendingByEnvelope.fromJson(Map<String, dynamic> json) =>
      _$SpendingByEnvelopeFromJson(json);

  @override
  final String envelopeId;
  @override
  final String envelopeName;
  @override
  final int amount;

  /// Create a copy of SpendingByEnvelope
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SpendingByEnvelopeCopyWith<_SpendingByEnvelope> get copyWith =>
      __$SpendingByEnvelopeCopyWithImpl<_SpendingByEnvelope>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SpendingByEnvelopeToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SpendingByEnvelope &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.envelopeName, envelopeName) ||
                other.envelopeName == envelopeName) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, envelopeId, envelopeName, amount);

  @override
  String toString() {
    return 'SpendingByEnvelope(envelopeId: $envelopeId, envelopeName: $envelopeName, amount: $amount)';
  }
}

/// @nodoc
abstract mixin class _$SpendingByEnvelopeCopyWith<$Res>
    implements $SpendingByEnvelopeCopyWith<$Res> {
  factory _$SpendingByEnvelopeCopyWith(
    _SpendingByEnvelope value,
    $Res Function(_SpendingByEnvelope) _then,
  ) = __$SpendingByEnvelopeCopyWithImpl;
  @override
  @useResult
  $Res call({String envelopeId, String envelopeName, int amount});
}

/// @nodoc
class __$SpendingByEnvelopeCopyWithImpl<$Res>
    implements _$SpendingByEnvelopeCopyWith<$Res> {
  __$SpendingByEnvelopeCopyWithImpl(this._self, this._then);

  final _SpendingByEnvelope _self;
  final $Res Function(_SpendingByEnvelope) _then;

  /// Create a copy of SpendingByEnvelope
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? envelopeId = null,
    Object? envelopeName = null,
    Object? amount = null,
  }) {
    return _then(
      _SpendingByEnvelope(
        envelopeId: null == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String,
        envelopeName: null == envelopeName
            ? _self.envelopeName
            : envelopeName // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _self.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
