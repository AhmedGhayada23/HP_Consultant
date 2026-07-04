class AuthOtpState {
  final bool? sentOtpSuccess;
  final bool? checkOtpSuccess;
  final bool? isCheckOtpLoading;
  final bool? isSentOtpLoading;
  final String? errorMessage;

  AuthOtpState({
    this.sentOtpSuccess,
    this.checkOtpSuccess,
    this.isCheckOtpLoading,
    this.isSentOtpLoading,
    this.errorMessage,
  });
  AuthOtpState copyWith({
    bool? sentOtpSuccess,
    bool? chekOtpSuccess,
    bool? isCheckOtpLoading,
    bool? isSentOtpLoading,
    bool? remember,
    String? errorMessage,
  }) {
    return AuthOtpState(
      sentOtpSuccess: sentOtpSuccess ?? this.sentOtpSuccess,
      isSentOtpLoading: isSentOtpLoading ?? this.isSentOtpLoading,
      checkOtpSuccess: checkOtpSuccess ?? checkOtpSuccess,
      isCheckOtpLoading: isCheckOtpLoading ?? this.isCheckOtpLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
