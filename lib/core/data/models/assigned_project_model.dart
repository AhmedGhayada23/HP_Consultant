class AssignedProjectModel {
  final String projectTitle;
  final String roleInProject;
  final String duration;
  final String budget;
  final String status;
  final String statusLabel;

  AssignedProjectModel({
    required this.projectTitle,
    required this.roleInProject,
    required this.duration,
    required this.budget,
    required this.status,
    required this.statusLabel,
  });

  factory AssignedProjectModel.fromJson(Map<String, dynamic> json) {
    return AssignedProjectModel(
      projectTitle: json['project_title'] ?? '',
      roleInProject: json['role_in_project'] ?? '',
      duration: json['duration'] ?? '',
      budget: json['budget'] ?? '',
      status: json['status'] ?? '',
      statusLabel: json['status_label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "project_title": projectTitle,
      "role_in_project": roleInProject,
      "duration": duration,
      "budget": budget,
      "status": status,
      "status_label": statusLabel,
    };
  }
}
