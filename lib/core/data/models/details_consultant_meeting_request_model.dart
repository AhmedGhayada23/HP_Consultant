class DetailsConsultantMeetingRequestModel {
  final String reqId;
  final String title;
  final String category;
  final String consultantType;
  final String urgency;
  final String budget;
  final String? assignedConsultant; // ✅ nullable لأن الـ API يرجع null
  final String? meetingDetails;     // ✅ nullable لأن الـ API يرجع null
  final String role;
  final String? document;           // ✅ URL واحد مش List
  final String description;
  final String status;
  final String statusLabel;

  DetailsConsultantMeetingRequestModel({
    required this.reqId,
    required this.title,
    required this.category,
    required this.consultantType,
    required this.urgency,
    required this.budget,
    this.assignedConsultant,
    this.meetingDetails,
    required this.role,
    this.document,
    required this.description,
    required this.status,
    required this.statusLabel,
  });

  factory DetailsConsultantMeetingRequestModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final request = data['request'] ?? {};
    final assignedConsultant = data['assigned_consultant'];
    final meeting = data['meeting'];

    return DetailsConsultantMeetingRequestModel(
      reqId: request['request_id']?.toString() ?? '',
      title: request['title']?.toString() ?? '',
      category: request['category']?.toString() ?? '',
      consultantType: request['consultant_type']?.toString() ?? '',
      urgency: request['urgency']?.toString() ?? '',
      budget: request['budget_range']?.toString() ?? '',
      assignedConsultant: assignedConsultant?.toString(),   // null لو مش معين
      meetingDetails: meeting?.toString(),                   // null لو مش موجود
      role: request['consultant_type']?.toString() ?? '',   // ✅ من consultant_type
      document: request['supporting_document']?.toString(), // ✅ URL واحد
      description: request['description']?.toString() ?? '',
      status: request['status']?.toString() ?? '',
      statusLabel: request['status_label']?.toString() ?? '',
    );
  }

  factory DetailsConsultantMeetingRequestModel.fake() =>
      DetailsConsultantMeetingRequestModel(
        reqId: 'REQ-00007',
        title: 'Mobile Dev',
        category: 'Development',
        consultantType: 'Mobile App Developer',
        urgency: 'Urgent',
        budget: '€100 - €200',
        assignedConsultant: null,
        meetingDetails: null,
        role: 'Mobile App Developer',
        document: 'https://example.com/doc.jpg',
        description: 'i need mobile application',
        status: 'in_review',
        statusLabel: 'In Review',
      );
}
