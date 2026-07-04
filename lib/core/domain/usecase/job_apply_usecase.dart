import 'package:flutter/widgets.dart';
import 'package:hb/core/domain/repository/job_apply_repository.dart';

class JobApplyUsecase {
  final JobApplyRepository repository;
  JobApplyUsecase(this.repository);

  Future<bool> call({
    required BuildContext context,
    required int jobId,
    required String proposedRate,
    required String durationWeeks,
    required String availabilityStartDate,
    required String coverLetter,
    required bool adminPreviewRequested,
    required bool informationAccuracyConfirmed,
    String? supportingDocPath,
  }) {
    return repository.applyJob(
      context: context,
      jobId: jobId,
      proposedRate: proposedRate,
      durationWeeks: durationWeeks,
      availabilityStartDate: availabilityStartDate,
      coverLetter: coverLetter,
      adminPreviewRequested: adminPreviewRequested,
      informationAccuracyConfirmed: informationAccuracyConfirmed,
      supportingDocPath: supportingDocPath,
    );
  }
}
