import 'package:hb/core/data/datasource/job_opportunity_details_data_source.dart';
import 'package:hb/core/data/models/job_opportunity_details_model.dart';

abstract class JobOpportunityDetailsRepository {
  Future<JobOpportunityDetailsModel> getJobDetails(int jobId);
}

class JobOpportunityDetailsRepositoryImpl implements JobOpportunityDetailsRepository {
  final JobOpportunityDetailsDataSource dataSource;
  JobOpportunityDetailsRepositoryImpl(this.dataSource);

  @override
  Future<JobOpportunityDetailsModel> getJobDetails(int jobId) {
    return dataSource.getJobDetails(jobId);
  }
}
