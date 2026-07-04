import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/job_and_talent_cubit/job_and_talent_cubit.dart';
import 'package:hb/core/cubit/update_job_cubit/update_job_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class UpdateJobCubit extends Cubit<UpdateJobState> {
  UpdateJobCubit() : super(UpdateJobState());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController budgetMinController = TextEditingController();
  final TextEditingController budgetMaxController = TextEditingController();
  final TextEditingController jobFileController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? deadlineDate;
  void setDeadline(DateTime date) {
    deadlineDate = date;
    emit(state.copyWith(success: false,isLoading: false,errorMessage: null));
  }

  PlatformFile? selectedJobFile;
  void setJobFile(PlatformFile file) {
    selectedJobFile = file;
    emit(state.copyWith(success: false,isLoading: false,errorMessage: null));
  }

  String? selectedJobType;
  void setJobType(String type) {
    selectedJobType = type;
  }

  Future<void> updateJob({
    required Map<String, dynamic> jobData,
    required int jobId,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, success: false));
    try {
      final message = await UseCases.getJobAndTalentUsecase.updateJob(
        jobData: jobData,
        jobId: jobId,
      );
      emit(state.copyWith(success: true, isLoading: false, message: message));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: e.toString(), success: false));
    }
  }

  Future<void> pickJobFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        setJobFile(result.files.first);
        jobFileController.text = result.files.first.name;
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to pick file: $e'));
    }
  }

  Future<void> closeJob({BuildContext? context, required int jobId}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await UseCases.getJobAndTalentUsecase.closeJob(context: context, jobId: jobId);
      emit(state.copyWith(success: true, isLoading: false));

      // ✅ حدّث الـ status محلياً بدون fetch
      if (context != null && context.mounted) {
        context.read<JobAndTalentCubit>().closeJobLocally(jobId);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    titleController.dispose();
    budgetMinController.dispose();
    budgetMaxController.dispose();
    jobFileController.dispose();
    deadlineController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
