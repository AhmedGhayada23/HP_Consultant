class AddProjectState {
  final bool? success;
  final bool? loading;
  final String? errorMessage;


  AddProjectState({
    this.success,
    this.loading,
    this.errorMessage
  });


  AddProjectState copyWith({
   bool? success,
   bool? loading,
   String? errorMessage,
  }){
    return AddProjectState(
      success:  success ?? this.success,
      loading: loading ?? this.loading,
      errorMessage:  errorMessage ?? this.errorMessage,
    );
  }
}
