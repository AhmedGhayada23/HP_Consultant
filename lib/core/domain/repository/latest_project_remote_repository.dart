// domain/repositories/recent_invoice_repository.dart

import 'package:hb/core/data/datasource/latest_project_remote_datasource.dart';
import 'package:hb/core/data/datasource/recent_invoice_remote_datasource.dart';
import 'package:hb/core/data/models/recent_invoice_model.dart';

abstract class LatestProjectRemoteRepository {
  Future<List<RecentInvoiceModel>> getLatestProject();
}
class LatestProjectRemoteRepositoryImpl implements LatestProjectRemoteRepository {
  final LatestProjectRemoteDatasource remoteDataSource;

  LatestProjectRemoteRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<RecentInvoiceModel>> getLatestProject() {
    return remoteDataSource.getLatestProject();
  }
}
