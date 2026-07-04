class PurchasedCourseModle {
  final int? id;
  final int? courseId;
  final String? courseTitle;
  final String? trainer;
  final String? purchaseDate;
  final String? assignedEmployees;
  final int? assignedCount;
  final String? progressAvg;
  final String? completionRate;
  final int? completedCount;
  final String? totalAmount;

  PurchasedCourseModle({
    this.id,
    this.courseId,
    this.courseTitle,
    this.trainer,
    this.purchaseDate,
    this.assignedEmployees,
    this.assignedCount,
    this.progressAvg,
    this.completionRate,
    this.completedCount,
    this.totalAmount,
  });

  factory PurchasedCourseModle.fromJson(Map<String, dynamic> json) {
    return PurchasedCourseModle(
      id: json['id'],
      courseId: json['course_id'],
      courseTitle: json['course_title'],
      trainer: json['trainer'],
      purchaseDate: json['purchase_date'],
      assignedEmployees: json['assigned_employees'],
      assignedCount: json['assigned_count'],
      progressAvg: json['progress_avg'],
      completionRate: json['completion_rate'],
      completedCount: json['completed_count'],
      totalAmount: json['total_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "course_id": courseId,
      "course_title": courseTitle,
      "trainer": trainer,
      "purchase_date": purchaseDate,
      "assigned_employees": assignedEmployees,
      "assigned_count": assignedCount,
      "progress_avg": progressAvg,
      "completion_rate": completionRate,
      "completed_count": completedCount,
      "total_amount": totalAmount,
    };
  }

  factory PurchasedCourseModle.fake() {
    return PurchasedCourseModle(
      id: 0,
      courseId: 1,
      courseTitle: 'courseTitle',
      trainer: 'trainer',
      purchaseDate: 'purchaseDate',
      assignedEmployees: 'assignedEmployees',
      assignedCount: 0,
      progressAvg: 'progressAvg',
      completionRate: 'completionRate',
      completedCount: 0,
      totalAmount: '0',
    );
  }
}
