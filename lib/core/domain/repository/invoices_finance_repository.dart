import 'package:hb/core/data/datasource/invoices_finance_remote_datasource.dart';
import 'package:hb/core/data/models/invoices_finance_model.dart';
import 'package:hb/core/data/models/report_invoice_model.dart';

abstract class InvoicesFinanceRepository {
  Future<List<ReportInvoiceModel>> getReports({
    String? search,
    String? invoiceType,
    String? status,
    String? dateFrom,
    String? dateTo,
  });
}

class InvoicesFinanceRepositoryImpl implements InvoicesFinanceRepository {
  final InvoicesFinanceRemoteDataSource remoteDataSource;
  InvoicesFinanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ReportInvoiceModel>> getReports({
    String? search,
    String? invoiceType,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) {
    return remoteDataSource.getReports(
      search: search,
      status: status,
      invoiceType: invoiceType,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
  }
}
