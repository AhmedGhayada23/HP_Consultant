class JobDetailsModle {
  final int id;
  final String title;
  final String description;
  final String type;
  final String typeLabel;
  final String paymentType;
  final String paymentTypeLabel;
  final String? experienceLevel;
  final String? location;
  final String budgetMin;
  final String budgetMax;
  final String budgetDisplay;
  final String deadline;
  final String createdOn;
  final String status;
  final String statusLabel;
  final String statusColor;
  final List<String> requiredSkills;
  final String? projectType;
  final List<JobFileModel> files;
  final dynamic deliverables;
  final int applicantsCount;

  JobDetailsModle({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.typeLabel,
    required this.paymentType,
    required this.paymentTypeLabel,
    this.experienceLevel,
    this.location,
    required this.budgetMin,
    required this.budgetMax,
    required this.budgetDisplay,
    required this.deadline,
    required this.createdOn,
    required this.status,
    required this.statusLabel,
    required this.statusColor,
    required this.requiredSkills,
    this.projectType,
    this.files = const [],
    this.deliverables,
    required this.applicantsCount,
  });

  factory JobDetailsModle.fromJson(Map<String, dynamic> json) {
    return JobDetailsModle(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      typeLabel: json['type_label'],
      paymentType: json['payment_type'],
      paymentTypeLabel: json['payment_type_label'],
      experienceLevel: json['experience_level'],
      location: json['location'],
      budgetMin: json['budget_min'],
      budgetMax: json['budget_max'],
      budgetDisplay: json['budget_display'],
      deadline: json['deadline'],
      createdOn: json['created_on'],
      status: json['status'],
      statusLabel: json['status_label'],
      statusColor: json['status_color'],
      requiredSkills: List<String>.from(json['required_skills'] ?? []),
      projectType: json['project_type']?.toString(),
      files: (json['files'] as List? ?? [])
          .whereType<Map>()
          .map((e) => JobFileModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      deliverables: json['deliverables'],
      applicantsCount: json['applicants_count'] ?? 0,
    );
  }

  factory JobDetailsModle.fake() {
    return JobDetailsModle(
      id: 1,
      title: 'Sample Job Title',
      description: 'This is a sample job description.',
      type: 'fixed',
      typeLabel: 'Fixed Price',
      paymentType: 'hourly',
      paymentTypeLabel: 'Hourly',
      experienceLevel: 'Intermediate',
      location: 'Remote',
      budgetMin: '100',
      budgetMax: '500',
      budgetDisplay: '\$100 - \$500',
      deadline: '2024-12-31T23:59:59Z',
      createdOn: '2024-01-01T12:00:00Z',
      status: 'open',
      statusLabel: 'Open',
      statusColor: '#28a745',
      requiredSkills: ['Flutter', 'Dart', 'API Integration'],
      projectType: null,
      files: const [],
      deliverables: null,
      applicantsCount: 5,
    );
  }
}

class JobFileModel {
  final int id;
  final String name;
  final String url;
  final int size;

  JobFileModel({
    this.id = 0,
    this.name = '',
    this.url = '',
    this.size = 0,
  });

  factory JobFileModel.fromJson(Map<String, dynamic> json) {
    return JobFileModel(
      id: json['id'] ?? 0,
      name: (json['name'] ?? '').toString(),
      url: (json['url'] ?? '').toString(),
      size: json['size'] is int
          ? json['size']
          : int.tryParse('${json['size']}') ?? 0,
    );
  }
}
