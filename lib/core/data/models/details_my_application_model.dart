class DetailsMyApplicationModel {
  final int id;
  final String? jobTitle;
  final String? companyName;
  final String? jobTypeLabel;
  final String? stipendLabel;
  final String? applicationDateDisplay;
  final String? statusLabel;
  final String? recruiterContactNote;
  final String? coverLetter;
  final String? applicantName;
  final String? applicantEmail;
  final String? availabilityStartDate;
  final List<String> completedTrainingCourseIds;
  final ApplicationCv? cv;
  final String? deadlineDisplay;

  DetailsMyApplicationModel({
    this.id = 0,
    this.jobTitle,
    this.companyName,
    this.jobTypeLabel,
    this.stipendLabel,
    this.applicationDateDisplay,
    this.statusLabel,
    this.recruiterContactNote,
    this.coverLetter,
    this.applicantName,
    this.applicantEmail,
    this.availabilityStartDate,
    this.completedTrainingCourseIds = const [],
    this.cv,
    this.deadlineDisplay,
  });

  factory DetailsMyApplicationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : json;
    final job = data['job'] is Map ? Map<String, dynamic>.from(data['job']) : null;

    return DetailsMyApplicationModel(
      id: data['id'] ?? 0,
      jobTitle: data['job_title'] ?? '',
      companyName: data['company_name'] ?? '',
      jobTypeLabel: data['job_type_label'] as String?,
      stipendLabel: data['stipend_label'] as String?,
      applicationDateDisplay:
          data['application_date_display'] ?? data['application_date'] ?? '',
      statusLabel: data['status_label'] as String?,
      recruiterContactNote: data['recruiter_contact_note'] as String?,
      coverLetter: data['cover_letter'] as String?,
      applicantName: data['applicant_name'] as String?,
      applicantEmail: data['applicant_email'] as String?,
      availabilityStartDate: data['availability_start_date'] as String?,
      completedTrainingCourseIds:
          (data['completed_training_course_ids'] as List? ?? [])
              .map((e) => e.toString())
              .toList(),
      cv: data['cv'] is Map
          ? ApplicationCv.fromJson(Map<String, dynamic>.from(data['cv']))
          : null,
      deadlineDisplay: job?['deadline_display'] as String?,
    );
  }
}

class ApplicationCv {
  final String fileName;
  final String typeLabel;
  final String? downloadUrl;

  ApplicationCv({this.fileName = '', this.typeLabel = '', this.downloadUrl});

  factory ApplicationCv.fromJson(Map<String, dynamic> json) {
    return ApplicationCv(
      fileName: json['file_name'] ?? json['name'] ?? '',
      typeLabel: json['type_label'] ?? 'File',
      downloadUrl: json['download_url'] ?? json['url'],
    );
  }
}
