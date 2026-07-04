class ScheduleInterviewState {
  final bool isLoading;
  final bool? success;
  final String? errorMessage;

  ScheduleInterviewState({this.isLoading = false, this.success, this.errorMessage});

  ScheduleInterviewState copyWith({
    bool? isLoading,
    bool? success,
    String? errorMessage,
  }) {
    return ScheduleInterviewState(
      isLoading: isLoading ?? this.isLoading,
      success: success,
      errorMessage: errorMessage,
    );
  }
}
