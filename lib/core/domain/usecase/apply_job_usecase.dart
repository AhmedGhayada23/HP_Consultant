import 'package:hb/core/domain/repository/apply_job_repository.dart';

class ApplyJobUsecase {
  final ApplyJobRepository repository;
  ApplyJobUsecase(this.repository);

  Future<void> call({
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
    return repository.apply(
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
