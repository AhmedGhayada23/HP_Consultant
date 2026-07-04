class DetailsJobProjectModel {
  final int id;
  final String? title;
  final String? budget;
  final String? category;
  final String? assignedRole;
  final String? description;
  final String? jobTypeLabel;
  final String? status;
  final String? deadline;
  final String? requestReference;
  final String? companyName;
  final String? companyLocation;
  final String? jobLocation;
  final List<String>? requiredSkills;
  final List<MekestonesAndTasks>? mekestonesAndTasks;
  final List<Payments>? payments;
  final List<JobAttachment>? attachments;

  DetailsJobProjectModel({
    this.id = 0,
    this.title,
    this.budget,
    this.category,
    this.assignedRole,
    this.description,
    this.jobTypeLabel,
    this.status,
    this.deadline,
    this.requestReference,
    this.companyName,
    this.companyLocation,
    this.jobLocation,
    this.requiredSkills,
    this.mekestonesAndTasks,
    this.payments,
    this.attachments,
  });

  factory DetailsJobProjectModel.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json['data'] ?? json);
    final categoryJson = data['category'];
    final company =
        data['company'] is Map ? Map<String, dynamic>.from(data['company']) : null;
    return DetailsJobProjectModel(
      id: data['id'] ?? 0,
      title: data['title'] ?? '',
      budget: data['budget_display'] ?? '',
      category: categoryJson is Map
          ? categoryJson['name'] as String?
          : categoryJson as String?,
      assignedRole: data['assigned_role'] as String?,
      description: data['description'] ?? '',
      jobTypeLabel: data['service_type'] ?? data['project_type'] ?? data['job_type_label'] ?? '',
      status: data['status_label'] ?? data['status'] ?? '',
      deadline: data['deadline_display'] ?? data['deadline'] ?? '',
      requestReference: data['request_reference'] as String?,
      companyName: company?['name'] as String?,
      companyLocation:
          company?['location_label'] as String? ?? data['location'] as String?,
      jobLocation: data['job_location'] as String?,
      requiredSkills: (data['required_skills'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      mekestonesAndTasks: (data['milestones'] as List? ?? [])
          .map((e) => MekestonesAndTasks.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      payments: (data['invoices'] as List? ?? [])
          .map((e) => Payments.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      attachments: (data['files'] as List? ?? data['attachments'] as List? ?? [])
          .map((e) => JobAttachment.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class MekestonesAndTasks {
  final int? id;
  final String? title;
  final String? deadline;
  final String? status;

  MekestonesAndTasks({this.id, this.title, this.deadline, this.status});

  factory MekestonesAndTasks.fromJson(Map<String, dynamic> json) {
    return MekestonesAndTasks(
      id: json['id'] as int?,
      title: json['title'] ?? '',
      deadline: json['due_date_display'] ?? json['due_date'] ?? json['deadline'] ?? '',
      status: json['status_label'] ?? json['status'] ?? '',
    );
  }
}

class Payments {
  final String? uvoiceNumber;
  final String? amount;
  final String? date;
  final String? status;

  Payments({this.uvoiceNumber, this.amount, this.date, this.status});

  factory Payments.fromJson(Map<String, dynamic> json) {
    return Payments(
      uvoiceNumber: json['invoice_number'] ?? json['number'] ?? '',
      amount: json['amount_display'] ?? json['amount']?.toString() ?? '',
      date: json['date_display'] ?? json['date'] ?? '',
      status: json['status_label'] ?? json['status'] ?? '',
    );
  }
}

class JobAttachment {
  final int id;
  final String fileName;
  final String typeLabel;
  final String? downloadUrl;

  JobAttachment({
    this.id = 0,
    this.fileName = '',
    this.typeLabel = '',
    this.downloadUrl,
  });

  factory JobAttachment.fromJson(Map<String, dynamic> json) {
    return JobAttachment(
      id: json['id'] ?? 0,
      fileName: json['file_name'] ?? json['name'] ?? '',
      typeLabel: json['type_label'] ?? 'File',
      downloadUrl: json['download_url'] ?? json['url'],
    );
  }
}
