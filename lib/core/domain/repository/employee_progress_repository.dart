import 'package:hb/core/data/datasource/employee_progress_datasource.dart';
import 'package:hb/core/data/models/employee_progress_model.dart';

abstract class EmployeeProgressRepository {
  Future<List<EmployeeProgressModel>> getEmployeesProgress();
}

class EmployeeProgressRepositoryImpl extends EmployeeProgressRepository {
  final EmployeeProgressDatasource _datasource;

  EmployeeProgressRepositoryImpl(this._datasource);

  @override
  Future<List<EmployeeProgressModel>> getEmployeesProgress() {
    return _datasource.getEmployeesProgress();
  }
}
