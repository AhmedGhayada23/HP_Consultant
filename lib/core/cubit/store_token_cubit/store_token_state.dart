class StoreTokenState {
  final bool sent;
  final String? errorMessage;

  StoreTokenState({this.sent = false, this.errorMessage});

  StoreTokenState copyWith({bool? sent, String? errorMessage}) {
    return StoreTokenState(
      sent: sent ?? this.sent,
      errorMessage: errorMessage,
    );
  }
}
