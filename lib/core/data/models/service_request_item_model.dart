class ServiceRequestFileModel {
  final int fileId;
  final String fileName;
  final String fileType;
  final String url;

  ServiceRequestFileModel({
    this.fileId = 0,
    this.fileName = '',
    this.fileType = '',
    this.url = '',
  });

  factory ServiceRequestFileModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestFileModel(
      fileId: json['file_id'] is int
          ? json['file_id']
          : int.tryParse('${json['file_id']}') ?? 0,
      fileName: json['file_name']?.toString() ?? '',
      fileType: json['file_type']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }
}

class ServiceRequestItemModel {
  final int id;
  final String requestId;
  final String serviceType;
  final String submittedOn;
  final String preferredDeadline;
  final String proposedBudget;
  final String status;
  final String description;
  final List<ServiceRequestFileModel> requestFiles;
  final bool canEdit;
  final bool canCancel;

  ServiceRequestItemModel({
    this.id = 0,
    this.requestId = '',
    this.serviceType = '',
    this.submittedOn = '',
    this.preferredDeadline = '',
    this.proposedBudget = '',
    this.status = '',
    this.description = '',
    this.requestFiles = const [],
    this.canEdit = false,
    this.canCancel = false,
  });

  factory ServiceRequestItemModel.fromJson(Map<String, dynamic> json) {
    final rawFiles = json['request_files'];
    final files = rawFiles is List
        ? rawFiles
            .whereType<Map>()
            .map((e) =>
                ServiceRequestFileModel.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <ServiceRequestFileModel>[];

    return ServiceRequestItemModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      requestId:
          (json['reference_number'] ?? json['request_id'])?.toString() ?? '',
      serviceType: json['service_type']?.toString() ?? '',
      submittedOn: json['submitted_on']?.toString() ?? '',
      preferredDeadline: json['preferred_deadline']?.toString() ?? '',
      proposedBudget: json['proposed_budget']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      requestFiles: files,
      canEdit: json['can_edit'] == true,
      canCancel: json['can_cancel'] == true,
    );
  }
}
