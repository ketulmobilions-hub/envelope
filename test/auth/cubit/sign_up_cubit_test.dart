import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('SignUpCubit', () {
    late MockAuthRepository authRepository;

    setUp(() {
      authRepository = MockAuthRepository();
    });

    test('initial state is SignUpState with initial status', () async {
      final cubit = SignUpCubit(authRepository: authRepository);
      expect(cubit.state, equals(const SignUpState()));
      await cubit.close();
    });

    blocTest<SignUpCubit, SignUpState>(
      'emits [submitting, success] on successful sign up',
      setUp: () {
        when(
          () => authRepository.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenAnswer((_) async {});
      },
      build: () => SignUpCubit(authRepository: authRepository),
      act: (cubit) => cubit.signUp(
        email: 'test@test.com',
        password: 'password123',
        displayName: 'Test User',
      ),
      expect: () => [
        const SignUpState(status: SignUpStatus.submitting),
        const SignUpState(status: SignUpStatus.success),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits [submitting, failure] on AuthException',
      setUp: () {
        when(
          () => authRepository.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenThrow(
          const SignUpWithEmailAndPasswordException('Already registered'),
        );
      },
      build: () => SignUpCubit(authRepository: authRepository),
      act: (cubit) => cubit.signUp(
        email: 'test@test.com',
        password: 'password123',
        displayName: 'Test User',
      ),
      expect: () => [
        const SignUpState(status: SignUpStatus.submitting),
        const SignUpState(
          status: SignUpStatus.failure,
          errorMessage: 'Already registered',
        ),
      ],
    );
  });
}
