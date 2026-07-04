class AuthSignupState {
  final bool success;
  final bool loading;
  final bool termsAccepted;
  final String? errorMessage;
  final bool imagePicked;
  final bool cvPicked;

  AuthSignupState({
    this.success = false,
    this.loading = false,
    this.termsAccepted = false,
    this.errorMessage,
    this.imagePicked = false,
    this.cvPicked = false,
  });

  AuthSignupState copyWith({
    bool? success,
    bool? loading,
    bool? termsAccepted,
    String? errorMessage,
    bool? imagePicked,
    bool? cvPicked,
  }) {
    return AuthSignupState(
      success: success ?? this.success,
      loading: loading ?? this.loading,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      errorMessage: errorMessage ?? this.errorMessage,
      imagePicked: imagePicked ?? this.imagePicked,
      cvPicked: cvPicked ?? this.cvPicked,
    );
  }
}
