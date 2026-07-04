import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/job_details_cubit/job_details_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class JobDetailsCubit extends Cubit<JobDetailsState> {
  JobDetailsCubit() : super(JobDetailsState());

void fetchJobDetails(int jobId) async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));
    try {
     final data = await UseCases.getJobAndTalentUsecase.getJobsDetails(jobId);
      emit(state.copyWith(jobDetails: data, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
