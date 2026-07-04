class NewIdeaState {
  final bool loading;
  final bool success;
  final String? errorMessage;

  NewIdeaState({
    this.loading = false,
    this.success = false,
    this.errorMessage,
  });

  NewIdeaState copyWith({
    bool? loading,
    bool? success,
    String? errorMessage,
  }) {
    return NewIdeaState(
      loading: loading ?? this.loading,
      success: success ?? this.success,
      errorMessage: errorMessage,
    );
  }
}
