import 'package:hb/core/data/datasource/jobs_internship_data_source.dart';
import 'package:hb/core/data/models/jobs_internship_model.dart';

abstract class JobsInternshipRepository {
  Future<List<JobsInternshipModel>> getJobsInternships({
    String? search,
    int? categoryId,
    String? jobType,
    String? minBudget,
    String? maxBudget,
    String? deadlineFrom,
    String? deadlineTo,
    int page,
    int perPage,
  });
}

class JobsInternshipRepositoryImpl implements JobsInternshipRepository {
  final JobsInternshipDataSource dataSource;

  JobsInternshipRepositoryImpl(this.dataSource);

  @override
  Future<List<JobsInternshipModel>> getJobsInternships({
    String? search,
    int? categoryId,
    String? jobType,
    String? minBudget,
    String? maxBudget,
    String? deadlineFrom,
    String? deadlineTo,
    int page = 1,
    int perPage = 15,
  }) {
    return dataSource.getJobsInternships(
      search: search,
      categoryId: categoryId,
      jobType: jobType,
      minBudget: minBudget,
      maxBudget: maxBudget,
      deadlineFrom: deadlineFrom,
      deadlineTo: deadlineTo,
      page: page,
      perPage: perPage,
    );
  }
}
