class UpdateJobState {
  final bool success;
  final bool isLoading;
  final String? errorMessage;
  final String? message;

  UpdateJobState(
      {this.success = false,
      this.isLoading = false,
      this.errorMessage,
      this.message});

  UpdateJobState copyWith(
      {bool? success, bool? isLoading, String? errorMessage, String? message}) {
    return UpdateJobState(
      success: success ?? this.success,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      message: message,
    );
  }
}
