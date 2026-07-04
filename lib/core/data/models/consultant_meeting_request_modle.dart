class ConsultantMeetingRequestModel {
  final int id;
  final String title;
  final String category;
  final String createdOn;
  final String assignedConsultants;
  final String status;
  final String statusLabel;

  ConsultantMeetingRequestModel({
    required this.id,
    required this.title,
    required this.category,
    required this.createdOn,
    required this.assignedConsultants,
    required this.status,
    required this.statusLabel,
  });

  factory ConsultantMeetingRequestModel.fromJson(Map<String, dynamic> json) {
    return ConsultantMeetingRequestModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      createdOn: json['created_on']?.toString() ?? '',
      assignedConsultants: json['assigned_consultants']?.toString() ?? '-',
      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString() ?? '',
    );
  }

  factory ConsultantMeetingRequestModel.fake() => ConsultantMeetingRequestModel(
        id: 0,
        title: 'Mobile Dev',
        category: 'Development',
        createdOn: '09 Mar 2026',
        assignedConsultants: '-',
        status: 'in_review',
        statusLabel: 'In Review',
      );
}
