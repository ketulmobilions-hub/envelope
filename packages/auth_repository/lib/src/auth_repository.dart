import 'dart:async';

import 'package:async/async.dart';
import 'package:auth_repository/src/exceptions.dart';
import 'package:auth_repository/src/models/models.dart';
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart'
    hide SignInWithAppleException;
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

/// Signature for obtaining Apple ID credentials.
/// Defaults to [SignInWithApple.getAppleIDCredential].
typedef AppleCredentialProvider = Future<AuthorizationCredentialAppleID>
    Function({required List<AppleIDAuthorizationScopes> scopes});

/// Repository for authentication operations.
class AuthRepository {
  /// Creates an [AuthRepository].
  AuthRepository({
    required EnvelopeApiClient apiClient,
    GoogleSignIn? googleSignIn,
    AppleCredentialProvider? appleCredentialProvider,
  })  : _apiClient = apiClient,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _getAppleCredential =
            appleCredentialProvider ?? SignInWithApple.getAppleIDCredential;

  final EnvelopeApiClient _apiClient;
  final GoogleSignIn _googleSignIn;
  final AppleCredentialProvider _getAppleCredential;

  /// Cache of the current user to avoid unnecessary lookups.
  User _cachedUser = User.empty;

  /// Controller to push profile updates through the user stream.
  final _profileUpdateController = StreamController<User>.broadcast();

  /// Stream of [User] which emits when the authentication state changes
  /// or when the profile is updated locally.
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
    final authStream =
        _apiClient.auth.onAuthStateChange.asyncMap((authState) async {
      final supabaseUser = authState.session?.user;
      if (supabaseUser == null) {
        _cachedUser = User.empty;
        return User.empty;
      }

      // Try to fetch full profile from the users table first, falling back
      // to auth metadata for fields not yet in the table.
      final user = await _resolveUser(supabaseUser);
      _cachedUser = user;
      return user;
    });

