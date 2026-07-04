import 'package:hb/core/data/models/jobs_internship_model.dart';
import 'package:hb/core/domain/repository/jobs_internship_repository.dart';

class GetJobsInternshipUsecase {
  final JobsInternshipRepository repository;

  GetJobsInternshipUsecase(this.repository);

  Future<List<JobsInternshipModel>> call({
    String? search,
    int? categoryId,
    String? jobType,
    String? minBudget,
    String? maxBudget,
    String? deadlineFrom,
    String? deadlineTo,
    int page = 1,
    int perPage = 15,
  }) async {
    return await repository.getJobsInternships(
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
