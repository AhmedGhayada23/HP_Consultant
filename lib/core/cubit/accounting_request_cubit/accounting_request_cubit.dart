// lib/featuer/user_home/accounting_clint_home/presentation/cubit/accounting_request_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/accounting_request_cubit/accounting_request_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class AccountingRequestCubit extends Cubit<AccountingRequestState> {

  AccountingRequestCubit() : super(AccountingRequestState(loading: false));

  Future<void> fetchAccountingRequest() async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.getAccountingRequestUsecase();
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
