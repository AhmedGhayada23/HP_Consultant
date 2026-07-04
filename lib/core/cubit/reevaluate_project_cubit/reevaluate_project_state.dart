class ReevaluateProjectState {
  final bool? success;
  final bool? loading;
  final String? errorMessage;

  ReevaluateProjectState({this.success, this.loading, this.errorMessage});

  ReevaluateProjectState copyWith({bool? success, bool? loading, String? errorMessage}) {
    return ReevaluateProjectState(
      success:  success ?? this.success,
      loading: loading ?? this.loading,
      errorMessage:  errorMessage ?? this.errorMessage,
    );
  }
}
