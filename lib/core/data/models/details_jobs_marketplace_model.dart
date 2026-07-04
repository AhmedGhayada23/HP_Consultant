class DetailsJobsMarketplaceModel {
  final int id;
  final String? title;
  final String? description;
  final String? jobTypeLabel;
  final String? status;
  final String? statusLabel;
  final String? companyLocation;
  final String? jobLocation;
  final String? budgetDisplay;
  final String? deadlineDisplay;
  final String? category;
  final String? companyName;
  final List<String> skills;
  final List<JobAttachment> projectFiles;

  DetailsJobsMarketplaceModel({
    this.id = 0,
    this.title,
    this.description,
    this.jobTypeLabel,
    this.status,
    this.statusLabel,
    this.companyLocation,
    this.jobLocation,
    this.budgetDisplay,
    this.deadlineDisplay,
    this.category,
    this.companyName,
    this.skills = const [],
    this.projectFiles = const [],
  });

  factory DetailsJobsMarketplaceModel.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from((json['data'] ?? json) as Map);
    final company =
        data['company'] is Map ? Map<String, dynamic>.from(data['company']) : null;
    final categoryJson = data['category'];
    return DetailsJobsMarketplaceModel(
      id: data['id'] ?? 0,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      jobTypeLabel: data['job_type_label'] ?? '',
      status: data['status'] ?? '',
      statusLabel: data['status_label'] ?? '',
      companyLocation: company?['location'] as String?,
      jobLocation: data['job_location'] as String?,
      budgetDisplay: data['budget_display'] ?? '',
      deadlineDisplay: data['deadline_display'] ?? data['deadline'] ?? '',
      category: categoryJson is Map
          ? categoryJson['name'] as String?
          : categoryJson as String?,
      companyName: company?['name'] as String?,
      skills: ((data['skills'] ?? data['required_skills']) as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      projectFiles: (data['attachments'] as List? ?? [])
          .map((e) => e is Map
              ? JobAttachment(
                  name: (e['name'] ?? e['file_name'] ?? '').toString(),
                  url: (e['url'] ?? e['file_url'] ?? e['path'] ?? '').toString(),
                )
              : JobAttachment(name: e.toString(), url: e.toString()))
          .where((a) => a.name.isNotEmpty || a.url.isNotEmpty)
          .toList(),
    );
  }

  factory DetailsJobsMarketplaceModel.fake() => DetailsJobsMarketplaceModel(
        id: 0,
        title: 'Backend API Developer',
        description: 'Looking for an experienced backend developer...',
        jobTypeLabel: 'Contract',
        status: 'active',
        statusLabel: 'Open',
        companyLocation: 'Luxembourg',
        jobLocation: 'Remote',
        budgetDisplay: '€5,000 - €10,000',
        deadlineDisplay: '30 Oct 2025',
        category: 'IT / Development',
        companyName: 'TechSolutions SARL',
        skills: ['Java', 'Spring Boot', 'Docker'],
        projectFiles: const [
          JobAttachment(name: 'ERP_Project_Plan.pdf', url: ''),
        ],
      );
}

class JobAttachment {
  final String name;
  final String url;

  const JobAttachment({this.name = '', this.url = ''});
}
