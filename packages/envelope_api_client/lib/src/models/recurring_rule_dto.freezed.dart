// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_rule_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurringRuleDto {
  String get id;
  @JsonKey(name: 'budget_id')
  String get budgetId;
  @JsonKey(name: 'account_id')
  String get accountId;
  String get type;
  int get amount;
  String get currency;
  String get frequency;
  @JsonKey(name: 'start_date')
  DateTime get startDate;
  @JsonKey(name: 'next_occurrence')
  DateTime get nextOccurrence;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'auto_post')
  bool get autoPost;
  @JsonKey(name: 'is_paused')
  bool get isPaused;
  @JsonKey(name: 'envelope_id')
  String? get envelopeId;
  String? get payee;
  String? get notes;
  @JsonKey(name: 'custom_interval')
  int? get customInterval;
  @JsonKey(name: 'custom_unit')
  String? get customUnit;
  @JsonKey(name: 'end_date')
  DateTime? get endDate;

  /// Create a copy of RecurringRuleDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecurringRuleDtoCopyWith<RecurringRuleDto> get copyWith =>
      _$RecurringRuleDtoCopyWithImpl<RecurringRuleDto>(
        this as RecurringRuleDto,
        _$identity,
      );

  /// Serializes this RecurringRuleDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecurringRuleDto &&
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
            (identical(other.autoPost, autoPost) ||
                other.autoPost == autoPost) &&
            (identical(other.isPaused, isPaused) ||
                other.isPaused == isPaused) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.payee, payee) || other.payee == payee) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.customInterval, customInterval) ||
                other.customInterval == customInterval) &&
            (identical(other.customUnit, customUnit) ||
                other.customUnit == customUnit) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
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
    autoPost,
    isPaused,
    envelopeId,
    payee,
    notes,
    customInterval,
    customUnit,
    endDate,
  );

  @override
  String toString() {
    return 'RecurringRuleDto(id: $id, budgetId: $budgetId, accountId: $accountId, type: $type, amount: $amount, currency: $currency, frequency: $frequency, startDate: $startDate, nextOccurrence: $nextOccurrence, createdAt: $createdAt, autoPost: $autoPost, isPaused: $isPaused, envelopeId: $envelopeId, payee: $payee, notes: $notes, customInterval: $customInterval, customUnit: $customUnit, endDate: $endDate)';
  }
}

/// @nodoc
abstract mixin class $RecurringRuleDtoCopyWith<$Res> {
  factory $RecurringRuleDtoCopyWith(
    RecurringRuleDto value,
    $Res Function(RecurringRuleDto) _then,
  ) = _$RecurringRuleDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    @JsonKey(name: 'account_id') String accountId,
    String type,
    int amount,
    String currency,
    String frequency,
    @JsonKey(name: 'start_date') DateTime startDate,
    @JsonKey(name: 'next_occurrence') DateTime nextOccurrence,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'auto_post') bool autoPost,
    @JsonKey(name: 'is_paused') bool isPaused,
    @JsonKey(name: 'envelope_id') String? envelopeId,
    String? payee,
    String? notes,
    @JsonKey(name: 'custom_interval') int? customInterval,
    @JsonKey(name: 'custom_unit') String? customUnit,
    @JsonKey(name: 'end_date') DateTime? endDate,
  });
}

