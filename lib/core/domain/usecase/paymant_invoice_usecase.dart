import 'package:hb/core/data/models/paymant_invoice_model.dart';
import 'package:hb/core/domain/repository/paymant_invoice_repository.dart';

class PaymantInvoiceUsecase {
  final PaymantInvoiceRepository repository;
  PaymantInvoiceUsecase(this.repository);

  Future<List<PaymantInvoiceModel>> call() async {
    return await repository.getInvoices();
  }
}
