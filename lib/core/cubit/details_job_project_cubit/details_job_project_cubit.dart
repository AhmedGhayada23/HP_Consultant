import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/details_job_project_cubit/details_job_project_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class DetailsJobProjectCubit extends Cubit<DetailsJobProjectState> {
  DetailsJobProjectCubit() : super(DetailsJobProjectState());

  Future<void> fetchDetailsJobProject(int jobId) async {
    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      final data = await UseCases.getDetailsJobProjectUsecase(jobId);
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
