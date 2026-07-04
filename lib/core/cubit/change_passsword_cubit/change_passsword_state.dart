class ChangePassswordState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  ChangePassswordState({this.isLoading = false, this.isSuccess = false, this.errorMessage});

  ChangePassswordState copyWith({bool? isLoading, bool? isSuccess, String? errorMessage}) {
    return ChangePassswordState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
