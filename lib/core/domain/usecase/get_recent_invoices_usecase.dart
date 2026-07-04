// domain/usecases/get_recent_invoices_usecase.dart

import 'package:hb/core/data/models/recent_invoice_model.dart';
import 'package:hb/core/domain/repository/recent_invoice_repository.dart';

class GetRecentInvoicesUseCase {
  final RecentInvoiceRepository repository;

  GetRecentInvoicesUseCase(this.repository);

  Future<List<RecentInvoiceModel>> call() {
    return repository.getRecentInvoices();
  }
}
