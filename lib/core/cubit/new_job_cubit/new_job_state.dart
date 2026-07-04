class NewJobState {
  final bool? success;
  final bool? loading;
  final String? errorMassage;

  NewJobState({this.success, this.loading, this.errorMassage});

  NewJobState copyWith({bool? success, bool? loading, String? errorMassage}) {
    return NewJobState(
      success: success ?? this.success,
      loading: loading ?? this.loading,
      errorMassage: errorMassage ?? this.errorMassage,
    );
  }
}
