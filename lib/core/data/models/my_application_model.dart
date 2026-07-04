// lib/featuer/career_opportunities/data/models/my_application_model.dart

class MyApplicationModel {
  final String? id;
  final String? title;
  final String? company;
  final String? dateApplied;
  final String? type;
  final String? status;

  MyApplicationModel({
    this.id,
    this.title,
    this.company,
    this.dateApplied,
    this.type,
    this.status,
  });

  factory MyApplicationModel.fromJson(Map<String, dynamic> json) {
    return MyApplicationModel(
      id: json['id'].toString(),
      title: json['job_title'] ?? json['title'] ?? '',
      company: json['company_name'] ?? json['company'] ?? '',
      dateApplied: json['applied_at_display'] ?? json['applied_at'] ?? '',
      type: json['job_type_label'] ?? json['type'] ?? '',
      status: json['status_label'] ?? json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'dateApplied': dateApplied,
      'type': type,
      'status': status,
    };
  }
}
