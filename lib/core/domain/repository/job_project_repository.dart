import 'package:hb/core/data/datasource/job_project_data_source.dart';
import 'package:hb/core/data/models/job_project_model.dart';

abstract class JobProjectRepository {
  Future<List<JobProjectModel>> getJobProject({
    String? search,
    String? status,
    String? projectType,
    String? role,
    int page,
    int perPage,
  });
}

class JobProjectRepositoryImpl extends JobProjectRepository {
  final JobProjectDataSource dataSource;
  JobProjectRepositoryImpl(this.dataSource);
  @override
  Future<List<JobProjectModel>> getJobProject({
    String? search,
    String? status,
    String? projectType,
    String? role,
    int page = 1,
    int perPage = 15,
  }) {
    return dataSource.getJobProject(
      search: search,
      status: status,
      projectType: projectType,
      role: role,
      page: page,
      perPage: perPage,
    );
  }
}
