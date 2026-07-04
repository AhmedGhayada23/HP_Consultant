// lib/featuer/user_home/accounting_clint_home/data/models/accounting_request_model.dart

class AccountingRequestModel {
  final String? id;
  final String? title;
  final String? requestId;
  final String? dateSubmitted;
  final String? assignedTo;
  final String? budget;
  final String? status;

  AccountingRequestModel({
     this.id,
     this.title,
     this.requestId,
     this.dateSubmitted,
     this.assignedTo,
     this.budget,
     this.status,
  });

  factory AccountingRequestModel.fromJson(Map<String, dynamic> json) {
    return AccountingRequestModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      requestId: json['requestId'] ?? '',
      dateSubmitted: json['dateSubmitted'] ?? '',
      assignedTo: json['assignedTo'] ?? '',
      budget: json['budget'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'requestId': requestId,
      'dateSubmitted': dateSubmitted,
      'assignedTo': assignedTo,
      'budget': budget,
      'status': status,
    };
  }
}
