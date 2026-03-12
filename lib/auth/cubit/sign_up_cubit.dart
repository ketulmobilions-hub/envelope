import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const SignUpState());

  final AuthRepository _authRepository;

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    emit(state.copyWith(status: SignUpStatus.submitting));
    try {
      await _authRepository.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
      emit(state.copyWith(status: SignUpStatus.success));
    } on AuthException catch (e) {
      emit(
        state.copyWith(
          status: SignUpStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: SignUpStatus.failure,
          errorMessage: 'An unexpected error occurred.',
        ),
      );
    }
  }
}
