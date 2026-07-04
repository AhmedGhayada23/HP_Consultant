// lib/featuer/reports_invoices/presentation/cubit/report_invoice_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/report_invoice_cubit/report_invoice_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ReportInvoiceCubit extends Cubit<ReportInvoiceState> {
  ReportInvoiceCubit() : super(ReportInvoiceState(loading: false));

  Future<void> fetchReports({
    String? search,
    String? invoiceType,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.getReportInvoiceUsecase(
        search: search,
        invoiceType: invoiceType,
        status: status,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
