/// Base exception for authentication failures.
sealed class AuthException implements Exception {
  const AuthException(this.message);

  /// The error message.
  final String message;

  @override
  String toString() => message;
}

/// Thrown during sign-up when the email is already registered.
class SignUpWithEmailAndPasswordException extends AuthException {
  const SignUpWithEmailAndPasswordException(super.message);
}

/// Thrown during sign-in with email/password.
class SignInWithEmailAndPasswordException extends AuthException {
  const SignInWithEmailAndPasswordException(super.message);
}

/// Thrown during Google sign-in.
class SignInWithGoogleException extends AuthException {
  const SignInWithGoogleException(super.message);
}

/// Thrown during Apple sign-in.
class SignInWithAppleException extends AuthException {
  const SignInWithAppleException(super.message);
}

/// Thrown during sign-out.
class SignOutException extends AuthException {
  const SignOutException(super.message);
}

/// Thrown during password reset.
class PasswordResetException extends AuthException {
  const PasswordResetException(super.message);
}

/// Thrown during email verification.
class EmailVerificationException extends AuthException {
  const EmailVerificationException(super.message);
}

/// Thrown during profile update.
class UpdateProfileException extends AuthException {
  const UpdateProfileException(super.message);
}
