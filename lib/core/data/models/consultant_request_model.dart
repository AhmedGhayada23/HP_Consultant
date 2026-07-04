class ConsultantRequestModel {
  final int id;
  final String requestId;
  final String projectTitle;
  final String serviceType;
  final String dateSubmitted;
  final String consultantRequested;
  final int? consultantId;
  final String budget;
  final String pricingType;
  final String status;
  final String statusKey;
  final String statusColor;
  final String preferredDeadline;
  final String description;
  final String priority;

  ConsultantRequestModel({
    this.id = 0,
    this.requestId = '',
    this.projectTitle = '',
    this.serviceType = '',
    this.dateSubmitted = '',
    this.consultantRequested = '',
    this.consultantId,
    this.budget = '',
    this.pricingType = '',
    this.status = '',
    this.statusKey = '',
    this.statusColor = '',
    this.preferredDeadline = '',
    this.description = '',
    this.priority = '',
  });

  factory ConsultantRequestModel.fromJson(Map<String, dynamic> json) {
    return ConsultantRequestModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      requestId: json['request_id']?.toString() ?? '',
      projectTitle: json['project_title']?.toString() ?? '',
      serviceType: json['service_type']?.toString() ?? '',
      dateSubmitted: json['date_submitted']?.toString() ?? '',
      consultantRequested: json['consultant_requested']?.toString() ?? '',
      consultantId: json['consultant_id'] is int
          ? json['consultant_id']
          : int.tryParse('${json['consultant_id']}'),
      budget: json['budget']?.toString() ?? '',
      pricingType: json['pricing_type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      statusKey: json['status_key']?.toString() ?? '',
      statusColor: json['status_color']?.toString() ?? '',
      preferredDeadline: json['preferred_deadline']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      priority: json['priority']?.toString() ?? '',
    );
  }
}
