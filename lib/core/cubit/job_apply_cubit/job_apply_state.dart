class JobApplyState {
  final bool? success;
  final bool? loading;
  final bool confirmInfo;
  final bool allowReview;
  final String? errorMessage;

  JobApplyState({
    this.success,
    this.loading,
    this.confirmInfo = false,
    this.allowReview = false,
    this.errorMessage,
  });

  JobApplyState copyWith({
    bool? success,
    bool? loading,
    bool? confirmInfo,
    bool? allowReview,
    String? errorMessage,
  }) {
    return JobApplyState(
      success: success ?? this.success,
      loading: loading ?? this.loading,
      allowReview: allowReview ?? this.allowReview,
      confirmInfo: confirmInfo ?? this.confirmInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
