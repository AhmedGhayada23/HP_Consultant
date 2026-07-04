import 'package:hb/core/config/constants.dart';

class DetailsHbLabProjectModel {
  final int? id;
  final String? publicCode;
  final String? title;
  final String? category;
  final String? deadlineDisplay;
  final String? budgetDisplay;
  final String? statusLabel;
  final String? description;
  final List<String>? goalsDeliverables;
  final List<HbLabMilestone>? milestones;
  final List<HbLabFile>? files;
  final List<HbLabTeamMember>? team;
  final String? joinStatus;

  DetailsHbLabProjectModel({
    this.id,
    this.publicCode,
    this.title,
    this.category,
    this.deadlineDisplay,
    this.budgetDisplay,
    this.statusLabel,
    this.description,
    this.goalsDeliverables,
    this.milestones,
    this.files,
    this.team,
    this.joinStatus,
  });

  factory DetailsHbLabProjectModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return DetailsHbLabProjectModel(
      id: data['id'] as int?,
      publicCode: data['public_code'] as String?,
      title: data['title'] as String?,
      category: data['category'] as String?,
      deadlineDisplay: data['deadline_display'] as String?,
      budgetDisplay: data['budget_display'] as String?,
      statusLabel: data['status_label'] as String?,
      description: data['description'] as String?,
      goalsDeliverables: (data['goals_deliverables'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      milestones: (data['milestones'] as List?)
          ?.map((e) => HbLabMilestone.fromJson(e as Map<String, dynamic>))
          .toList(),
      files: (data['files'] as List?)
          ?.map((e) => HbLabFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      team: (data['team'] as List?)
          ?.map((e) => HbLabTeamMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      joinStatus: data['join_status'] as String?,
    );
  }

  factory DetailsHbLabProjectModel.fake() {
    return DetailsHbLabProjectModel(
      id: 1,
      publicCode: 'PR0001',
      title: 'AI Chatbot For SMEs',
      category: 'Artificial Intelligence',
      deadlineDisplay: '03 Jul 2026',
      budgetDisplay: '€20,000',
      statusLabel: 'Open',
      description:
          'This HB Lab project aims to develop an AI chatbot tailored for small and medium enterprises.',
      goalsDeliverables: [
        'Develop Multilingual Chatbot Model',
        'Provide API Integration For SMEs',
      ],
      milestones: [
        HbLabMilestone.fake(),
        HbLabMilestone.fake(),
      ],
      files: [HbLabFile.fake()],
      team: [HbLabTeamMember.fake()],
      joinStatus: 'none',
    );
  }
}

class HbLabMilestone {
  final int? id;
  final String? title;
  final String? dueDateDisplay;
  final String? statusLabel;

  HbLabMilestone({this.id, this.title, this.dueDateDisplay, this.statusLabel});

  factory HbLabMilestone.fromJson(Map<String, dynamic> json) {
    return HbLabMilestone(
      id: json['id'] as int?,
      title: json['title'] as String?,
      dueDateDisplay: json['due_date_display'] as String?,
      statusLabel: json['status_label'] as String?,
    );
  }

  factory HbLabMilestone.fake() {
    return HbLabMilestone(
      id: 1,
      title: 'Literature Review',
      dueDateDisplay: '17 May 2026',
      statusLabel: 'Completed',
    );
  }
}

class HbLabFile {
  final int? id;
  final String? fileName;
  final String? typeLabel;
  final String? uploaderDisplay;
  final String? url;
  final String? downloadUrl; // رابط تنزيل الملف (download_url)

  HbLabFile({
    this.id,
    this.fileName,
    this.typeLabel,
    this.uploaderDisplay,
    this.url,
    this.downloadUrl,
  });

  factory HbLabFile.fromJson(Map<String, dynamic> json) {
    // رابط التنزيل نسبي (/api/...) → نحوّله إلى مطلق مثل رابط السيرة الذاتية
    String? raw = json['download_url'] as String? ?? json['url'] as String?;
    if (raw != null && raw.startsWith('/')) {
      raw = '${Constants.imageUrl}$raw';
    }
    return HbLabFile(
      id: json['id'] as int?,
      fileName: json['file_name'] as String?,
      typeLabel: json['type_label'] as String?,
      uploaderDisplay: json['uploader_display'] as String?,
      url: json['url'] as String?,
      downloadUrl: raw,
    );
  }

  factory HbLabFile.fake() {
    return HbLabFile(
      id: 1,
      fileName: 'SME_Chatbot_Proposal.pdf',
      typeLabel: 'PDF File',
      uploaderDisplay: 'Baraa Al-Mukayad',
      url: '',
    );
  }
}

class HbLabTeamMember {
  final int? userId;
  final String? name;
  final String? roleLabel;
  final bool? isYou;

  HbLabTeamMember({this.userId, this.name, this.roleLabel, this.isYou});

  factory HbLabTeamMember.fromJson(Map<String, dynamic> json) {
    return HbLabTeamMember(
      userId: json['user_id'] as int?,
      name: json['name'] as String?,
      roleLabel: json['role_label'] as String?,
      isYou: json['is_you'] as bool?,
    );
  }

  factory HbLabTeamMember.fake() {
    return HbLabTeamMember(
      userId: 1,
      name: 'Baraa Al-Mukayad',
      roleLabel: 'Project Lead',
      isYou: false,
    );
  }
}
