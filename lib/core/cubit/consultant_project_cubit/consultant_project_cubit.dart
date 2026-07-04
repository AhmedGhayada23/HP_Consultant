import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/consultant_project_cubit/consultant_project_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ConsultantProjectCubit extends Cubit<ConsultantProjectState> {
  ConsultantProjectCubit() : super(ConsultantProjectState());

  Future<void> fetchConsultantProject({String? search, String? status, String? project, String? role}) async {
    emit(state.copyWith(loading: true));

    try {
      final consultantProject = await UseCases.getConsultantProjectUsecase.call(search: search, status: status, project: project, role: role);
      emit(state.copyWith(consultantProjectData: consultantProject, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
