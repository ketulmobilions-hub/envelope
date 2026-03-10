// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurringRule {
  String get id;
  String get budgetId;
  String get accountId;
  String get type;
  int get amount;
  String get currency;
  String get frequency;
  DateTime get startDate;
  DateTime get nextOccurrence;
  DateTime get createdAt;
  String? get envelopeId;
  String? get payee;
  String? get notes;
  int? get customInterval;
  String? get customUnit;
  DateTime? get endDate;
  bool get autoPost;
  bool get isPaused;

  /// Create a copy of RecurringRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecurringRuleCopyWith<RecurringRule> get copyWith =>
      _$RecurringRuleCopyWithImpl<RecurringRule>(
        this as RecurringRule,
        _$identity,
      );

  /// Serializes this RecurringRule to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecurringRule &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.nextOccurrence, nextOccurrence) ||
                other.nextOccurrence == nextOccurrence) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.payee, payee) || other.payee == payee) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.customInterval, customInterval) ||
                other.customInterval == customInterval) &&
            (identical(other.customUnit, customUnit) ||
                other.customUnit == customUnit) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.autoPost, autoPost) ||
                other.autoPost == autoPost) &&
            (identical(other.isPaused, isPaused) ||
                other.isPaused == isPaused));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    accountId,
    type,
    amount,
    currency,
    frequency,
    startDate,
    nextOccurrence,
    createdAt,
    envelopeId,
    payee,
    notes,
    customInterval,
    customUnit,
    endDate,
    autoPost,
    isPaused,
  );

  @override
  String toString() {
    return 'RecurringRule(id: $id, budgetId: $budgetId, accountId: $accountId, type: $type, amount: $amount, currency: $currency, frequency: $frequency, startDate: $startDate, nextOccurrence: $nextOccurrence, createdAt: $createdAt, envelopeId: $envelopeId, payee: $payee, notes: $notes, customInterval: $customInterval, customUnit: $customUnit, endDate: $endDate, autoPost: $autoPost, isPaused: $isPaused)';
  }
}

/// @nodoc
abstract mixin class $RecurringRuleCopyWith<$Res> {
  factory $RecurringRuleCopyWith(
    RecurringRule value,
    $Res Function(RecurringRule) _then,
  ) = _$RecurringRuleCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String budgetId,
    String accountId,
    String type,
    int amount,
    String currency,
    String frequency,
    DateTime startDate,
    DateTime nextOccurrence,
    DateTime createdAt,
    String? envelopeId,
    String? payee,
    String? notes,
    int? customInterval,
    String? customUnit,
    DateTime? endDate,
    bool autoPost,
    bool isPaused,
  });
}

