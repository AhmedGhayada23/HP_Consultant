// lib/featuer/reports_invoices/data/models/report_invoice_model.dart

class ReportInvoiceModel {
  final String? id;
  final String? title;
  final String? invoiceNumber;
  final String? date;
  final String? dateDisplay;
  final double? amount;
  final String? amountDisplay;
  final String? status;
  final String? statusLabel;
  final String? dueDate;

  ReportInvoiceModel({
    this.id,
    this.title,
    this.invoiceNumber,
    this.date,
    this.dateDisplay,
    this.amount,
    this.amountDisplay,
    this.status,
    this.statusLabel,
    this.dueDate,
  });

  factory ReportInvoiceModel.fromJson(Map<String, dynamic> json) {
    return ReportInvoiceModel(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      invoiceNumber: json['invoice_number'] ?? '', // ✅ Fix: was 'invoiceNumber'
      date: json['date'] ?? '',
      dateDisplay: json['date_display'] ?? '',
      amount: (json['amount'] as num?)?.toDouble(), // ✅ Fix: was String
      amountDisplay: json['amount_display'] ?? '',
      status: json['status'] ?? '',
      statusLabel: json['status_label'] ?? '',
      dueDate: json['due_date'] ?? '',
    );
  }
  factory ReportInvoiceModel.fake() {
    return ReportInvoiceModel(
      id : '0',
      title: 'title',
      invoiceNumber: 'invoiceNumber',
      date: 'date',
      dateDisplay: 'dateDisplay',
      amount: 0,
      amountDisplay: 'amountDisplay',
      status: 'status',
      statusLabel: 'statusLabel',
      dueDate: 'dueDate',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'invoice_number': invoiceNumber,
      'date': date,
      'date_display': dateDisplay,
      'amount': amount,
      'amount_display': amountDisplay,
      'status': status,
      'status_label': statusLabel,
      'due_date': dueDate,
    };
  }
}
