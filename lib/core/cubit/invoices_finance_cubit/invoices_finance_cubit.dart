import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/invoices_finance_cubit/invoices_finance_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class InvoicesFinanceCubit extends Cubit<InvoicesFinanceState> {
  InvoicesFinanceCubit() : super(InvoicesFinanceState());

  Future<void> fetchInvoicesFinanceData({
    String? search,
    String? invoiceType,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final invoicesFinanceList = await UseCases.getInvoicesFinanceUsecase(

      );
      emit(state.copyWith(isLoading: false, invoicesFinanceList: invoicesFinanceList));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
