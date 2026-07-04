import 'package:hb/core/data/models/employee_progress_model.dart';
import 'package:hb/core/domain/repository/employee_progress_repository.dart';

class GetEmployeesProgressUsecase {
  final EmployeeProgressRepository _repository;

  GetEmployeesProgressUsecase(this._repository);

  Future<List<EmployeeProgressModel>> call() {
    return _repository.getEmployeesProgress();
  }
}
