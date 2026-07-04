import 'package:hb/core/data/models/report_invoice_model.dart';
import 'package:hb/core/domain/repository/report_invoice_repository.dart';

class ReportInvoiceUsecase {
  final ReportInvoiceRepository repository;

  ReportInvoiceUsecase(this.repository);

  Future<List<ReportInvoiceModel>> call({
    String? search,
    String? invoiceType,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) async {
    return await repository.getReports(
      search: search,
      invoiceType: invoiceType,
      status: status,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
  }
}
