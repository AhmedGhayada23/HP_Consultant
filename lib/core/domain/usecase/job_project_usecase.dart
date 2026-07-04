import 'package:hb/core/data/models/job_project_model.dart';
import 'package:hb/core/domain/repository/job_project_repository.dart';

class JobProjectUsecase {
  final JobProjectRepository repository;
  JobProjectUsecase(this.repository);

  Future<List<JobProjectModel>> call({
    String? search,
    String? status,
    String? projectType,
    String? role,
    int page = 1,
    int perPage = 15,
  }) async {
    return await repository.getJobProject(
      search: search,
      status: status,
      projectType: projectType,
      role: role,
      page: page,
      perPage: perPage,
    );
  }
}
