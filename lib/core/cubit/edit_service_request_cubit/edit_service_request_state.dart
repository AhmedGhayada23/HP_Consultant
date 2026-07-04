class EditServiceRequestState {
  final bool loading;
  final bool success;
  final String? errorMessage;

  EditServiceRequestState({
    this.loading = false,
    this.success = false,
    this.errorMessage,
  });

  EditServiceRequestState copyWith({
    bool? loading,
    bool? success,
    String? errorMessage,
  }) {
    return EditServiceRequestState(
      loading: loading ?? this.loading,
      success: success ?? this.success,
      errorMessage: errorMessage,
    );
  }
}
