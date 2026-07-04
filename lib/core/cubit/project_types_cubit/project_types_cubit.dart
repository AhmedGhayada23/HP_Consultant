import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/project_types_cubit/project_types_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ProjectTypesCubit extends Cubit<ProjectTypesState> {
  ProjectTypesCubit() : super(ProjectTypesState());

  void setProjectType(String projectType) {
    emit(state.copyWith(selectedProjectType: projectType));
  }

  Future<void> fetchProjectTypes() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final projectTypes = await UseCases.getJobAndTalentUsecase.getProjectTypes();
      emit(state.copyWith(projectTypes: projectTypes, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  void clearProjectType() {
    // إعادة بناء الحالة لتصفير الاختيار فعليًا (copyWith لا يقبل null)
    emit(ProjectTypesState(
      projectTypes: state.projectTypes,
      isLoading: state.isLoading,
    ));
  }
}
