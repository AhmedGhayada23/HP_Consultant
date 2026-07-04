import 'package:hb/core/data/models/employee_progress_model.dart';

class EmployeeProgressState {
  final List<EmployeeProgressModel>? employees;
  final bool loading;
  final String? errorMessage;

  EmployeeProgressState({
    this.employees,
    this.loading = false,
    this.errorMessage,
  });

  EmployeeProgressState copyWith({
    List<EmployeeProgressModel>? employees,
    bool? loading,
    String? errorMessage,
  }) {
    return EmployeeProgressState(
      employees: employees ?? this.employees,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
