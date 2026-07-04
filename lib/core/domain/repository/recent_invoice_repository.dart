// domain/repositories/recent_invoice_repository.dart

import 'package:hb/core/data/datasource/recent_invoice_remote_datasource.dart';
import 'package:hb/core/data/models/recent_invoice_model.dart';

abstract class RecentInvoiceRepository {
  Future<List<RecentInvoiceModel>> getRecentInvoices();
}
class RecentInvoiceRepositoryImpl implements RecentInvoiceRepository {
  final RecentInvoiceRemoteDataSource remoteDataSource;

  RecentInvoiceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<RecentInvoiceModel>> getRecentInvoices() {
    return remoteDataSource.getRecentInvoices();
  }
}
