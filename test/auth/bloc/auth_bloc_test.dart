import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('AuthBloc', () {
    late MockAuthRepository authRepository;
    late StreamController<User> userController;

    final testUser = User(
      id: 'user-123',
      email: 'test@test.com',
      displayName: 'Test User',
      createdAt: DateTime(2024),
      updatedAt: DateTime(2024),
    );

    setUp(() {
      authRepository = MockAuthRepository();
      userController = StreamController<User>();
      when(() => authRepository.user)
          .thenAnswer((_) => userController.stream);
    });

    tearDown(() async {
      await userController.close();
    });

    test('initial state is AuthState.unknown', () async {
      final bloc = AuthBloc(authRepository: authRepository);
      expect(bloc.state, equals(const AuthState.unknown()));
      await bloc.close();
    });

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when user stream emits User.empty',
      build: () => AuthBloc(authRepository: authRepository),
      act: (bloc) => userController.add(User.empty),
      expect: () => [const AuthState.unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [authenticated] when user stream emits a valid user',
      build: () => AuthBloc(authRepository: authRepository),
      act: (bloc) => userController.add(testUser),
      expect: () => [AuthState.authenticated(testUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [authenticated, unauthenticated] on sign out flow',
      build: () => AuthBloc(authRepository: authRepository),
      act: (bloc) {
        userController
          ..add(testUser)
          ..add(User.empty);
      },
      expect: () => [
        AuthState.authenticated(testUser),
        const AuthState.unauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'calls authRepository.signOut on AuthSignOutRequested',
      setUp: () {
        when(() => authRepository.signOut()).thenAnswer((_) async {});
      },
      build: () => AuthBloc(authRepository: authRepository),
      act: (bloc) => bloc.add(const AuthSignOutRequested()),
      verify: (_) {
        verify(() => authRepository.signOut()).called(1);
      },
    );
  });
}
