class ForgetPasswordState {
  final bool? isLoading;
  final String? errorMessage;

  ForgetPasswordState({this.isLoading, this.errorMessage});

  ForgetPasswordState copyWith({bool? isLoading, String? errorMessage}) {
    return ForgetPasswordState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
