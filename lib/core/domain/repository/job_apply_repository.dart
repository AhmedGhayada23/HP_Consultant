import 'package:flutter/widgets.dart';
import 'package:hb/core/data/datasource/job_apply_datasource.dart';

abstract class JobApplyRepository {
  Future<bool> applyJob({
    required BuildContext context,
    required int jobId,
    required String proposedRate,
    required String durationWeeks,
    required String availabilityStartDate,
    required String coverLetter,
    required bool adminPreviewRequested,
    required bool informationAccuracyConfirmed,
    String? supportingDocPath,
  });
}

class JobApplyRepositoryImpl implements JobApplyRepository {
  final JobApplyDataSource dataSource;
  JobApplyRepositoryImpl(this.dataSource);

  @override
  Future<bool> applyJob({
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
    return dataSource.applyJob(
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
