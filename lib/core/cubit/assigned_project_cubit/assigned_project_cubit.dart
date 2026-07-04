import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/assigned_project_cubit/assigned_project_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class AssignedProjectCubit extends Cubit<AssignedProjectState> {
  AssignedProjectCubit() : super(AssignedProjectState());

  void fetchAssignedProject(int consultantId) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data =
          await UseCases.getAssignedProjectUsecase(consultantId); // Replace with actual data fetching logic
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
