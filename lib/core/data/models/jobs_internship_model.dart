class JobsInternshipModel {
  final int id;
  final String? title;
  final String? company;
  final String? duration;
  final String? location;
  final String? requirements;
  final String? jobType;
  final String? jobTypeLabel;
  final String? projectType;
  final String? stipend;
  final String? deadline;
  final int? requiredCourseId;
  final String? requiredCourseTitle;

  JobsInternshipModel({
    this.id = 0,
    this.title,
    this.company,
    this.duration,
    this.location,
    this.requirements,
    this.jobType,
    this.jobTypeLabel,
    this.projectType,
    this.stipend,
    this.deadline,
    this.requiredCourseId,
    this.requiredCourseTitle,
  });

  factory JobsInternshipModel.fromJson(Map<String, dynamic> json) {
    final course = json['required_training_course'] is Map
        ? Map<String, dynamic>.from(json['required_training_course'])
        : null;
    return JobsInternshipModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      company: json['company_name'] ?? '',
      duration: json['duration_label'] ?? '',
      location: json['location'] ?? '',
      requirements: json['requirement_summary'] ?? '',
      jobType: json['job_type'] as String?,
      jobTypeLabel: json['job_type_label'] as String?,
      projectType: json['project_type'] as String?,
      stipend: json['stipend_label'] as String?,
      deadline: json['deadline'] as String?,
      requiredCourseId: course?['id'] as int?,
      requiredCourseTitle: course?['title'] as String?,
    );
  }
}
