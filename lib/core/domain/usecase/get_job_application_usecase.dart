import 'package:hb/core/data/models/job_application_model.dart';
import 'package:hb/core/domain/repository/job_application_repository.dart';

class GetJobApplicationUsecase {
  final JobApplicationRepository repository;

  GetJobApplicationUsecase(this.repository);

  Future<JobApplicationsResult> call(int jobId, {int page = 1}) {
    return repository.getJobApplications(jobId, page: page);
  }
}
