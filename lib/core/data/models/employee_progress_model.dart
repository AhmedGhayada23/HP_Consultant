class EmployeeProgressModel {
  final String employeeName;
  final String courseTitle;
  final int progress;
  final String status;

  EmployeeProgressModel({
    required this.employeeName,
    required this.courseTitle,
    required this.progress,
    required this.status,
  });

  factory EmployeeProgressModel.fromJson(Map<String, dynamic> json) {
    return EmployeeProgressModel(
      employeeName: json['employee_name']?.toString() ?? '',
      courseTitle: json['course_title']?.toString() ?? '',
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? '',
    );
  }

  factory EmployeeProgressModel.fake() {
    return EmployeeProgressModel(
      employeeName: 'Sarah Ahmed',
      courseTitle: 'Agile Project Mgmt',
      progress: 100,
      status: 'Completed',
    );
  }
}
