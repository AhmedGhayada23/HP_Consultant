// lib/featuer/reports_invoices/presentation/cubit/report_invoice_state.dart

import 'package:hb/core/data/models/report_invoice_model.dart';

class ReportInvoiceState {
  final List<ReportInvoiceModel>? data;
  final bool? loading;
  final String? errorMessage;

  ReportInvoiceState({
    this.data,
    this.loading,
    this.errorMessage,
  });

  ReportInvoiceState copyWith({
    List<ReportInvoiceModel>? data,
    bool? loading,
    String? errorMessage,
  }) {
    return ReportInvoiceState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
