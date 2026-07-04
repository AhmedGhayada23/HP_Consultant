import 'package:hb/core/data/datasource/assigned_project_data_source.dart';
import 'package:hb/core/data/models/assigned_project_model.dart';

abstract class AssignedProjectRepository {
  Future<List<AssignedProjectModel>> getAssignedProject(int consultantId);
}

class AssignedProjectRepositoryImpl extends AssignedProjectRepository {
  final AssignedProjectModelDataSource dataSource;
  AssignedProjectRepositoryImpl(this.dataSource);
  @override
  Future<List<AssignedProjectModel>> getAssignedProject(int consultantId) async {
    return await dataSource.getAssignedProject(consultantId);
  }
}
