class UploadFileState {
  final bool isLoading;
  final bool? success;
  final String? errorMessage;

  UploadFileState({this.isLoading = false, this.success, this.errorMessage});

  UploadFileState copyWith({
    bool? isLoading,
    bool? success,
    String? errorMessage,
  }) {
    return UploadFileState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
