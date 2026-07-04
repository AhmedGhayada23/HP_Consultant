class JobProjectModel {
  final int id;
  final String? title;
  final String? company;
  final String? deadline;
  final String? status;
  final String? category;
  final String? jobTypeLabel;
  final String? budget;
  final String? description;
  final String? requestReference;
  final String? projectType;

  JobProjectModel({
    this.id = 0,
    this.title,
    this.company,
    this.deadline,
    this.status,
    this.category,
    this.jobTypeLabel,
    this.budget,
    this.description,
    this.requestReference,
    this.projectType,
  });

  factory JobProjectModel.fromJson(Map<String, dynamic> json) {
    final companyObj =
        json['company'] is Map ? Map<String, dynamic>.from(json['company']) : null;
    final categoryJson = json['category'];
    return JobProjectModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      company: companyObj?['name'] as String?,
      deadline: json['deadline_display'] ?? json['deadline'] ?? '',
      status: json['status_label'] ?? json['status'] ?? '',
      category: categoryJson is Map
          ? categoryJson['name'] as String?
          : categoryJson as String?,
      jobTypeLabel: json['job_type_label'] ?? '',
      budget: json['budget_display'] ?? '',
      description: json['description'] ?? json['description_excerpt'] ?? '',
      requestReference: json['request_reference'] as String?,
      projectType: json['project_type'] as String?,
    );
  }
}
