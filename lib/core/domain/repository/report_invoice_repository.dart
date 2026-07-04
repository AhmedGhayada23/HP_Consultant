// lib/featuer/reports_invoices/domain/repositories/report_invoice_repository.dart

import 'package:hb/core/data/datasource/report_invoice_remote_datasource.dart';

import '../../data/models/report_invoice_model.dart';

abstract class ReportInvoiceRepository {
  Future<List<ReportInvoiceModel>> getReports({
    String? search,
    String? invoiceType,
    String? status,
    String? dateFrom,
    String? dateTo,
  });
}

class ReportInvoiceRepositoryImpl extends ReportInvoiceRepository {
  final ReportInvoiceRemoteDataSource remoteDataSource;

  ReportInvoiceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ReportInvoiceModel>> getReports({
    String? search,
    String? invoiceType,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) async {
    return await remoteDataSource.getReports(
      search: search,
      invoiceType: invoiceType,
      status: status,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
  }
}
