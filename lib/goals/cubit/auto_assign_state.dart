part of 'auto_assign_cubit.dart';

enum AutoAssignStatus {
  initial,
  planning,
  preview,
  applying,
  success,
  failure,
  noTargets,
  insufficientRta,
}

final class AutoAssignState extends Equatable {
  const AutoAssignState({
    this.status = AutoAssignStatus.initial,
    this.actions = const [],
    this.rtaCents = 0,
    this.errorMessage,
  });

  final AutoAssignStatus status;
  final List<AutoAssignAction> actions;
  final int rtaCents;
  final String? errorMessage;

  /// Total cents the preview would allocate across all actions.
  int get totalAllocatedCents =>
      actions.fold(0, (sum, a) => sum + a.addCents);

  AutoAssignState copyWith({
    AutoAssignStatus? status,
    List<AutoAssignAction>? actions,
    int? rtaCents,
    Object? errorMessage = _sentinel,
  }) {
    return AutoAssignState(
      status: status ?? this.status,
      actions: actions ?? this.actions,
      rtaCents: rtaCents ?? this.rtaCents,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [status, actions, rtaCents, errorMessage];
}
