class RejectApplicationState {
  final bool isLoading;
  final bool? success;
  final String? errorMessage;

  RejectApplicationState({this.isLoading = false, this.success, this.errorMessage});

  RejectApplicationState copyWith({
    bool? isLoading,
    bool? success,
    String? errorMessage,
  }) {
    return RejectApplicationState(
      isLoading: isLoading ?? this.isLoading,
      success: success,
      errorMessage: errorMessage,
    );
  }
}
