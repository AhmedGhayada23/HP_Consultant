import 'package:hb/core/data/models/report_invoice_model.dart';
import 'package:hb/core/domain/repository/invoices_finance_repository.dart';

class GetInvoicesFinanceUsecase {
  final InvoicesFinanceRepository repository;
  GetInvoicesFinanceUsecase(this.repository);

  Future<List<ReportInvoiceModel>> call({
    String? search,
    String? invoiceType,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) async {
    return await repository.getReports(
      search: search,
      status: status,
      dateFrom: dateFrom,
      dateTo: dateTo,
      invoiceType: invoiceType,
    );
  }
}
