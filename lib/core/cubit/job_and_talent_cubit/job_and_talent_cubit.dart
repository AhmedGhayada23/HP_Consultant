import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/job_and_talent_cubit/job_and_talent_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class JobAndTalentCubit extends Cubit<JobAndTalentState> {
  JobAndTalentCubit() : super(JobAndTalentState());

  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController createdOnController = TextEditingController();


  Future<void> fetchJobsAndTalent({
    String? name,
    String? status,
    String? createdOn,
    String? deadline,
  }) async {
    emit(state.copyWith(loading: true));

    try {
      final jobs = await UseCases.getJobAndTalentUsecase(
        name: name,
        status: status,
        createdOn: createdOn,
        deadline: deadline,
      );
      emit(state.copyWith(jobData: jobs, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  // ✅ يغير الـ status محلياً بدون fetch جديد
  void closeJobLocally(int jobId) {
    final updatedJobs = state.jobData?.map((job) {
      if (job.id == jobId) {
        return job.copyWith(status: 'closed', statusColor: 'red');
      }
      return job;
    }).toList();

    emit(state.copyWith(jobData: updatedJobs));
  }
}
