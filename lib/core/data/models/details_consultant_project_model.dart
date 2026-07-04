import 'package:hb/core/data/models/consultant_project_model.dart';

// ✅ Model منفصل لـ history
class ConsultantHistoryModel {
  final String firstAssigned;
  final int totalProjects;
  final String totalBilled;

  ConsultantHistoryModel({
    required this.firstAssigned,
    required this.totalProjects,
    required this.totalBilled,
  });

  factory ConsultantHistoryModel.fromJson(Map<String, dynamic> json) {
    return ConsultantHistoryModel(
      firstAssigned: json['first_assigned']?.toString() ?? 'N/A',
      totalProjects: int.tryParse(json['total_projects'].toString()) ?? 0,
      totalBilled: json['total_billed']?.toString() ?? '€0',
    );
  }

  Map<String, dynamic> toJson() => {
    'first_assigned': firstAssigned,
    'total_projects': totalProjects,
    'total_billed': totalBilled,
  };
}

class DetailsConsultantProjectModel {
  final ConsultantProjectModel? consultant;
  final String? about;
  final List<String>? skills;
  final List<dynamic>? assignedProjects;
  final ConsultantHistoryModel? history; // ✅ كان String الآن Model

  DetailsConsultantProjectModel({
    this.consultant,
    this.about,
    this.skills,
    this.assignedProjects,
    this.history,
  });

  factory DetailsConsultantProjectModel.fromJson(Map<String, dynamic> json) {
    // يدعم الحالتين: JSON كامل يحوي "data"، أو المحتوى المُفكوك مباشرةً
    final data = json['data'] ?? json;
    final consultantData = data['consultant'];
    final overview = data['overview'] ?? {};
    final assignedProjects = data['assigned_projects'] as List<dynamic>? ?? [];
    final historyData = data['history'];

    return DetailsConsultantProjectModel(
      consultant: consultantData != null ? ConsultantProjectModel.fromJson(consultantData) : null,
      about: overview['about']?.toString() ?? '',
      skills: List<String>.from(overview['skills'] ?? []),
      assignedProjects: assignedProjects,
      history:
          historyData !=
              null // ✅ parse صحيح
          ? ConsultantHistoryModel.fromJson(historyData)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'consultant': consultant?.toJson(),
    'overview': {'about': about, 'skills': skills},
    'assigned_projects': assignedProjects,
    'history': history?.toJson(), // ✅ الآن يعمل
  };
}
