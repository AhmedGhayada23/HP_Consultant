class HbLabJoinState {
  final bool loading;
  final bool success;

  HbLabJoinState({this.loading = false, this.success = false});

  HbLabJoinState copyWith({bool? loading, bool? success}) {
    return HbLabJoinState(
      loading: loading ?? this.loading,
      success: success ?? this.success,
    );
  }
}
