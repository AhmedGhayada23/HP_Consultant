import 'package:hb/core/data/datasource/job_application_data_source.dart';
import 'package:hb/core/data/models/job_application_model.dart';

abstract class JobApplicationRepository {
  Future<JobApplicationsResult> getJobApplications(int jobId, {int page});
}

class JobApplicationRepositoryImpl extends JobApplicationRepository {
  final JobApplicationDataSource dataSource;
  JobApplicationRepositoryImpl(this.dataSource);

  @override
  Future<JobApplicationsResult> getJobApplications(int jobId, {int page = 1}) {
    return dataSource.getJobApplications(jobId, page: page);
  }
}
