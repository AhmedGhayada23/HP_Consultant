class ApplyNowJobInternshipState {
  final bool isLoading;
  final bool isSuccess;
  final bool confirmInfo;
  final bool allowReview;
  final String? errorMessage;

  ApplyNowJobInternshipState({
    this.isLoading = false,
    this.isSuccess = false,
    this.confirmInfo = false,
    this.allowReview = false,
    this.errorMessage,
  });

  ApplyNowJobInternshipState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? confirmInfo,
    bool? allowReview,
    String? errorMessage,
  }) {
    return ApplyNowJobInternshipState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      confirmInfo: confirmInfo ?? this.confirmInfo,
      allowReview: allowReview ?? this.allowReview,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
