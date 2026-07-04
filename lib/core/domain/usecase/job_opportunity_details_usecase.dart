import 'package:hb/core/data/models/job_opportunity_details_model.dart';
import 'package:hb/core/domain/repository/job_opportunity_details_repository.dart';

class JobOpportunityDetailsUsecase {
  final JobOpportunityDetailsRepository repository;
  JobOpportunityDetailsUsecase(this.repository);

  Future<JobOpportunityDetailsModel> call(int jobId) {
    return repository.getJobDetails(jobId);
  }
}
