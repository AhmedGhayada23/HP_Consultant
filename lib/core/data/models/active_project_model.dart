class ActiveProjectModel {
  final int? id;
  final String? title;
  final String? budget;
  final String? deadline;
  final String? assignedConsultants;
  final String? status;
  final String? statusLabel;

  ActiveProjectModel({
    this.id,
    this.title,
    this.budget,
    this.deadline,
    this.assignedConsultants,
    this.status,
    this.statusLabel,
  });

  /// تحويل من JSON
  factory ActiveProjectModel.fromJson(Map<String, dynamic> json) {
    return ActiveProjectModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      budget: json['budget'] ?? '',
      deadline: json['deadline'] ?? '',
      assignedConsultants: json['assigned_consultants'] ?? '-',
      status: json['status'] ?? '',
      statusLabel: json['status_label'] ?? '',
    );
  }

  /// تحويل من Model إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'budget': budget,
      'deadline': deadline,
      'assigned_consultants': assignedConsultants,
      'status': status,
      'status_label': statusLabel,
    };
  }

  factory ActiveProjectModel.fake() {
    return ActiveProjectModel(
      id: 0,
      title: 'title',
      budget: 'budget',
      deadline: 'deadline',
      assignedConsultants: 'assignedConsultants',
      status: 'status',
      statusLabel: 'statusLabel',
    );
  }
}
