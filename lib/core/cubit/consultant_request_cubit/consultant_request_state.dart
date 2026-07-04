class ConsultantRequestState {
  final bool? success;
  final bool? loading;
  final String? errorMessage;

  ConsultantRequestState({this.success, this.loading, this.errorMessage});

  ConsultantRequestState copyWith({
   bool? success,
   bool? loading,
   String? errorMessage,
  }) {
    return ConsultantRequestState(
      success: success ??  this.success,
      loading: loading ?? this.loading,
      errorMessage:  errorMessage ?? this.errorMessage,
    );
  }
}
