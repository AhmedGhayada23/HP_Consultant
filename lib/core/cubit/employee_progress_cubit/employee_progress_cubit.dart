import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/employee_progress_cubit/employee_progress_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class EmployeeProgressCubit extends Cubit<EmployeeProgressState> {
  EmployeeProgressCubit() : super(EmployeeProgressState());

  Future<void> fetchEmployeesProgress() async {
    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      final data = await UseCases.getEmployeesProgressUsecase();
      emit(state.copyWith(employees: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
