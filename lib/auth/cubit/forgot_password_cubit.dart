import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const ForgotPasswordState());

  final AuthRepository _authRepository;

  Future<void> sendPasswordResetEmail({required String email}) async {
    emit(state.copyWith(status: ForgotPasswordStatus.submitting));
    try {
      await _authRepository.sendPasswordResetEmail(email: email);
      emit(state.copyWith(status: ForgotPasswordStatus.success));
    } on AuthException catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: 'An unexpected error occurred.',
        ),
      );
    }
  }
}
