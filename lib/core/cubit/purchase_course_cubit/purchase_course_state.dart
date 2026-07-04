class PurchaseCourseState {
  final int? loadingCourseId; // ✅ ID العنصر اللي عم يشتري
  final String? errorMessage;
  final bool isSuccess;

  PurchaseCourseState({
    this.loadingCourseId,
    this.errorMessage,
    this.isSuccess = false,
  });

  bool isLoadingFor(int courseId) => loadingCourseId == courseId;

  PurchaseCourseState copyWith({
    int? loadingCourseId,
    bool clearLoading = false,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return PurchaseCourseState(
      loadingCourseId: clearLoading ? null : loadingCourseId ?? this.loadingCourseId,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
