class JobApplicationModel {
  final int id;
  final int applicationId;
  final String name;
  final String profssion;
  final String rate;
  final String experience;
  final String skills;
  final String appliedOn;
  final String status;
  final String statusColor;

  JobApplicationModel({
    this.id = 0,
    this.applicationId = 0,
    required this.name,
    required this.profssion,
    required this.rate,
    required this.experience,
    required this.skills,
    this.appliedOn = '',
    required this.status,
    this.statusColor = 'gray',
  });

  factory JobApplicationModel.fromJson(Map<String, dynamic> json) {
    final skillsRaw = json['skills'];
    return JobApplicationModel(
      id: json['id'] ?? 0,
      applicationId: json['application_id'] ?? 0,
      name: json['name'] ?? '',
      profssion: json['profession'] ?? '',
      rate: json['rate_per_hour'] ?? json['rate'] ?? '',
      experience: json['experience'] ?? '',
      skills: skillsRaw is List
          ? skillsRaw.map((e) => e.toString()).join(', ')
          : (skillsRaw?.toString() ?? ''),
      appliedOn: json['applied_on'] ?? '',
      status: json['status_label'] ?? json['status'] ?? '',
      statusColor: json['status_color'] ?? 'gray',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'application_id': applicationId,
      'name': name,
      'profession': profssion,
      'rate_per_hour': rate,
      'experience': experience,
      'skills': skills,
      'applied_on': appliedOn,
      'status': status,
      'status_color': statusColor,
    };
  }

  factory JobApplicationModel.empty() {
    return JobApplicationModel(
      name: 'name',
      profssion: 'profssion',
      rate: 'rate',
      experience: 'experience',
      skills: 'skills',
      status: 'status',
    );
  }
}

class JobApplicationsResult {
  final List<JobApplicationModel> items;
  final int currentPage;
  final int totalPages;
  final int total;
  final int perPage;

  JobApplicationsResult({
    required this.items,
    this.currentPage = 1,
    this.totalPages = 1,
    this.total = 0,
    this.perPage = 10,
  });
}
