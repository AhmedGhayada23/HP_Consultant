import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/job_opportunity_details_cubit/job_opportunity_details_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class JobOpportunityDetailsCubit extends Cubit<JobOpportunityDetailsState> {
  JobOpportunityDetailsCubit() : super(JobOpportunityDetailsState());

  Future<void> fetchJobDetails(int jobId) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.jobOpportunityDetailsUsecase.call(jobId);
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
