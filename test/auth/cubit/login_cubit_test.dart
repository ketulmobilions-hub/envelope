import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('LoginCubit', () {
    late MockAuthRepository authRepository;

    setUp(() {
      authRepository = MockAuthRepository();
    });

    test('initial state is LoginState with initial status', () async {
      final cubit = LoginCubit(authRepository: authRepository);
      expect(cubit.state, equals(const LoginState()));
      await cubit.close();
    });

    group('signInWithEmailAndPassword', () {
      blocTest<LoginCubit, LoginState>(
        'emits [submitting, success] on successful sign in',
        setUp: () {
          when(
            () => authRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async {});
        },
        build: () => LoginCubit(authRepository: authRepository),
        act: (cubit) => cubit.signInWithEmailAndPassword(
          email: 'test@test.com',
          password: 'password',
        ),
        expect: () => [
          const LoginState(status: LoginStatus.submitting),
          const LoginState(status: LoginStatus.success),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submitting, failure] on AuthException',
        setUp: () {
          when(
            () => authRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(
            const SignInWithEmailAndPasswordException('Invalid credentials'),
          );
        },
        build: () => LoginCubit(authRepository: authRepository),
        act: (cubit) => cubit.signInWithEmailAndPassword(
          email: 'test@test.com',
          password: 'wrong',
        ),
        expect: () => [
          const LoginState(status: LoginStatus.submitting),
          const LoginState(
            status: LoginStatus.failure,
            errorMessage: 'Invalid credentials',
          ),
        ],
      );
    });

    group('signInWithGoogle', () {
      blocTest<LoginCubit, LoginState>(
        'emits [submitting, success] on successful Google sign in',
        setUp: () {
          when(
            () => authRepository.signInWithGoogle(),
          ).thenAnswer((_) async {});
        },
        build: () => LoginCubit(authRepository: authRepository),
        act: (cubit) => cubit.signInWithGoogle(),
        expect: () => [
          const LoginState(status: LoginStatus.submitting),
          const LoginState(status: LoginStatus.success),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submitting, failure] when Google sign in fails',
        setUp: () {
          when(() => authRepository.signInWithGoogle()).thenThrow(
            const SignInWithGoogleException('Cancelled'),
          );
        },
        build: () => LoginCubit(authRepository: authRepository),
        act: (cubit) => cubit.signInWithGoogle(),
        expect: () => [
          const LoginState(status: LoginStatus.submitting),
          const LoginState(
            status: LoginStatus.failure,
            errorMessage: 'Cancelled',
          ),
        ],
      );
    });

    group('signInWithApple', () {
      blocTest<LoginCubit, LoginState>(
        'emits [submitting, success] on successful Apple sign in',
        setUp: () {
          when(() => authRepository.signInWithApple()).thenAnswer((_) async {});
        },
        build: () => LoginCubit(authRepository: authRepository),
        act: (cubit) => cubit.signInWithApple(),
        expect: () => [
          const LoginState(status: LoginStatus.submitting),
          const LoginState(status: LoginStatus.success),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submitting, failure] when Apple sign in fails',
        setUp: () {
          when(() => authRepository.signInWithApple()).thenThrow(
            const SignInWithAppleException('Failed'),
          );
        },
        build: () => LoginCubit(authRepository: authRepository),
        act: (cubit) => cubit.signInWithApple(),
        expect: () => [
          const LoginState(status: LoginStatus.submitting),
          const LoginState(
            status: LoginStatus.failure,
            errorMessage: 'Failed',
          ),
        ],
      );
    });
  });
}
