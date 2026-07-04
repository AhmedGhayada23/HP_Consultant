import 'package:hb/core/data/models/recent_invoice_model.dart';

class RecentInvoiceState {
  final List<RecentInvoiceModel>? recentInvoiceData;
  final bool loading;
  final String? errorMessage;

  RecentInvoiceState({
     this.recentInvoiceData,
     this.loading = false,
     this.errorMessage,
  });

  RecentInvoiceState copyWith({
    List<RecentInvoiceModel>? recentInvoiceData,
    bool? loading,
    String? errorMessage,
  }) {
    return RecentInvoiceState(
      recentInvoiceData: recentInvoiceData ?? this.recentInvoiceData,
      loading: loading ?? this.loading,
      errorMessage:  errorMessage ?? this.errorMessage,
    );
  }
}
