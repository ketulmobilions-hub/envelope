import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart'
    hide SignInWithAppleException;
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:test/test.dart';

class MockEnvelopeApiClient extends Mock implements EnvelopeApiClient {}

class MockAuthApiClient extends Mock implements AuthApiClient {}

class MockUsersApiClient extends Mock implements UsersApiClient {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockAppleCredentialProvider extends Mock {
  Future<AuthorizationCredentialAppleID> call({
    required List<AppleIDAuthorizationScopes> scopes,
  });
}

void main() {
  late MockEnvelopeApiClient apiClient;
  late MockAuthApiClient authApiClient;
  late MockUsersApiClient usersApiClient;
  late MockGoogleSignIn googleSignIn;
  late MockAppleCredentialProvider appleCredentialProvider;
  late AuthRepository authRepository;

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testDisplayName = 'Test User';
  const testUserId = 'user-123';

  setUpAll(() {
    registerFallbackValue(
      UserDto(
        id: '',
        email: '',
        displayName: '',
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      ),
    );
  });

  setUp(() {
    apiClient = MockEnvelopeApiClient();
    authApiClient = MockAuthApiClient();
    usersApiClient = MockUsersApiClient();
    googleSignIn = MockGoogleSignIn();
    appleCredentialProvider = MockAppleCredentialProvider();

    when(() => apiClient.auth).thenReturn(authApiClient);
    when(() => apiClient.users).thenReturn(usersApiClient);

    authRepository = AuthRepository(
      apiClient: apiClient,
      googleSignIn: googleSignIn,
      appleCredentialProvider: appleCredentialProvider.call,
    );
  });

  group('AuthRepository', () {
    group('user stream', () {
      test('emits User.empty when auth state has no session', () async {
        final controller = StreamController<supabase.AuthState>();
        when(
          () => authApiClient.onAuthStateChange,
        ).thenAnswer((_) => controller.stream);

        const authState = supabase.AuthState(
          supabase.AuthChangeEvent.signedOut,
          null,
        );

        final future = expectLater(
          authRepository.user,
          emits(User.empty),
        );

        controller.add(authState);
        await future;
      });

      test('emits mapped User when auth state has a session', () async {
        final controller = StreamController<supabase.AuthState>();
        when(
          () => authApiClient.onAuthStateChange,
        ).thenAnswer((_) => controller.stream);

        final mockUser = _createMockSupabaseUser(testUserId, testEmail);
        final session = supabase.Session(
          accessToken: 'token',
          tokenType: 'bearer',
          user: mockUser,
        );
        final authState = supabase.AuthState(
          supabase.AuthChangeEvent.signedIn,
          session,
        );

        // Return full profile from users table.
        when(
          () => usersApiClient.getUser(testUserId),
        ).thenAnswer((_) async => _createTestUserDto());

        final future = expectLater(
          authRepository.user,
          emits(
            isA<User>()
                .having((u) => u.id, 'id', testUserId)
                .having((u) => u.email, 'email', testEmail)
                .having((u) => u.displayName, 'displayName', testDisplayName),
          ),
        );

        controller.add(authState);
        await future;
      });

      test(
        'falls back to auth metadata when users table lookup fails',
        () async {
          final controller = StreamController<supabase.AuthState>();
          when(
            () => authApiClient.onAuthStateChange,
          ).thenAnswer((_) => controller.stream);

          final mockUser = _createMockSupabaseUser(testUserId, testEmail);
          final session = supabase.Session(
            accessToken: 'token',
            tokenType: 'bearer',
            user: mockUser,
          );
          final authState = supabase.AuthState(
            supabase.AuthChangeEvent.signedIn,
            session,
          );

          // Simulate users table lookup failure.
          when(() => usersApiClient.getUser(testUserId)).thenThrow(
            const EnvelopeApiException('Not found', statusCode: 404),
          );

          final future = expectLater(
            authRepository.user,
            emits(
              isA<User>()
                  .having((u) => u.id, 'id', testUserId)
                  .having((u) => u.email, 'email', testEmail),
            ),
          );

          controller.add(authState);
          await future;
        },
      );

      test('updates cachedUser on auth state change', () async {
        final controller = StreamController<supabase.AuthState>();
        when(
          () => authApiClient.onAuthStateChange,
        ).thenAnswer((_) => controller.stream);

        final mockUser = _createMockSupabaseUser(testUserId, testEmail);
        final session = supabase.Session(
          accessToken: 'token',
          tokenType: 'bearer',
          user: mockUser,
        );
        final authState = supabase.AuthState(
          supabase.AuthChangeEvent.signedIn,
          session,
        );

        when(
          () => usersApiClient.getUser(testUserId),
        ).thenAnswer((_) async => _createTestUserDto());

        // Listen so the stream processes.
        final completer = Completer<User>();
        authRepository.user.listen(completer.complete);
        controller.add(authState);
        await completer.future;

        expect(authRepository.currentUser.id, equals(testUserId));
      });
    });

    group('currentUser', () {
      test('returns User.empty initially', () {
        expect(authRepository.currentUser, equals(User.empty));
      });
    });

    group('signUp', () {
      test('calls auth signUp and creates user record', () async {
        final mockUser = _createMockSupabaseUser(testUserId, testEmail);
        final authResponse = supabase.AuthResponse(user: mockUser);

        when(
          () => authApiClient.signUp(
            email: testEmail,
            password: testPassword,
            displayName: testDisplayName,
          ),
        ).thenAnswer((_) async => authResponse);

        when(
          () => usersApiClient.createUser(any()),
        ).thenAnswer((_) async => _createTestUserDto());

        await authRepository.signUp(
          email: testEmail,
          password: testPassword,
          displayName: testDisplayName,
        );

        verify(
          () => authApiClient.signUp(
            email: testEmail,
            password: testPassword,
            displayName: testDisplayName,
          ),
        ).called(1);

        verify(() => usersApiClient.createUser(any())).called(1);
      });

      test(
        'throws SignUpWithEmailAndPasswordException when auth fails',
        () async {
          when(
            () => authApiClient.signUp(
              email: testEmail,
              password: testPassword,
              displayName: testDisplayName,
            ),
          ).thenThrow(
            const supabase.AuthException('User already registered'),
          );

          expect(
            () => authRepository.signUp(
              email: testEmail,
              password: testPassword,
              displayName: testDisplayName,
            ),
            throwsA(isA<SignUpWithEmailAndPasswordException>()),
          );
        },
      );

      test('throws when no user returned', () async {
        when(
          () => authApiClient.signUp(
            email: testEmail,
            password: testPassword,
            displayName: testDisplayName,
          ),
        ).thenAnswer((_) async => supabase.AuthResponse());

        expect(
          () => authRepository.signUp(
            email: testEmail,
            password: testPassword,
            displayName: testDisplayName,
          ),
          throwsA(isA<SignUpWithEmailAndPasswordException>()),
        );
      });

      test('throws when createUser (users table insert) fails', () async {
        final mockUser = _createMockSupabaseUser(testUserId, testEmail);
        final authResponse = supabase.AuthResponse(user: mockUser);

        when(
          () => authApiClient.signUp(
            email: testEmail,
            password: testPassword,
            displayName: testDisplayName,
          ),
        ).thenAnswer((_) async => authResponse);

        when(() => usersApiClient.createUser(any())).thenThrow(
          const EnvelopeApiException('Insert failed'),
        );

        expect(
          () => authRepository.signUp(
            email: testEmail,
            password: testPassword,
            displayName: testDisplayName,
          ),
          throwsA(
            isA<SignUpWithEmailAndPasswordException>().having(
              (e) => e.message,
              'message',
              'Insert failed',
            ),
          ),
        );
      });
    });

    group('signInWithEmailAndPassword', () {
      test('calls auth signInWithPassword', () async {
        final mockUser = _createMockSupabaseUser(testUserId, testEmail);
        final authResponse = supabase.AuthResponse(user: mockUser);

        when(
          () => authApiClient.signInWithPassword(
            email: testEmail,
            password: testPassword,
          ),
        ).thenAnswer((_) async => authResponse);

        await authRepository.signInWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        );

        verify(
          () => authApiClient.signInWithPassword(
            email: testEmail,
            password: testPassword,
          ),
        ).called(1);
      });

      test(
        'throws SignInWithEmailAndPasswordException when auth fails',
        () async {
          when(
            () => authApiClient.signInWithPassword(
              email: testEmail,
              password: testPassword,
            ),
          ).thenThrow(
            const supabase.AuthException('Invalid login credentials'),
          );

          expect(
            () => authRepository.signInWithEmailAndPassword(
              email: testEmail,
              password: testPassword,
            ),
            throwsA(isA<SignInWithEmailAndPasswordException>()),
          );
        },
      );
    });

    group('signInWithGoogle', () {
      test('throws SignInWithGoogleException when user cancels', () async {
        when(() => googleSignIn.signIn()).thenAnswer((_) async => null);

        expect(
          () => authRepository.signInWithGoogle(),
          throwsA(isA<SignInWithGoogleException>()),
        );
      });

      test('throws SignInWithGoogleException when no ID token', () async {
        final mockAccount = MockGoogleSignInAccount();
        final mockAuth = MockGoogleSignInAuthentication();

        when(() => googleSignIn.signIn()).thenAnswer((_) async => mockAccount);
        when(
          () => mockAccount.authentication,
        ).thenAnswer((_) async => mockAuth);
        when(() => mockAuth.idToken).thenReturn(null);

        expect(
          () => authRepository.signInWithGoogle(),
          throwsA(isA<SignInWithGoogleException>()),
        );
      });

      test('signs in with Google ID token and ensures user record', () async {
        final mockAccount = MockGoogleSignInAccount();
        final mockAuth = MockGoogleSignInAuthentication();
        final mockUser = _createMockSupabaseUser(testUserId, testEmail);
        final authResponse = supabase.AuthResponse(user: mockUser);

        when(() => googleSignIn.signIn()).thenAnswer((_) async => mockAccount);
        when(
          () => mockAccount.authentication,
        ).thenAnswer((_) async => mockAuth);
        when(() => mockAuth.idToken).thenReturn('google-id-token');
        when(() => mockAuth.accessToken).thenReturn('google-access-token');

        when(
          () => authApiClient.signInWithGoogleIdToken(
            idToken: 'google-id-token',
            accessToken: 'google-access-token',
          ),
        ).thenAnswer((_) async => authResponse);

        when(
          () => usersApiClient.getUser(testUserId),
        ).thenAnswer((_) async => _createTestUserDto());

        await authRepository.signInWithGoogle();

        verify(
          () => authApiClient.signInWithGoogleIdToken(
            idToken: 'google-id-token',
            accessToken: 'google-access-token',
          ),
        ).called(1);
      });

      test(
        'creates user record when getUser fails (new social user)',
        () async {
          final mockAccount = MockGoogleSignInAccount();
          final mockAuth = MockGoogleSignInAuthentication();
          final mockUser = _createMockSupabaseUser(testUserId, testEmail);
          final authResponse = supabase.AuthResponse(user: mockUser);

          when(
            () => googleSignIn.signIn(),
          ).thenAnswer((_) async => mockAccount);
          when(
            () => mockAccount.authentication,
          ).thenAnswer((_) async => mockAuth);
          when(() => mockAuth.idToken).thenReturn('google-id-token');
          when(() => mockAuth.accessToken).thenReturn('google-access-token');

          when(
            () => authApiClient.signInWithGoogleIdToken(
              idToken: 'google-id-token',
              accessToken: 'google-access-token',
            ),
          ).thenAnswer((_) async => authResponse);

          // getUser fails — user not in table yet.
          when(() => usersApiClient.getUser(testUserId)).thenThrow(
            const EnvelopeApiException('Not found', statusCode: 404),
          );
          when(
            () => usersApiClient.createUser(any()),
          ).thenAnswer((_) async => _createTestUserDto());

          await authRepository.signInWithGoogle();

          verify(() => usersApiClient.createUser(any())).called(1);
        },
      );
    });

    group('signInWithApple', () {
      test('signs in with Apple ID token and ensures user record', () async {
        final mockUser = _createMockSupabaseUser(testUserId, testEmail);
        final authResponse = supabase.AuthResponse(user: mockUser);

        when(
          () => appleCredentialProvider.call(
            scopes: any(named: 'scopes'),
          ),
        ).thenAnswer(
          (_) async => const AuthorizationCredentialAppleID(
            authorizationCode: 'auth-code',
            identityToken: 'apple-id-token',
            userIdentifier: 'apple-user-id',
            givenName: null,
            familyName: null,
            email: null,
            state: null,
          ),
        );

        when(
          () => authApiClient.signInWithAppleIdToken(
            idToken: 'apple-id-token',
            nonce: 'auth-code',
          ),
        ).thenAnswer((_) async => authResponse);

        when(
          () => usersApiClient.getUser(testUserId),
        ).thenAnswer((_) async => _createTestUserDto());

        await authRepository.signInWithApple();

        verify(
          () => authApiClient.signInWithAppleIdToken(
            idToken: 'apple-id-token',
            nonce: 'auth-code',
          ),
        ).called(1);
      });

      test(
        'throws SignInWithAppleException when identity token is null',
        () async {
          when(
            () => appleCredentialProvider.call(
              scopes: any(named: 'scopes'),
            ),
          ).thenAnswer(
            (_) async => const AuthorizationCredentialAppleID(
              authorizationCode: 'auth-code',
              userIdentifier: 'apple-user-id',
              givenName: null,
              familyName: null,
              email: null,
              identityToken: null,
              state: null,
            ),
          );

          expect(
            () => authRepository.signInWithApple(),
            throwsA(
              isA<SignInWithAppleException>().having(
                (e) => e.message,
                'message',
                'Failed to obtain Apple identity token.',
              ),
            ),
          );
        },
      );

      test('throws SignInWithAppleException when no user returned', () async {
        when(
          () => appleCredentialProvider.call(
            scopes: any(named: 'scopes'),
          ),
        ).thenAnswer(
          (_) async => const AuthorizationCredentialAppleID(
            authorizationCode: 'auth-code',
            identityToken: 'apple-id-token',
            userIdentifier: 'apple-user-id',
            givenName: null,
            familyName: null,
            email: null,
            state: null,
          ),
        );

        when(
          () => authApiClient.signInWithAppleIdToken(
            idToken: 'apple-id-token',
            nonce: 'auth-code',
          ),
        ).thenAnswer((_) async => supabase.AuthResponse());

        expect(
          () => authRepository.signInWithApple(),
          throwsA(isA<SignInWithAppleException>()),
        );
      });

      test(
        'throws SignInWithAppleException when Supabase auth fails',
        () async {
          when(
            () => appleCredentialProvider.call(
              scopes: any(named: 'scopes'),
            ),
          ).thenAnswer(
            (_) async => const AuthorizationCredentialAppleID(
              authorizationCode: 'auth-code',
              identityToken: 'apple-id-token',
              userIdentifier: 'apple-user-id',
              givenName: null,
              familyName: null,
              email: null,
              state: null,
            ),
          );

          when(
            () => authApiClient.signInWithAppleIdToken(
              idToken: 'apple-id-token',
              nonce: 'auth-code',
            ),
          ).thenThrow(
            const supabase.AuthException('Apple auth failed'),
          );

          expect(
            () => authRepository.signInWithApple(),
            throwsA(
              isA<SignInWithAppleException>().having(
                (e) => e.message,
                'message',
                'Apple auth failed',
              ),
            ),
          );
        },
      );

      test(
        'creates user record when getUser fails (new social user)',
        () async {
          final mockUser = _createMockSupabaseUser(testUserId, testEmail);
          final authResponse = supabase.AuthResponse(user: mockUser);

          when(
            () => appleCredentialProvider.call(
              scopes: any(named: 'scopes'),
            ),
          ).thenAnswer(
            (_) async => const AuthorizationCredentialAppleID(
              authorizationCode: 'auth-code',
              identityToken: 'apple-id-token',
              userIdentifier: 'apple-user-id',
              givenName: null,
              familyName: null,
              email: null,
              state: null,
            ),
          );

          when(
            () => authApiClient.signInWithAppleIdToken(
              idToken: 'apple-id-token',
              nonce: 'auth-code',
            ),
          ).thenAnswer((_) async => authResponse);

          when(() => usersApiClient.getUser(testUserId)).thenThrow(
            const EnvelopeApiException('Not found', statusCode: 404),
          );
          when(
            () => usersApiClient.createUser(any()),
          ).thenAnswer((_) async => _createTestUserDto());

          await authRepository.signInWithApple();

          verify(() => usersApiClient.createUser(any())).called(1);
        },
      );
    });

    group('signOut', () {
      test('signs out of Google and Supabase', () async {
        when(() => googleSignIn.signOut()).thenAnswer((_) async => null);
        when(() => authApiClient.signOut()).thenAnswer((_) async {});

        await authRepository.signOut();

        verify(() => authApiClient.signOut()).called(1);
        expect(authRepository.currentUser, equals(User.empty));
      });

      test('signs out of Supabase even if Google signOut fails', () async {
        when(() => googleSignIn.signOut()).thenThrow(Exception('fail'));
        when(() => authApiClient.signOut()).thenAnswer((_) async {});

        await authRepository.signOut();

        verify(() => authApiClient.signOut()).called(1);
      });

      test('throws SignOutException when Supabase signOut fails', () async {
        when(() => googleSignIn.signOut()).thenAnswer((_) async => null);
        when(() => authApiClient.signOut()).thenThrow(
          const supabase.AuthException('Sign out failed'),
        );

        expect(
          () => authRepository.signOut(),
          throwsA(isA<SignOutException>()),
        );
      });
    });

    group('sendPasswordResetEmail', () {
      test('calls auth resetPasswordForEmail', () async {
        when(
          () => authApiClient.resetPasswordForEmail(testEmail),
        ).thenAnswer((_) async {});

        await authRepository.sendPasswordResetEmail(email: testEmail);

        verify(() => authApiClient.resetPasswordForEmail(testEmail)).called(1);
      });

      test('throws PasswordResetException on failure', () async {
        when(() => authApiClient.resetPasswordForEmail(testEmail)).thenThrow(
          const supabase.AuthException('Rate limit exceeded'),
        );

        expect(
          () => authRepository.sendPasswordResetEmail(email: testEmail),
          throwsA(isA<PasswordResetException>()),
        );
      });
    });

    group('sendEmailVerification', () {
      test('calls auth resendEmailVerification', () async {
        final mockUser = _createMockSupabaseUser(testUserId, testEmail);
        when(() => authApiClient.currentUser).thenReturn(mockUser);
        when(
          () => authApiClient.resendEmailVerification(testEmail),
        ).thenAnswer((_) async => supabase.ResendResponse());

        await authRepository.sendEmailVerification();

        verify(
          () => authApiClient.resendEmailVerification(testEmail),
        ).called(1);
      });

      test(
        'throws EmailVerificationException when not authenticated',
        () async {
          when(() => authApiClient.currentUser).thenReturn(null);

          expect(
            () => authRepository.sendEmailVerification(),
            throwsA(isA<EmailVerificationException>()),
          );
        },
      );

      test('throws EmailVerificationException when email is null', () async {
        final mockUser = supabase.User(
          id: testUserId,
          appMetadata: {},
          userMetadata: {},
          aud: 'authenticated',
          createdAt: DateTime(2024).toIso8601String(),
        );
        when(() => authApiClient.currentUser).thenReturn(mockUser);

        expect(
          () => authRepository.sendEmailVerification(),
          throwsA(
            isA<EmailVerificationException>().having(
              (e) => e.message,
              'message',
              'No email address associated with this account.',
            ),
          ),
        );
      });

      test('throws EmailVerificationException when email is empty', () async {
        final mockUser = supabase.User(
          id: testUserId,
          appMetadata: {},
          userMetadata: {},
          aud: 'authenticated',
          email: '',
          createdAt: DateTime(2024).toIso8601String(),
        );
        when(() => authApiClient.currentUser).thenReturn(mockUser);

        expect(
          () => authRepository.sendEmailVerification(),
          throwsA(
            isA<EmailVerificationException>().having(
              (e) => e.message,
              'message',
              'No email address associated with this account.',
            ),
          ),
        );
      });
    });

    group('updateProfile', () {
      test('fetches current user, updates, and caches', () async {
        final mockUser = _createMockSupabaseUser(testUserId, testEmail);
        when(() => authApiClient.currentUser).thenReturn(mockUser);

        final existingDto = _createTestUserDto();
        when(
          () => usersApiClient.getUser(testUserId),
        ).thenAnswer((_) async => existingDto);
        when(
          () => usersApiClient.updateUser(any()),
        ).thenAnswer((_) async => existingDto);

        await authRepository.updateProfile(displayName: 'New Name');

        verify(() => usersApiClient.updateUser(any())).called(1);
        expect(authRepository.currentUser.displayName, equals('New Name'));
      });

      test('updates all profile fields correctly', () async {
        final mockUser = _createMockSupabaseUser(testUserId, testEmail);
        when(() => authApiClient.currentUser).thenReturn(mockUser);

        final existingDto = _createTestUserDto();
        when(
          () => usersApiClient.getUser(testUserId),
        ).thenAnswer((_) async => existingDto);
        when(
          () => usersApiClient.updateUser(any()),
        ).thenAnswer((_) async => existingDto);

        await authRepository.updateProfile(
          displayName: 'Updated Name',
          baseCurrency: 'EUR',
          themeMode: 'dark',
          accentColor: '#FF0000',
        );

        final cached = authRepository.currentUser;
        expect(cached.displayName, equals('Updated Name'));
        expect(cached.baseCurrency, equals('EUR'));
        expect(cached.themeMode, equals('dark'));
        expect(cached.accentColor, equals('#FF0000'));
      });

      test('throws UpdateProfileException when not authenticated', () async {
        when(() => authApiClient.currentUser).thenReturn(null);

        expect(
          () => authRepository.updateProfile(displayName: 'New Name'),
          throwsA(isA<UpdateProfileException>()),
        );
      });
    });

    group('exceptions', () {
      test('AuthException toString returns message', () {
        const exception = SignInWithEmailAndPasswordException(
          'Invalid credentials',
        );
        expect(exception.toString(), 'Invalid credentials');
      });

      test('each exception type is distinct', () {
        const signUp = SignUpWithEmailAndPasswordException('a');
        const signIn = SignInWithEmailAndPasswordException('a');
        const google = SignInWithGoogleException('a');
        const apple = SignInWithAppleException('a');
        const signOut = SignOutException('a');
        const reset = PasswordResetException('a');
        const verify = EmailVerificationException('a');
        const profile = UpdateProfileException('a');

        // All are AuthException subtypes.
        expect(signUp, isA<AuthException>());
        expect(signIn, isA<AuthException>());
        expect(google, isA<AuthException>());
        expect(apple, isA<AuthException>());
        expect(signOut, isA<AuthException>());
        expect(reset, isA<AuthException>());
        expect(verify, isA<AuthException>());
        expect(profile, isA<AuthException>());
      });
    });
  });
}

supabase.User _createMockSupabaseUser(String id, String email) {
  return supabase.User(
    id: id,
    appMetadata: {},
    userMetadata: {'display_name': 'Test User'},
    aud: 'authenticated',
    email: email,
    createdAt: DateTime(2024).toIso8601String(),
  );
}

UserDto _createTestUserDto() {
  return UserDto(
    id: 'user-123',
    email: 'test@example.com',
    displayName: 'Test User',
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );
}