/// @nodoc
class _$RecurringRuleDtoCopyWithImpl<$Res>
    implements $RecurringRuleDtoCopyWith<$Res> {
  _$RecurringRuleDtoCopyWithImpl(this._self, this._then);

  final RecurringRuleDto _self;
  final $Res Function(RecurringRuleDto) _then;

  /// Create a copy of RecurringRuleDto
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
    Object? autoPost = null,
    Object? isPaused = null,
    Object? envelopeId = freezed,
    Object? payee = freezed,
    Object? notes = freezed,
    Object? customInterval = freezed,
    Object? customUnit = freezed,
    Object? endDate = freezed,
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
        autoPost: null == autoPost
            ? _self.autoPost
            : autoPost // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPaused: null == isPaused
            ? _self.isPaused
            : isPaused // ignore: cast_nullable_to_non_nullable
                  as bool,
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
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [RecurringRuleDto].
extension RecurringRuleDtoPatterns on RecurringRuleDto {
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
    TResult Function(_RecurringRuleDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecurringRuleDto() when $default != null:
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
    TResult Function(_RecurringRuleDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringRuleDto():
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
    TResult? Function(_RecurringRuleDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringRuleDto() when $default != null:
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
      @JsonKey(name: 'account_id') String accountId,
      String type,
      int amount,
      String currency,
      String frequency,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'next_occurrence') DateTime nextOccurrence,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'auto_post') bool autoPost,
      @JsonKey(name: 'is_paused') bool isPaused,
      @JsonKey(name: 'envelope_id') String? envelopeId,
      String? payee,
      String? notes,
      @JsonKey(name: 'custom_interval') int? customInterval,
      @JsonKey(name: 'custom_unit') String? customUnit,
      @JsonKey(name: 'end_date') DateTime? endDate,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecurringRuleDto() when $default != null:
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
          _that.autoPost,
          _that.isPaused,
          _that.envelopeId,
          _that.payee,
          _that.notes,
          _that.customInterval,
          _that.customUnit,
          _that.endDate,
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
      @JsonKey(name: 'account_id') String accountId,
      String type,
      int amount,
      String currency,
      String frequency,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'next_occurrence') DateTime nextOccurrence,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'auto_post') bool autoPost,
      @JsonKey(name: 'is_paused') bool isPaused,
      @JsonKey(name: 'envelope_id') String? envelopeId,
      String? payee,
      String? notes,
      @JsonKey(name: 'custom_interval') int? customInterval,
      @JsonKey(name: 'custom_unit') String? customUnit,
      @JsonKey(name: 'end_date') DateTime? endDate,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringRuleDto():
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
          _that.autoPost,
          _that.isPaused,
          _that.envelopeId,
          _that.payee,
          _that.notes,
          _that.customInterval,
          _that.customUnit,
          _that.endDate,
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
      @JsonKey(name: 'account_id') String accountId,
      String type,
      int amount,
      String currency,
      String frequency,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'next_occurrence') DateTime nextOccurrence,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'auto_post') bool autoPost,
      @JsonKey(name: 'is_paused') bool isPaused,
      @JsonKey(name: 'envelope_id') String? envelopeId,
      String? payee,
      String? notes,
      @JsonKey(name: 'custom_interval') int? customInterval,
      @JsonKey(name: 'custom_unit') String? customUnit,
      @JsonKey(name: 'end_date') DateTime? endDate,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringRuleDto() when $default != null:
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
          _that.autoPost,
          _that.isPaused,
          _that.envelopeId,
          _that.payee,
          _that.notes,
          _that.customInterval,
          _that.customUnit,
          _that.endDate,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RecurringRuleDto implements RecurringRuleDto {
  const _RecurringRuleDto({
    required this.id,
    @JsonKey(name: 'budget_id') required this.budgetId,
    @JsonKey(name: 'account_id') required this.accountId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.frequency,
    @JsonKey(name: 'start_date') required this.startDate,
    @JsonKey(name: 'next_occurrence') required this.nextOccurrence,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'auto_post') this.autoPost = false,
    @JsonKey(name: 'is_paused') this.isPaused = false,
    @JsonKey(name: 'envelope_id') this.envelopeId,
    this.payee,
    this.notes,
    @JsonKey(name: 'custom_interval') this.customInterval,
    @JsonKey(name: 'custom_unit') this.customUnit,
    @JsonKey(name: 'end_date') this.endDate,
  });
  factory _RecurringRuleDto.fromJson(Map<String, dynamic> json) =>
      _$RecurringRuleDtoFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'budget_id')
  final String budgetId;
  @override
  @JsonKey(name: 'account_id')
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
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @override
  @JsonKey(name: 'next_occurrence')
  final DateTime nextOccurrence;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'auto_post')
  final bool autoPost;
  @override
  @JsonKey(name: 'is_paused')
  final bool isPaused;
  @override
  @JsonKey(name: 'envelope_id')
  final String? envelopeId;
  @override
  final String? payee;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'custom_interval')
  final int? customInterval;
  @override
  @JsonKey(name: 'custom_unit')
  final String? customUnit;
  @override
  @JsonKey(name: 'end_date')
  final DateTime? endDate;

  /// Create a copy of RecurringRuleDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecurringRuleDtoCopyWith<_RecurringRuleDto> get copyWith =>
      __$RecurringRuleDtoCopyWithImpl<_RecurringRuleDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RecurringRuleDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecurringRuleDto &&
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
            (identical(other.autoPost, autoPost) ||
                other.autoPost == autoPost) &&
            (identical(other.isPaused, isPaused) ||
                other.isPaused == isPaused) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.payee, payee) || other.payee == payee) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.customInterval, customInterval) ||
                other.customInterval == customInterval) &&
            (identical(other.customUnit, customUnit) ||
                other.customUnit == customUnit) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
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
    autoPost,
    isPaused,
    envelopeId,
    payee,
    notes,
    customInterval,
    customUnit,
    endDate,
  );

  @override
  String toString() {
    return 'RecurringRuleDto(id: $id, budgetId: $budgetId, accountId: $accountId, type: $type, amount: $amount, currency: $currency, frequency: $frequency, startDate: $startDate, nextOccurrence: $nextOccurrence, createdAt: $createdAt, autoPost: $autoPost, isPaused: $isPaused, envelopeId: $envelopeId, payee: $payee, notes: $notes, customInterval: $customInterval, customUnit: $customUnit, endDate: $endDate)';
  }
}

