class RecommendedJobModel {
  final int id;
  final String? category;
  final String? title;
  final String? company;
  final String? deadline;
  final String? budget;
  final String? jobTypeLabel;
  final String? statusLabel;
  final String? descriptionExcerpt;

  RecommendedJobModel({
    this.id = 0,
    this.category,
    this.title,
    this.company,
    this.deadline,
    this.budget,
    this.jobTypeLabel,
    this.statusLabel,
    this.descriptionExcerpt,
  });

  factory RecommendedJobModel.fromJson(Map<String, dynamic> json) {
    final companyObj =
        json['company'] is Map ? Map<String, dynamic>.from(json['company']) : null;
    final categoryJson = json['category'];
    return RecommendedJobModel(
      id: json['id'] ?? 0,
      category: categoryJson is Map
          ? categoryJson['name'] as String?
          : categoryJson as String?,
      title: json['title'] ?? '',
      company: companyObj?['name'] as String?,
      deadline: json['deadline_display'] ?? json['deadline'] ?? '',
      budget: json['budget_display'] ?? json['budget'] ?? '',
      jobTypeLabel: json['job_type_label'] ?? '',
      statusLabel: json['status_label'] ?? '',
      descriptionExcerpt: json['description_excerpt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'title': title,
        'company': company,
        'deadline': deadline,
        'budget': budget,
        'job_type_label': jobTypeLabel,
        'status_label': statusLabel,
        'description_excerpt': descriptionExcerpt,
      };

  factory RecommendedJobModel.fake() => RecommendedJobModel(
        id: 0,
        category: 'IT / Development',
        title: 'Backend API Developer',
        company: 'TechSolutions SARL',
        deadline: '30 Oct 2025',
        budget: '€5,000',
        jobTypeLabel: 'Contract',
        statusLabel: 'Open',
        descriptionExcerpt: 'Looking for a skilled developer...',
      );
}

class JobsPageResponse {
  final List<RecommendedJobModel> jobs;
  final int currentPage;
  final int lastPage;
  final int total;

  const JobsPageResponse({
    required this.jobs,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}
