import 'package:hb/core/data/datasource/apply_job_data_source.dart';

abstract class ApplyJobRepository {
  Future<void> apply({
    required int jobId,
    required String applicantName,
    required String applicantEmail,
    required String availabilityStartDate,
    required bool informationAccuracyConfirmed,
    required bool adminPreviewRequested,
    String? coverLetter,
    String? cvPath,
    List<int> completedCourseIds,
  });
}

class ApplyJobRepositoryImpl implements ApplyJobRepository {
  final ApplyJobDataSource dataSource;
  ApplyJobRepositoryImpl(this.dataSource);

  @override
  Future<void> apply({
    required int jobId,
    required String applicantName,
    required String applicantEmail,
    required String availabilityStartDate,
    required bool informationAccuracyConfirmed,
    required bool adminPreviewRequested,
    String? coverLetter,
    String? cvPath,
    List<int> completedCourseIds = const [],
  }) {
    return dataSource.apply(
      jobId: jobId,
      applicantName: applicantName,
      applicantEmail: applicantEmail,
      availabilityStartDate: availabilityStartDate,
      informationAccuracyConfirmed: informationAccuracyConfirmed,
      adminPreviewRequested: adminPreviewRequested,
      coverLetter: coverLetter,
      cvPath: cvPath,
      completedCourseIds: completedCourseIds,
    );
  }
}
