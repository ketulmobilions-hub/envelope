part of 'sign_up_cubit.dart';

enum SignUpStatus { initial, submitting, success, failure }

final class SignUpState extends Equatable {
  const SignUpState({
    this.status = SignUpStatus.initial,
    this.errorMessage,
  });

  final SignUpStatus status;
  final String? errorMessage;

  SignUpState copyWith({
    SignUpStatus? status,
    String? errorMessage,
  }) {
    return SignUpState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
