// domain/usecases/get_recent_invoices_usecase.dart

import 'package:hb/core/data/models/recent_invoice_model.dart';
import 'package:hb/core/domain/repository/latest_project_remote_repository.dart';

class GetLatestProjectUsecase {
  final LatestProjectRemoteRepository repository;

  GetLatestProjectUsecase(this.repository);

  Future<List<RecentInvoiceModel>> call() {
    return repository.getLatestProject();
  }
}