/// @nodoc
abstract mixin class _$RecurringRuleDtoCopyWith<$Res>
    implements $RecurringRuleDtoCopyWith<$Res> {
  factory _$RecurringRuleDtoCopyWith(
    _RecurringRuleDto value,
    $Res Function(_RecurringRuleDto) _then,
  ) = __$RecurringRuleDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    @JsonKey(name: 'account_id') String accountId,
    String type,
    int amount,
    String currency,
    String frequency,
    @JsonKey(name: 'start_date') DateTime startDate,
    @JsonKey(name: 'next_occurrence') DateTime nextOccurrence,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'auto_post') bool autoPost,
    @JsonKey(name: 'is_paused') bool isPaused,
    @JsonKey(name: 'envelope_id') String? envelopeId,
    String? payee,
    String? notes,
    @JsonKey(name: 'custom_interval') int? customInterval,
    @JsonKey(name: 'custom_unit') String? customUnit,
    @JsonKey(name: 'end_date') DateTime? endDate,
  });
}

/// @nodoc
class __$RecurringRuleDtoCopyWithImpl<$Res>
    implements _$RecurringRuleDtoCopyWith<$Res> {
  __$RecurringRuleDtoCopyWithImpl(this._self, this._then);

  final _RecurringRuleDto _self;
  final $Res Function(_RecurringRuleDto) _then;

  /// Create a copy of RecurringRuleDto
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
    Object? autoPost = null,
    Object? isPaused = null,
    Object? envelopeId = freezed,
    Object? payee = freezed,
    Object? notes = freezed,
    Object? customInterval = freezed,
    Object? customUnit = freezed,
    Object? endDate = freezed,
  }) {
    return _then(
      _RecurringRuleDto(
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
        autoPost: null == autoPost
            ? _self.autoPost
            : autoPost // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPaused: null == isPaused
            ? _self.isPaused
            : isPaused // ignore: cast_nullable_to_non_nullable
                  as bool,
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
      ),
    );
  }
}
