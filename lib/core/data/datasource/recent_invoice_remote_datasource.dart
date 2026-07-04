// data/datasources/recent_invoice_remote_datasource.dart

import 'package:hb/core/data/models/recent_invoice_model.dart';

abstract class RecentInvoiceRemoteDataSource {
  Future<List<RecentInvoiceModel>> getRecentInvoices();
}

class RecentInvoiceRemoteDataSourceImpl implements RecentInvoiceRemoteDataSource {
  @override
  Future<List<RecentInvoiceModel>> getRecentInvoices() async {
    // محاكاة استجابة API
    await Future.delayed(Duration(seconds: 2));
    return [
      RecentInvoiceModel(
        title: 'John Doe – ERP Project',
        date: '07-03-2025',
        amount: '\$3,000',
        status: 'Paid',
        statusId: 1,
      ),
      RecentInvoiceModel(
        title: 'John Doe – ERP Project',
        date: '07-03-2025',
        amount: '\$3,000',
        status: 'Unpaid',
        statusId: 2,
      ),
      RecentInvoiceModel(
        title: 'John Doe – ERP Project',
        date: '07-03-2025',
        amount: '\$3,000',
        status: 'Unpaid',
        statusId: 3,
      ),
    ];
  }
}
