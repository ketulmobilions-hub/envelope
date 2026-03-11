import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('ForgotPasswordCubit', () {
    late MockAuthRepository authRepository;

    setUp(() {
      authRepository = MockAuthRepository();
    });

    test('initial state is ForgotPasswordState with initial status', () async {
      final cubit = ForgotPasswordCubit(authRepository: authRepository);
      expect(cubit.state, equals(const ForgotPasswordState()));
      await cubit.close();
    });

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'emits [submitting, success] on successful password reset',
      setUp: () {
        when(
          () => authRepository.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).thenAnswer((_) async {});
      },
      build: () =>
          ForgotPasswordCubit(authRepository: authRepository),
      act: (cubit) =>
          cubit.sendPasswordResetEmail(email: 'test@test.com'),
      expect: () => [
        const ForgotPasswordState(
          status: ForgotPasswordStatus.submitting,
        ),
        const ForgotPasswordState(
          status: ForgotPasswordStatus.success,
        ),
      ],
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'emits [submitting, failure] on AuthException',
      setUp: () {
        when(
          () => authRepository.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).thenThrow(
          const PasswordResetException('Rate limit exceeded'),
        );
      },
      build: () =>
          ForgotPasswordCubit(authRepository: authRepository),
      act: (cubit) =>
          cubit.sendPasswordResetEmail(email: 'test@test.com'),
      expect: () => [
        const ForgotPasswordState(
          status: ForgotPasswordStatus.submitting,
        ),
        const ForgotPasswordState(
          status: ForgotPasswordStatus.failure,
          errorMessage: 'Rate limit exceeded',
        ),
      ],
    );
  });
}
