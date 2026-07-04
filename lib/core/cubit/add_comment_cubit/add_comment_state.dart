class AddCommentState {
  final bool loading;
  final bool success;
  final String? errorMessage;

  AddCommentState({
    this.loading = false,
    this.success = false,
    this.errorMessage,
  });

  AddCommentState copyWith({
    bool? loading,
    bool? success,
    String? errorMessage,
  }) {
    return AddCommentState(
      loading: loading ?? this.loading,
      success: success ?? this.success,
      errorMessage: errorMessage,
    );
  }
}
