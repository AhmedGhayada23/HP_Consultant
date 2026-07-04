// lib/featuer/invoices_finance/presentation/cubit/invoices_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/paymant_invoice_cubit/paymant_invoice_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class PaymantInvoiceCubit extends Cubit<PaymantInvoiceState> {
  PaymantInvoiceCubit() : super(PaymantInvoiceState());

  Future<void> fetchPaymantInvoice() async {
    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      final data = await UseCases.getPaymantInvoiceUsecase();
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
