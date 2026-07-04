// lib/featuer/invoices_finance/domain/repositories/invoices_repository.dart
import 'package:hb/core/data/datasource/paymant_invoice_data_source.dart';
import 'package:hb/core/data/models/paymant_invoice_model.dart';

abstract class PaymantInvoiceRepository {
  Future<List<PaymantInvoiceModel>> getInvoices();
}

class PaymantInvoiceRepositoryImpl extends PaymantInvoiceRepository {
  final PaymantInvoiceDataSource remoteDataSource;

  PaymantInvoiceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PaymantInvoiceModel>> getInvoices() async {
    return await remoteDataSource.getInvoices();
  }
}
