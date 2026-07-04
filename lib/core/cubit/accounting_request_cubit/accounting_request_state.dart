// lib/featuer/user_home/accounting_clint_home/presentation/cubit/accounting_request_state.dart
import 'package:hb/core/data/models/accounting_request_model.dart';

class AccountingRequestState {
  final List<AccountingRequestModel>? data;
  final bool? loading;
  final String? errorMessage;

  AccountingRequestState({
    this.data,
    this.loading,
    this.errorMessage,
  });

  AccountingRequestState copyWith({
    List<AccountingRequestModel>? data,
    bool? loading,
    String? errorMessage,
  }) {
    return AccountingRequestState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
