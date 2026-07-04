class MilestoneModel {
  final int? id;
  final String title;
  final String deadline;
  final double budgetAllocation;
  final int assignTo;
  final String deliverables;

  MilestoneModel({
     this.id,
    required this.title,
    required this.deadline,
    required this.budgetAllocation,
    required this.assignTo,
    required this.deliverables,
  });

  /// ✅ إرسال البيانات إلى API
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "deadline": deadline,
      "budget_allocation": budgetAllocation,
      "assign_to": assignTo,
      "deliverables": deliverables,
    };
  }

  /// ✅ استقبال البيانات من API
  factory MilestoneModel.fromJson(Map<String, dynamic> json) {
    return MilestoneModel(
      id:  json['id'] ?? 0,
      title: json['title'] ?? '',
      deadline: json['deadline'] ?? '',
      budgetAllocation: (json['budget_allocation'] as num?)?.toDouble() ?? 0.0,
      assignTo: json['assign_to'] ?? 0,
      deliverables: json['deliverables'] ?? '',
    );
  }
}
