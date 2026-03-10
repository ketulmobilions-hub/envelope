// Repository stub — fields will be used when methods are implemented.
// ignore_for_file: unused_field
import 'package:auth_repository/src/models/models.dart';
import 'package:envelope_api_client/envelope_api_client.dart';

/// Repository for authentication operations.
class AuthRepository {
  const AuthRepository({
    required EnvelopeApiClient apiClient,
  }) : _apiClient = apiClient;

  final EnvelopeApiClient _apiClient;

  /// Stream of [User] which emits when the authentication state changes.
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
    // TODO(envelope): Implement auth state stream
    throw UnimplementedError();
  }

  /// Returns the current user.
  /// Returns [User.empty] if the user is not authenticated.
  User get currentUser {
    // TODO(envelope): Implement current user
    throw UnimplementedError();
  }

  /// Signs up with the provided [email] and [password].
  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    // TODO(envelope): Implement sign up
    throw UnimplementedError();
  }

  /// Signs in with the provided [email] and [password].
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // TODO(envelope): Implement sign in
    throw UnimplementedError();
  }

  /// Signs in with Google.
  Future<void> signInWithGoogle() async {
    // TODO(envelope): Implement Google sign in
    throw UnimplementedError();
  }

  /// Signs in with Apple.
  Future<void> signInWithApple() async {
    // TODO(envelope): Implement Apple sign in
    throw UnimplementedError();
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    // TODO(envelope): Implement sign out
    throw UnimplementedError();
  }

  /// Sends a password reset email to the provided [email].
  Future<void> sendPasswordResetEmail({required String email}) async {
    // TODO(envelope): Implement password reset
    throw UnimplementedError();
  }

  /// Sends an email verification to the current user.
  Future<void> sendEmailVerification() async {
    // TODO(envelope): Implement email verification
    throw UnimplementedError();
  }

  /// Updates the current user's profile.
  Future<void> updateProfile({
    String? displayName,
    String? baseCurrency,
    String? themeMode,
    String? accentColor,
  }) async {
    // TODO(envelope): Implement update profile
    throw UnimplementedError();
  }
}
