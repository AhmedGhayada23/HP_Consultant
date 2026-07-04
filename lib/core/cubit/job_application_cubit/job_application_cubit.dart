import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/job_application_cubit/job_application_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class JobApplicationCubit extends Cubit<JobApplicationState> {
  JobApplicationCubit() : super(JobApplicationState());

  Future<void> fetchJobApplication(int jobId, {int page = 1}) async {
    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      final result = await UseCases.getJobApplicationUsecase.call(jobId, page: page);
      emit(state.copyWith(
        data: result.items,
        loading: false,
        currentPage: result.currentPage,
        totalPages: result.totalPages,
        total: result.total,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
