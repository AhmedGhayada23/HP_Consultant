import 'package:hb/core/data/models/invoices_finance_model.dart';
import 'package:hb/core/data/models/report_invoice_model.dart';

class InvoicesFinanceState {
  final bool isLoading;
  final String? errorMessage;
  final List<ReportInvoiceModel>? invoicesFinanceList;

  InvoicesFinanceState({
    this.isLoading = false,
    this.errorMessage,
    this.invoicesFinanceList,
  });

  InvoicesFinanceState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ReportInvoiceModel>? invoicesFinanceList,
  }) {
    return InvoicesFinanceState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      invoicesFinanceList: invoicesFinanceList ?? this.invoicesFinanceList,
    );
  }
}
