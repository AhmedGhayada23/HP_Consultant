import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/recent_invoice_cubit/recent_invoice_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class RecentInvoiceCubit extends Cubit<RecentInvoiceState> {
  RecentInvoiceCubit() : super(RecentInvoiceState());


 Future<void> fetchRecentInvoices() async {
    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      final invoices = await UseCases.getRecentInvoicesUseCase();
      emit(state.copyWith(
        recentInvoiceData: invoices,
        loading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
