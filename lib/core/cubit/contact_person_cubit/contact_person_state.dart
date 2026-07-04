class ContactPersonState {
  final bool? success;
  final bool? loading;
  final String? errorMassage;

  ContactPersonState({this.success, this.loading, this.errorMassage});

  ContactPersonState copyWith({bool? success, bool? loading, String? errorMassage}) {
    return ContactPersonState(
      success: success ?? this.success,
      loading: loading ?? this.loading,
      errorMassage: errorMassage ?? this.errorMassage,
    );
  }
}
