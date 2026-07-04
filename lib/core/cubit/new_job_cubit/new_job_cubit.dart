import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/job_and_talent_cubit/job_and_talent_cubit.dart';
import 'package:hb/core/cubit/new_job_cubit/new_job_state.dart';
import 'package:hb/core/cubit/payment_types_cubit/payment_types_cubit.dart';
import 'package:hb/core/cubit/project_types_cubit/project_types_cubit.dart';
import 'package:hb/core/cubit/skills_cubit/skills_cubit.dart';
import 'package:hb/core/service_locator/usecases.dart';

class NewJobCubit extends Cubit<NewJobState> {
  NewJobCubit() : super(NewJobState());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController budgetMinController = TextEditingController();
  final TextEditingController budgetMaxController = TextEditingController();
  final TextEditingController jobFileController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? deadlineDate;
  void setDeadline(DateTime date) {
    deadlineDate = date;
    emit(state.copyWith());
  }

  PlatformFile? selectedJobFile;
  void setJobFile(PlatformFile file) {
    selectedJobFile = file;
    emit(state.copyWith());
  }

  String? selectedJobType;
  void setJobType(String type) {
    selectedJobType = type;
  }

  Future<void> newJop(BuildContext context) async {
    log('Starting new job submission');
    emit(state.copyWith(loading: true, success: false));

    try {
      final skillsCubit = context.read<SkillsCubit>();
      final projectTypesCubit = context.read<ProjectTypesCubit>();
      final paymentTypesCubit = context.read<PaymentTypesCubit>();

      await UseCases.getJobAndTalentUsecase.addJob(
        context: context,
        jobData: {
          'title': titleController.text,
          'description': descriptionController.text,
          'type': selectedJobType,
          'deadline': deadlineDate?.toIso8601String(),
          'budget_min': budgetMinController.text,
          'budget_max': budgetMaxController.text,
          'project_type': projectTypesCubit.state.selectedProjectType,
          'payment_type': paymentTypesCubit.state.selectedPaymentType,
          'required_skills': skillsCubit.state.selectedSkills,
          'files': selectedJobFile != null ? [selectedJobFile!] : [],
        },
      );

      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      log('Error in newJop: $e');
      emit(state.copyWith(loading: false, success: false, errorMassage: e.toString()));
    }
  }
  void resetForm(BuildContext context) {
  titleController.clear();
  budgetMinController.clear();
  budgetMaxController.clear();
  jobFileController.clear();
  deadlineController.clear();
  descriptionController.clear();

  deadlineDate = null;
  selectedJobFile = null;
  selectedJobType = null;

  // reset الـ cubits الخارجية
  context.read<SkillsCubit>().clearSkills();
  context.read<ProjectTypesCubit>().clearProjectType();
  context.read<PaymentTypesCubit>().clearPaymentType();

  emit(state.copyWith(success: false, errorMassage: null));
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
