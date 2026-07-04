// data/datasources/recent_invoice_remote_datasource.dart

import 'package:hb/core/data/models/recent_invoice_model.dart';

abstract class LatestProjectRemoteDatasource {
  Future<List<RecentInvoiceModel>> getLatestProject();
}

class LatestProjectRemoteDatasourceImpl implements LatestProjectRemoteDatasource {
  @override
  Future<List<RecentInvoiceModel>> getLatestProject() async {
    // محاكاة استجابة API
    await Future.delayed(Duration(seconds: 2));
    return [
      RecentInvoiceModel(
        title: 'CRM API Migration',
        date: '07-03-2025',
        amount: 'Michael Lee',
        status: 'In Progress',
        statusId: 1,
      ),
    ];
  }
}