/// @nodoc
class _$RecurringRuleCopyWithImpl<$Res>
    implements $RecurringRuleCopyWith<$Res> {
  _$RecurringRuleCopyWithImpl(this._self, this._then);

  final RecurringRule _self;
  final $Res Function(RecurringRule) _then;

  /// Create a copy of RecurringRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? accountId = null,
    Object? type = null,
    Object? amount = null,
    Object? currency = null,
    Object? frequency = null,
    Object? startDate = null,
    Object? nextOccurrence = null,
    Object? createdAt = null,
    Object? envelopeId = freezed,
    Object? payee = freezed,
    Object? notes = freezed,
    Object? customInterval = freezed,
    Object? customUnit = freezed,
    Object? endDate = freezed,
    Object? autoPost = null,
    Object? isPaused = null,
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
        accountId: null == accountId
            ? _self.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _self.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        currency: null == currency
            ? _self.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        frequency: null == frequency
            ? _self.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _self.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        nextOccurrence: null == nextOccurrence
            ? _self.nextOccurrence
            : nextOccurrence // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        envelopeId: freezed == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        payee: freezed == payee
            ? _self.payee
            : payee // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _self.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        customInterval: freezed == customInterval
            ? _self.customInterval
            : customInterval // ignore: cast_nullable_to_non_nullable
                  as int?,
        customUnit: freezed == customUnit
            ? _self.customUnit
            : customUnit // ignore: cast_nullable_to_non_nullable
                  as String?,
        endDate: freezed == endDate
            ? _self.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        autoPost: null == autoPost
            ? _self.autoPost
            : autoPost // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPaused: null == isPaused
            ? _self.isPaused
            : isPaused // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [RecurringRule].
extension RecurringRulePatterns on RecurringRule {
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
    TResult Function(_RecurringRule value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecurringRule() when $default != null:
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
    TResult Function(_RecurringRule value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringRule():
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
    TResult? Function(_RecurringRule value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringRule() when $default != null:
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
      String accountId,
      String type,
      int amount,
      String currency,
      String frequency,
      DateTime startDate,
      DateTime nextOccurrence,
      DateTime createdAt,
      String? envelopeId,
      String? payee,
      String? notes,
      int? customInterval,
      String? customUnit,
      DateTime? endDate,
      bool autoPost,
      bool isPaused,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecurringRule() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.accountId,
          _that.type,
          _that.amount,
          _that.currency,
          _that.frequency,
          _that.startDate,
          _that.nextOccurrence,
          _that.createdAt,
          _that.envelopeId,
          _that.payee,
          _that.notes,
          _that.customInterval,
          _that.customUnit,
          _that.endDate,
          _that.autoPost,
          _that.isPaused,
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
      String accountId,
      String type,
      int amount,
      String currency,
      String frequency,
      DateTime startDate,
      DateTime nextOccurrence,
      DateTime createdAt,
      String? envelopeId,
      String? payee,
      String? notes,
      int? customInterval,
      String? customUnit,
      DateTime? endDate,
      bool autoPost,
      bool isPaused,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringRule():
        return $default(
          _that.id,
          _that.budgetId,
          _that.accountId,
          _that.type,
          _that.amount,
          _that.currency,
          _that.frequency,
          _that.startDate,
          _that.nextOccurrence,
          _that.createdAt,
          _that.envelopeId,
          _that.payee,
          _that.notes,
          _that.customInterval,
          _that.customUnit,
          _that.endDate,
          _that.autoPost,
          _that.isPaused,
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
      String accountId,
      String type,
      int amount,
      String currency,
      String frequency,
      DateTime startDate,
      DateTime nextOccurrence,
      DateTime createdAt,
      String? envelopeId,
      String? payee,
      String? notes,
      int? customInterval,
      String? customUnit,
      DateTime? endDate,
      bool autoPost,
      bool isPaused,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringRule() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.accountId,
          _that.type,
          _that.amount,
          _that.currency,
          _that.frequency,
          _that.startDate,
          _that.nextOccurrence,
          _that.createdAt,
          _that.envelopeId,
          _that.payee,
          _that.notes,
          _that.customInterval,
          _that.customUnit,
          _that.endDate,
          _that.autoPost,
          _that.isPaused,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RecurringRule implements RecurringRule {
  const _RecurringRule({
    required this.id,
    required this.budgetId,
    required this.accountId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.frequency,
    required this.startDate,
    required this.nextOccurrence,
    required this.createdAt,
    this.envelopeId,
    this.payee,
    this.notes,
    this.customInterval,
    this.customUnit,
    this.endDate,
    this.autoPost = false,
    this.isPaused = false,
  });
  factory _RecurringRule.fromJson(Map<String, dynamic> json) =>
      _$RecurringRuleFromJson(json);

  @override
  final String id;
  @override
  final String budgetId;
  @override
  final String accountId;
  @override
  final String type;
  @override
  final int amount;
  @override
  final String currency;
  @override
  final String frequency;
  @override
  final DateTime startDate;
  @override
  final DateTime nextOccurrence;
  @override
  final DateTime createdAt;
  @override
  final String? envelopeId;
  @override
  final String? payee;
  @override
  final String? notes;
  @override
  final int? customInterval;
  @override
  final String? customUnit;
  @override
  final DateTime? endDate;
  @override
  @JsonKey()
  final bool autoPost;
  @override
  @JsonKey()
  final bool isPaused;

  /// Create a copy of RecurringRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecurringRuleCopyWith<_RecurringRule> get copyWith =>
      __$RecurringRuleCopyWithImpl<_RecurringRule>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RecurringRuleToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecurringRule &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.nextOccurrence, nextOccurrence) ||
                other.nextOccurrence == nextOccurrence) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.payee, payee) || other.payee == payee) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.customInterval, customInterval) ||
                other.customInterval == customInterval) &&
            (identical(other.customUnit, customUnit) ||
                other.customUnit == customUnit) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.autoPost, autoPost) ||
                other.autoPost == autoPost) &&
            (identical(other.isPaused, isPaused) ||
                other.isPaused == isPaused));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    accountId,
    type,
    amount,
    currency,
    frequency,
    startDate,
    nextOccurrence,
    createdAt,
    envelopeId,
    payee,
    notes,
    customInterval,
    customUnit,
    endDate,
    autoPost,
    isPaused,
  );

  @override
  String toString() {
    return 'RecurringRule(id: $id, budgetId: $budgetId, accountId: $accountId, type: $type, amount: $amount, currency: $currency, frequency: $frequency, startDate: $startDate, nextOccurrence: $nextOccurrence, createdAt: $createdAt, envelopeId: $envelopeId, payee: $payee, notes: $notes, customInterval: $customInterval, customUnit: $customUnit, endDate: $endDate, autoPost: $autoPost, isPaused: $isPaused)';
  }
}

