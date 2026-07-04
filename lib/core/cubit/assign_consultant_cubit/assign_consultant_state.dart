class AssignConsultantState {
  final bool isLoading;
  final String? errorMessage;
  final bool success;

  AssignConsultantState({
    this.isLoading = false,
    this.errorMessage,
    this.success = false,
  });

  AssignConsultantState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? success,
  }) {
    return AssignConsultantState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      success: success ?? this.success,
    );
  }
}