    return StreamGroup.merge([authStream, _profileUpdateController.stream]);
  }

  /// Returns the current cached user.
  /// Returns [User.empty] if the user is not authenticated.
  User get currentUser => _cachedUser;

  /// Signs up with the provided [email], [password], and [displayName].
  ///
  /// After Supabase auth sign-up, creates a user record in the `users` table.
  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await _apiClient.auth.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );

      final supabaseUser = response.user;
      if (supabaseUser == null) {
        throw const SignUpWithEmailAndPasswordException(
          'Sign up failed: no user returned.',
        );
      }

      // Update the user record created by the auth trigger with
      // display name and consent tracking fields.
      final now = DateTime.now();
      await _apiClient.users.updateUser(
        UserDto(
          id: supabaseUser.id,
          email: email,
          displayName: displayName,
          createdAt: now,
          updatedAt: now,
          privacyAcceptedAt: now,
          termsAcceptedAt: now,
          consentVersion: '1.0',
        ),
      );
    } on SignUpWithEmailAndPasswordException {
      rethrow;
    } on supabase.AuthException catch (e) {
      throw SignUpWithEmailAndPasswordException(e.message);
    } on EnvelopeApiException catch (e) {
      throw SignUpWithEmailAndPasswordException(e.message);
    } on Exception {
      throw const SignUpWithEmailAndPasswordException(
        'An unexpected error occurred during sign up.',
      );
    }
  }

  /// Signs in with the provided [email] and [password].
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _apiClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on supabase.AuthException catch (e) {
      throw SignInWithEmailAndPasswordException(e.message);
    } on Exception {
      throw const SignInWithEmailAndPasswordException(
        'An unexpected error occurred during sign in.',
      );
    }
  }

  /// Signs in with Google using native Google Sign-In.
  ///
  /// Uses the `google_sign_in` package to get an ID token, then authenticates
  /// with Supabase using that token.
  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const SignInWithGoogleException('Google sign-in was cancelled.');
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw const SignInWithGoogleException(
          'Failed to obtain Google ID token.',
        );
      }

      final response = await _apiClient.auth.signInWithGoogleIdToken(
        idToken: idToken,
        accessToken: googleAuth.accessToken,
      );

      final supabaseUser = response.user;
      if (supabaseUser == null) {
        throw const SignInWithGoogleException(
          'Google sign-in failed: no user returned.',
        );
      }

      // Ensure user record exists in the users table.
      await _ensureUserRecord(supabaseUser);
    } on SignInWithGoogleException {
      rethrow;
    } on supabase.AuthException catch (e) {
      throw SignInWithGoogleException(e.message);
    } on Exception {
      throw const SignInWithGoogleException(
        'An unexpected error occurred during Google sign in.',
      );
    }
  }

  /// Signs in with Apple using native Apple Sign-In.
  ///
  /// Uses the `sign_in_with_apple` package to get credentials, then
  /// authenticates with Supabase using the identity token.
  Future<void> signInWithApple() async {
    try {
      final credential = await _getAppleCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const SignInWithAppleException(
          'Failed to obtain Apple identity token.',
        );
      }

      final response = await _apiClient.auth.signInWithAppleIdToken(
        idToken: idToken,
        nonce: credential.authorizationCode,
      );

      final supabaseUser = response.user;
      if (supabaseUser == null) {
        throw const SignInWithAppleException(
          'Apple sign-in failed: no user returned.',
        );
      }

      // Ensure user record exists in the users table.
      await _ensureUserRecord(supabaseUser);
    } on SignInWithAppleException {
      rethrow;
    } on supabase.AuthException catch (e) {
      throw SignInWithAppleException(e.message);
    } on Exception {
      throw const SignInWithAppleException(
        'An unexpected error occurred during Apple sign in.',
      );
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } on Exception catch (_) {
      // Ignore Google sign-out errors — the user might not have signed in
      // with Google.
    }
    try {
      await _apiClient.auth.signOut();
      _cachedUser = User.empty;
    } on supabase.AuthException catch (e) {
      throw SignOutException(e.message);
    } on Exception {
      throw const SignOutException(
        'An unexpected error occurred during sign out.',
      );
    }
  }

  /// Sends a password reset email to the provided [email].
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _apiClient.auth.resetPasswordForEmail(email);
    } on supabase.AuthException catch (e) {
      throw PasswordResetException(e.message);
    } on Exception {
      throw const PasswordResetException(
        'An unexpected error occurred during password reset.',
      );
    }
  }

  /// Sends an email verification to the current user.
  Future<void> sendEmailVerification() async {
    try {
      final supabaseUser = _apiClient.auth.currentUser;
      if (supabaseUser == null) {
        throw const EmailVerificationException(
          'No authenticated user found.',
        );
      }
      final email = supabaseUser.email;
      if (email == null || email.isEmpty) {
        throw const EmailVerificationException(
          'No email address associated with this account.',
        );
      }
      await _apiClient.auth.resendEmailVerification(email);
    } on EmailVerificationException {
      rethrow;
    } on supabase.AuthException catch (e) {
      throw EmailVerificationException(e.message);
    } on Exception {
      throw const EmailVerificationException(
        'An unexpected error occurred during email verification.',
      );
    }
  }

  /// Updates the current user's profile in the `users` table.
  Future<void> updateProfile({
    String? displayName,
    String? baseCurrency,
    String? themeMode,
    String? accentColor,
  }) async {
    try {
      final supabaseUser = _apiClient.auth.currentUser;
      if (supabaseUser == null) {
        throw const UpdateProfileException('No authenticated user found.');
      }

      // Fetch current user record, apply updates, and save.
      final currentDto = await _apiClient.users.getUser(supabaseUser.id);
      final updatedDto = UserDto(
        id: currentDto.id,
        email: currentDto.email,
        displayName: displayName ?? currentDto.displayName,
        createdAt: currentDto.createdAt,
        updatedAt: DateTime.now(),
        baseCurrency: baseCurrency ?? currentDto.baseCurrency,
        themeMode: themeMode ?? currentDto.themeMode,
        accentColor: accentColor ?? currentDto.accentColor,
      );

      await _apiClient.users.updateUser(updatedDto);

      // Update the cached user and push through the stream.
      _cachedUser = User(
        id: updatedDto.id,
        email: updatedDto.email,
        displayName: updatedDto.displayName,
        createdAt: updatedDto.createdAt,
        updatedAt: updatedDto.updatedAt,
        baseCurrency: updatedDto.baseCurrency,
        themeMode: updatedDto.themeMode,
        accentColor: updatedDto.accentColor,
      );
      _profileUpdateController.add(_cachedUser);
    } on UpdateProfileException {
      rethrow;
    } on Exception {
      throw const UpdateProfileException(
        'An unexpected error occurred while updating profile.',
      );
    }
  }

  /// Changes the current user's password.
  Future<void> changePassword(String newPassword) async {
    try {
      await _apiClient.auth.auth.updateUser(
        supabase.UserAttributes(password: newPassword),
      );
    } on supabase.AuthException catch (e) {
      throw ChangePasswordException(e.message);
    } on Exception {
      throw const ChangePasswordException(
        'An unexpected error occurred while changing password.',
      );
    }
  }

  /// Deletes the current user's account via the server-side Edge Function
  /// (which handles both data cascade and auth user deletion) and signs out.
  ///
  /// Callers should clear the local database before or after calling this.
  Future<void> deleteAccount() async {
    try {
      final supabaseUser = _apiClient.auth.currentUser;
      if (supabaseUser == null) {
        throw const DeleteAccountException('No authenticated user found.');
      }
      await _apiClient.users.invokeDeleteAccount();
      _cachedUser = User.empty;
      // Sign out locally (session is already invalidated server-side).
      try {
        await _apiClient.auth.signOut();
      } on Exception {
        // If sign-out fails, that's OK — the auth user is already deleted.
      }
    } on DeleteAccountException {
      rethrow;
    } on Exception {
      throw const DeleteAccountException(
        'An unexpected error occurred while deleting account.',
      );
    }
  }

  /// Ensures a user record exists in the `users` table for social sign-ins.
  ///
  /// Only catches [EnvelopeApiException] from a failed getUser lookup (the
  /// user doesn't exist yet). Other exceptions propagate to the caller.
  Future<void> _ensureUserRecord(supabase.User supabaseUser) async {
    try {
      await _apiClient.users.getUser(supabaseUser.id);
    } on EnvelopeApiException {
      // User doesn't exist in the table yet — create one.
      final now = DateTime.now();
      final metadata = supabaseUser.userMetadata ?? {};
      await _apiClient.users.createUser(
        UserDto(
          id: supabaseUser.id,
          email: supabaseUser.email ?? '',
          displayName:
              metadata['display_name'] as String? ??
              metadata['full_name'] as String? ??
              metadata['name'] as String? ??
              supabaseUser.email?.split('@').first ??
              '',
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
  }

  /// Resolves a full [User] domain model from a Supabase auth user.
  ///
  /// Attempts to fetch the user's profile from the `users` table first.
  /// Falls back to auth metadata if the table lookup fails (e.g., the user
  /// record hasn't been created yet).
  Future<User> _resolveUser(supabase.User supabaseUser) async {
    try {
      final dto = await _apiClient.users.getUser(supabaseUser.id);
      return User(
        id: dto.id,
        email: dto.email,
        displayName: dto.displayName,
        createdAt: dto.createdAt,
        updatedAt: dto.updatedAt,
        baseCurrency: dto.baseCurrency,
        themeMode: dto.themeMode,
        accentColor: dto.accentColor,
      );
    } on EnvelopeApiException {
      // User record not in table yet — fall back to auth metadata.
      return _mapSupabaseUser(supabaseUser);
    }
  }

  /// Maps a Supabase [supabase.User] to the domain [User] model using
  /// only auth metadata. Used as a fallback when the `users` table record
  /// is not yet available.
  User _mapSupabaseUser(supabase.User supabaseUser) {
    final metadata = supabaseUser.userMetadata ?? {};
    return User(
      id: supabaseUser.id,
      email: supabaseUser.email ?? '',
      displayName:
          metadata['display_name'] as String? ??
          metadata['full_name'] as String? ??
          metadata['name'] as String? ??
          '',
      createdAt:
          DateTime.tryParse(supabaseUser.createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(
            supabaseUser.updatedAt ?? '',
          ) ??
          DateTime.now(),
    );
  }
}
