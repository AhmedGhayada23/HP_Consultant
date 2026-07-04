import 'package:hb/core/data/datasource/active_project_data_source.dart';
import 'package:hb/core/data/models/active_project_model.dart';

abstract class ActiveProjectRepository {
  Future<List<ActiveProjectModel>> getActiveProject({
    String? status,
    String? deadlineFrom,
    String? deadlineTo,
    String? name,
    String? consultant,
  });
}

class ActiveProjectRepositoryImpl extends ActiveProjectRepository {
  final ActiveProjectDataSource dataSource;
  ActiveProjectRepositoryImpl(this.dataSource);

  @override
  Future<List<ActiveProjectModel>> getActiveProject({
    String? status,
    String? deadlineFrom,
    String? deadlineTo,
    String? name,
    String? consultant,
  }) {
    return dataSource.getActiveProject(
      status: status,
      deadlineFrom: deadlineFrom,
      deadlineTo: deadlineTo,
      name: name,
      consultant: consultant,
    );
  }
}
