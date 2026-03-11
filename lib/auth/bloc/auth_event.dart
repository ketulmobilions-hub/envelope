part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user);

  final User user;
}

final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}
