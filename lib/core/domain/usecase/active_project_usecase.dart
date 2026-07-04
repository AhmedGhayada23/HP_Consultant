import 'package:hb/core/data/models/active_project_model.dart';
import 'package:hb/core/domain/repository/active_project_repository.dart';

class ActiveProjectUsecase {
  final ActiveProjectRepository repository;
  ActiveProjectUsecase(this.repository);

  Future<List<ActiveProjectModel>> call({
    String? status,
    String? deadlineFrom,
    String? deadlineTo,
    String? name,
    String? consultant,
  }) async {
    return await repository.getActiveProject(
      status: status,
      deadlineFrom: deadlineFrom,
      deadlineTo: deadlineTo,
      name: name,
      consultant: consultant,
    );
  }
}
