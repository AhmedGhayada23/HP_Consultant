class RecentInvoiceModel {
  final String title;
  final String date;
  final String amount;
  final String status;
  final int statusId;

  RecentInvoiceModel({
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
    required this.statusId,
  });
}
