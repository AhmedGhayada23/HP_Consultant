class JobsModel {
  final int id;
  final String title;
  final int applicantsCount;
  final String budget;
  final String budgetMin;
  final String budgetMax;
  final String deadline;
  final String createdOn;
  final String status;
  final String statusLabel;
  final String statusColor;

  JobsModel({
    required this.id,
    required this.title,
    required this.applicantsCount,
    required this.budget,
    required this.budgetMin,
    required this.budgetMax,
    required this.deadline,
    required this.createdOn,
    required this.status,
    required this.statusLabel,
    required this.statusColor,
  });

  factory JobsModel.fromJson(Map<String, dynamic> json) {
    return JobsModel(
      id: json['id'],
      title: json['title'],
      applicantsCount: json['applicants_count'],
      budget: json['budget'],
      budgetMin: json['budget_min'],
      budgetMax: json['budget_max'],
      deadline: json['deadline'],
      createdOn: json['created_on'],
      status: json['status'],
      statusLabel: json['status_label'],
      statusColor: json['status_color'],
    );
  }

  // ✅ copyWith لتحديث الـ status محلياً
  JobsModel copyWith({
    int? id,
    String? title,
    int? applicantsCount,
    String? budget,
    String? budgetMin,
    String? budgetMax,
    String? deadline,
    String? createdOn,
    String? status,
    String? statusLabel,
    String? statusColor,
  }) {
    return JobsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      applicantsCount: applicantsCount ?? this.applicantsCount,
      budget: budget ?? this.budget,
      budgetMin: budgetMin ?? this.budgetMin,
      budgetMax: budgetMax ?? this.budgetMax,
      deadline: deadline ?? this.deadline,
      createdOn: createdOn ?? this.createdOn,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      statusColor: statusColor ?? this.statusColor,
    );
  }

  factory JobsModel.fack() {
    return JobsModel(
      id: 0,
      title: 'title',
      applicantsCount: 0,
      budget: 'budget',
      budgetMin: 'budgetMin',
      budgetMax: 'budgetMax',
      deadline: 'deadline',
      createdOn: 'createdOn',
      status: 'status',
      statusLabel: 'statusLabel',
      statusColor: 'statusColor',
    );
  }
}