/// @nodoc
abstract mixin class _$RecurringRuleCopyWith<$Res>
    implements $RecurringRuleCopyWith<$Res> {
  factory _$RecurringRuleCopyWith(
    _RecurringRule value,
    $Res Function(_RecurringRule) _then,
  ) = __$RecurringRuleCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String budgetId,
    String accountId,
    String type,
    int amount,
    String currency,
    String frequency,
    DateTime startDate,
    DateTime nextOccurrence,
    DateTime createdAt,
    String? envelopeId,
    String? payee,
    String? notes,
    int? customInterval,
    String? customUnit,
    DateTime? endDate,
    bool autoPost,
    bool isPaused,
  });
}

/// @nodoc
class __$RecurringRuleCopyWithImpl<$Res>
    implements _$RecurringRuleCopyWith<$Res> {
  __$RecurringRuleCopyWithImpl(this._self, this._then);

  final _RecurringRule _self;
  final $Res Function(_RecurringRule) _then;

  /// Create a copy of RecurringRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? accountId = null,
    Object? type = null,
    Object? amount = null,
    Object? currency = null,
    Object? frequency = null,
    Object? startDate = null,
    Object? nextOccurrence = null,
    Object? createdAt = null,
    Object? envelopeId = freezed,
    Object? payee = freezed,
    Object? notes = freezed,
    Object? customInterval = freezed,
    Object? customUnit = freezed,
    Object? endDate = freezed,
    Object? autoPost = null,
    Object? isPaused = null,
  }) {
    return _then(
      _RecurringRule(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        budgetId: null == budgetId
            ? _self.budgetId
            : budgetId // ignore: cast_nullable_to_non_nullable
                  as String,
        accountId: null == accountId
            ? _self.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _self.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        currency: null == currency
            ? _self.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        frequency: null == frequency
            ? _self.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _self.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        nextOccurrence: null == nextOccurrence
            ? _self.nextOccurrence
            : nextOccurrence // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        envelopeId: freezed == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        payee: freezed == payee
            ? _self.payee
            : payee // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _self.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        customInterval: freezed == customInterval
            ? _self.customInterval
            : customInterval // ignore: cast_nullable_to_non_nullable
                  as int?,
        customUnit: freezed == customUnit
            ? _self.customUnit
            : customUnit // ignore: cast_nullable_to_non_nullable
                  as String?,
        endDate: freezed == endDate
            ? _self.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        autoPost: null == autoPost
            ? _self.autoPost
            : autoPost // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPaused: null == isPaused
            ? _self.isPaused
            : isPaused // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
