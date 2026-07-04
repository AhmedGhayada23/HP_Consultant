class AuthSiginState {
  final bool? success;
  final bool? loading;
  final bool? remember;
  final String? errorMessage;

  AuthSiginState({this.success, this.loading, this.errorMessage, this.remember});

  AuthSiginState copyWith({bool? success, bool? loading, bool? remember, String? errorMessage}) {
    return AuthSiginState(
      success:  success ?? this.success,
      loading:  loading ?? this.loading,
      remember:  remember ?? this.remember,
      errorMessage:  errorMessage ?? this.errorMessage,
    );
  }
}
