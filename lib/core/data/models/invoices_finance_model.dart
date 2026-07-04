class InvoicesFinanceModel {
  final String title;
  final String invoiceId;
  final String date;
  final String amount;
  final String status;
  final int statusId;

  InvoicesFinanceModel({
    required this.title,
    required this.invoiceId,
    required this.date,
    required this.amount,
    required this.status,
    required this.statusId,
  });
}
