// lib/featuer/invoices_finance/data/models/invoice_model.dart
// import 'package:equatable/equatable.dart';

class PaymantInvoiceModel{
  final String? id;
  final String? title;
  final String? invoiceNumber;
  final String? date;
  final double? amount;
  final String? paidOn;
  final String? status;

  const PaymantInvoiceModel({
     this.id,
     this.title,
     this.invoiceNumber,
     this.date,
     this.amount,
     this.paidOn,
     this.status,
  });

  factory PaymantInvoiceModel.fromJson(Map<String, dynamic> json) {
    return PaymantInvoiceModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      invoiceNumber: json['invoice_number'] ?? '',
      date: json['date'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      paidOn: json['paid_on'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'invoice_number': invoiceNumber,
        'date': date,
        'amount': amount,
        'paid_on': paidOn,
        'status': status,
      };

  @override
  List<Object?> get props => [id, title, invoiceNumber, date, amount, paidOn, status];
}
