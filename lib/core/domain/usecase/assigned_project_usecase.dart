import 'package:hb/core/data/models/assigned_project_model.dart';
import 'package:hb/core/domain/repository/assigned_project_repository.dart';

class AssignedProjectUsecase {
  final AssignedProjectRepository repository;

  AssignedProjectUsecase(this.repository);

  Future<List<AssignedProjectModel>> call(int consultantId) async {
    return await repository.getAssignedProject(consultantId);
  }
}
