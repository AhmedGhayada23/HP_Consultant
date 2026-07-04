import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/job_project_cubit/job_project_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class JobProjectCubit extends Cubit<JobProjectState> {
  JobProjectCubit() : super(JobProjectState());

  Future<void> fetchJobProject({
    String? search,
    String? status,
    String? projectType,
    String? role,
    int page = 1,
    int perPage = 15,
  }) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.getJobProjectUsecase(
        search: search,
        status: status,
        projectType: projectType,
        role: role,
        page: page,
        perPage: perPage,
      );
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
