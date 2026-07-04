class DetailsProjectModel {
  final ProjectDetails? project;
  final List<AssignedConsultantModel> assignedConsultants;
  final List<ProjectMilestones> projectMilestones;
  final List<ProjectFiles> projectFiles;

  DetailsProjectModel({
    this.project,
    required this.assignedConsultants,
    required this.projectMilestones,
    required this.projectFiles,
  });

  factory DetailsProjectModel.fromJson(Map<String, dynamic> json) {
    return DetailsProjectModel(
      project: json['project'] != null ? ProjectDetails.fromJson(json['project']) : null,

      assignedConsultants: (json['assigned_consultants'] as List<dynamic>? ?? [])
          .map((e) => AssignedConsultantModel.fromJson(e as Map<String, dynamic>))
          .toList(),

      projectMilestones: (json['milestones'] as List<dynamic>? ?? [])
          .map((e) => ProjectMilestones.fromJson(e as Map<String, dynamic>))
          .toList(),

      projectFiles: (json['files'] as List<dynamic>? ?? [])
          .map((e) => ProjectFiles.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProjectDetails {
  final int id;
  final String title;
  final String deadline;
  final String status;
  final String statusLabel;
  final String budget;
  final String description;
  final String category;
  final String projectType;
  final String paymentType;
  final String priority;

  ProjectDetails({
    required this.id,
    required this.title,
    required this.deadline,
    required this.status,
    required this.statusLabel,
    required this.budget,
    required this.description,
    required this.category,
    required this.projectType,
    required this.paymentType,
    required this.priority,
  });

  factory ProjectDetails.fromJson(Map<String, dynamic> json) {
    return ProjectDetails(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      deadline: json['deadline']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString() ?? '',
      budget: json['budget']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      projectType: json['project_type']?.toString() ?? '',
      paymentType: json['payment_type']?.toString() ?? '',
      priority: json['priority']?.toString() ?? '',
    );
  }

  factory ProjectDetails.fake() {
    return ProjectDetails(
      id: 0,
      title: "Project Title",
      deadline: "30 Sep 2025",
      status: "planning",
      statusLabel: "Planning",
      budget: "€5000",
      description: "Project description here...",
      category: 'category',
      projectType: 'project_type',
      paymentType: 'payment_type',
      priority: 'priority',
    );
  }
}

class AssignedConsultantModel {
  final int id;
  final String name;
  final String role;

  AssignedConsultantModel({required this.id, required this.name, required this.role});

  factory AssignedConsultantModel.fromJson(Map<String, dynamic> json) {
    return AssignedConsultantModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }
}

class ProjectMilestones {
  final int id;
  final String title;
  final String assignedTo;
  final String deadline;
  final String status;
  final String statusLabel;
  final bool hasFiles;
  final dynamic budget;

  ProjectMilestones({
    required this.id,
    required this.title,
    required this.assignedTo,
    required this.deadline,
    required this.status,
    required this.statusLabel,
    required this.hasFiles,
    this.budget,
  });

  factory ProjectMilestones.fromJson(Map<String, dynamic> json) {
    return ProjectMilestones(
      id: json['id'] ?? 0,
      title: json['milestone']?.toString() ?? '',
      assignedTo: json['assigned_to']?.toString() ?? '',
      deadline: json['deadline']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString() ?? '',
      hasFiles: json['has_files'] ?? false,
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory ProjectMilestones.fake() {
    return ProjectMilestones(
      id: 0,
      title: "Milestone Title",
      assignedTo: "John Doe",
      deadline: "10 Aug 2025",
      status: "pending",
      statusLabel: "Pending",
      hasFiles: false,
      budget: 0,
    );
  }

  ProjectMilestones copyWith({
    int? id,
    String? title,
    String? assignedTo,
    String? deadline,
    String? status,
    String? statusLabel,
    bool? hasFiles,
    dynamic budget,
  }) {
    return ProjectMilestones(
      id: id ?? this.id,
      title: title ?? this.title,
      assignedTo: assignedTo ?? this.assignedTo,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      hasFiles: hasFiles ?? this.hasFiles,
      budget: budget ?? this.budget,
    );
  }
}

class ProjectFiles {
  final String name;
  final String file;
  final String authority;

  ProjectFiles({required this.name, required this.file, required this.authority});

  factory ProjectFiles.fromJson(Map<String, dynamic> json) {
    return ProjectFiles(
      name: json['file_name']?.toString() ?? '',
      file: json['file_url']?.toString() ?? '',
      authority: json['uploaded_by']?.toString() ?? '',
    );
  }

  factory ProjectFiles.fake() {
    return ProjectFiles(
      name: "document.pdf",
      file: "https://example.com/file.pdf",
      authority: "Admin",
    );
  }
}
