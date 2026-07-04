class BoostProjectState {
  final bool loading;
  final bool success;
  final String? errorMessage;

  BoostProjectState({
    this.loading = false,
    this.success = false,
    this.errorMessage,
  });

  BoostProjectState copyWith({
    bool? loading,
    bool? success,
    String? errorMessage,
  }) {
    return BoostProjectState(
      loading: loading ?? this.loading,
      success: success ?? this.success,
      errorMessage: errorMessage,
    );
  }
}
