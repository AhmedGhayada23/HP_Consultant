// lib/featuer/invoices_finance/data/datasources/invoices_remote_datasource.dart
import 'dart:async';
import 'package:hb/core/data/models/paymant_invoice_model.dart';

abstract class PaymantInvoiceDataSource {
  Future<List<PaymantInvoiceModel>> getInvoices();
}

class InvoicesRemoteDataSourceImpl extends PaymantInvoiceDataSource {
  @override
  Future<List<PaymantInvoiceModel>> getInvoices() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate API delay

    // Simulated data
    return [
      PaymantInvoiceModel(
        id: '1',
        title: 'ERP Rollout – Req. Phase',
        invoiceNumber: 'INV-2025-01',
        date: '15 Sept 2025',
        amount: 3000,
        paidOn: '15 Sept 2025',
        status: 'Paid',
      ),
      PaymantInvoiceModel(
        id: '2',
        title: 'Website Redesign Project',
        invoiceNumber: 'INV-2025-02',
        date: '02 Oct 2025',
        amount: 1500,
        paidOn: '05 Oct 2025',
        status: 'Pending',
      ),
    ];
  }
}
