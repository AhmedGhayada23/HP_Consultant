class JobOpportunityDetailsModel {
  final int id;
  final String? title;
  final String? description;
  final List<String> responsibilities;
  final List<String> requirements;
  final List<String> benefits;
  final String? jobTypeLabel;
  final String? stipend;
  final String? duration;
  final String? location;
  final String? jobLocation;
  final String? companyLocation;
  final String? startDateDisplay;
  final String? deadlineDisplay;
  final String? budgetDisplay;
  final String? companyName;
  final List<String> requiredSkills;
  final List<JobOpportunityAttachment> attachments;
  final bool alreadyApplied;
  final bool meetsRequirement;

  JobOpportunityDetailsModel({
    this.id = 0,
    this.title,
    this.description,
    this.responsibilities = const [],
    this.requirements = const [],
    this.benefits = const [],
    this.jobTypeLabel,
    this.stipend,
    this.duration,
    this.location,
    this.jobLocation,
    this.companyLocation,
    this.startDateDisplay,
    this.deadlineDisplay,
    this.budgetDisplay,
    this.companyName,
    this.requiredSkills = const [],
    this.attachments = const [],
    this.alreadyApplied = false,
    this.meetsRequirement = false,
  });

  factory JobOpportunityDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : json;
    final company = data['company'] is Map
        ? Map<String, dynamic>.from(data['company'])
        : null;

    List<String> strList(dynamic v) =>
        (v as List? ?? []).map((e) => e.toString()).toList();

    return JobOpportunityDetailsModel(
      id: data['id'] ?? 0,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      responsibilities: strList(data['responsibilities']),
      requirements: strList(data['requirements']),
      benefits: strList(data['benefits']),
      jobTypeLabel: data['job_type_label'] as String?,
      stipend: data['stipend_label'] as String?,
      duration: data['duration_label'] as String?,
      location: data['location'] as String?,
      jobLocation: data['job_location'] as String?,
      companyLocation: data['company_location_label'] as String?,
      startDateDisplay: data['role_start_date_display'] as String?,
      deadlineDisplay: data['deadline_display'] as String?,
      budgetDisplay: data['budget_display'] as String?,
      companyName: company?['name'] as String?,
      requiredSkills: strList(data['required_skills']),
      attachments: (data['attachments'] as List? ?? [])
          .map((e) =>
              JobOpportunityAttachment.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      alreadyApplied: data['already_applied'] ?? false,
      meetsRequirement: data['meets_requirement'] ?? false,
    );
  }
}

class JobOpportunityAttachment {
  final int id;
  final String fileName;
  final String typeLabel;
  final String? downloadUrl;

  JobOpportunityAttachment({
    this.id = 0,
    this.fileName = '',
    this.typeLabel = '',
    this.downloadUrl,
  });

  factory JobOpportunityAttachment.fromJson(Map<String, dynamic> json) {
    return JobOpportunityAttachment(
      id: json['id'] ?? 0,
      fileName: json['file_name'] ?? json['name'] ?? '',
      typeLabel: json['type_label'] ?? 'File',
      downloadUrl: json['download_url'] ?? json['url'],
    );
  }
}
