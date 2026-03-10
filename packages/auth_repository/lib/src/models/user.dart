import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String displayName,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('USD') String baseCurrency,
    @Default('system') String themeMode,
    String? accentColor,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// An empty user (unauthenticated).
  static final empty = User(
    id: '',
    email: '',
    displayName: '',
    createdAt: _epoch,
    updatedAt: _epoch,
  );
}

final _epoch = DateTime.fromMillisecondsSinceEpoch(0);
