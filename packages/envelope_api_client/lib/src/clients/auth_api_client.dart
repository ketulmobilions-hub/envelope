import 'package:supabase_flutter/supabase_flutter.dart';

/// API client for authentication operations using Supabase Auth.
class AuthApiClient {
  /// Creates an [AuthApiClient] with the given [SupabaseClient].
  const AuthApiClient({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  /// Returns the Supabase [GoTrueClient] for direct auth operations.
  GoTrueClient get auth => _supabaseClient.auth;

  /// Stream that emits on auth state changes.
  Stream<AuthState> get onAuthStateChange =>
      _supabaseClient.auth.onAuthStateChange;

  /// Returns the currently authenticated Supabase user, or `null`.
  User? get currentUser => _supabaseClient.auth.currentUser;

  /// Signs up with [email] and [password].
  ///
  /// Optionally accepts a [displayName] to store in user metadata.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return _supabaseClient.auth.signUp(
      email: email,
      password: password,
      data: displayName != null ? {'display_name': displayName} : null,
    );
  }

  /// Signs in with [email] and [password].
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    return _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Signs in with a Google ID token (for native Google Sign-In).
  Future<AuthResponse> signInWithGoogleIdToken({
    required String idToken,
    String? accessToken,
  }) async {
    return _supabaseClient.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  /// Signs in with Apple credentials (for native Apple Sign-In).
  Future<AuthResponse> signInWithAppleIdToken({
    required String idToken,
    String? nonce,
  }) async {
    return _supabaseClient.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: nonce,
    );
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  /// Sends a password reset email to [email].
  Future<void> resetPasswordForEmail(String email) async {
    await _supabaseClient.auth.resetPasswordForEmail(email);
  }

  /// Resends the email verification to the current user's email.
  Future<ResendResponse> resendEmailVerification(String email) async {
    return _supabaseClient.auth.resend(
      type: OtpType.signup,
      email: email,
    );
  }

  /// Refreshes the current session.
  Future<AuthResponse> refreshSession() async {
    return _supabaseClient.auth.refreshSession();
  }
}
