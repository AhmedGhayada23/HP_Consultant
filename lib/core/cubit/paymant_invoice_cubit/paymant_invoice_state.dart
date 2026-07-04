// lib/featuer/invoices_finance/presentation/cubit/invoices_state.dart
import 'package:hb/core/data/models/paymant_invoice_model.dart';

class PaymantInvoiceState {
  final List<PaymantInvoiceModel>? data;
  final bool? loading;
  final String? errorMessage;

  PaymantInvoiceState({
    this.data,
    this.loading,
    this.errorMessage,
  });

  PaymantInvoiceState copyWith({
    List<PaymantInvoiceModel>? data,
    bool? loading,
    String? errorMessage,
  }) {
    return PaymantInvoiceState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
