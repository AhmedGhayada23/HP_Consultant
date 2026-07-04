class HbLabProjectModel {
  final int? id;
  final String? publicCode;
  final String? title;
  final String? category;
  final String? deadline;
  final String? budget;
  final String? status;
  final String? statusRaw;

  HbLabProjectModel({
    this.id,
    this.publicCode,
    this.title,
    this.category,
    this.deadline,
    this.budget,
    this.status,
    this.statusRaw,
  });

  factory HbLabProjectModel.fromJson(Map<String, dynamic> json) {
    return HbLabProjectModel(
      id: json['id'] as int?,
      publicCode: json['public_code'] as String?,
      title: json['title'] as String?,
      category: json['category'] as String?,
      deadline: json['deadline_display'] as String?,
      budget: json['budget_display'] as String?,
      status: json['status_label'] as String?,
      statusRaw: json['status'] as String?,
    );
  }

  factory HbLabProjectModel.fake() {
    return HbLabProjectModel(
      id: 1,
      publicCode: 'PR0001',
      title: 'AI Chatbot For SMEs',
      category: 'Artificial Intelligence',
      deadline: '03 Jul 2026',
      budget: '€20,000',
      status: 'Open',
      statusRaw: 'open',
    );
  }
}

class HbLabProjectPageResponse {
  final List<HbLabProjectModel> projects;
  final int currentPage;
  final int lastPage;
  final int total;

  HbLabProjectPageResponse({
    required this.projects,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}
