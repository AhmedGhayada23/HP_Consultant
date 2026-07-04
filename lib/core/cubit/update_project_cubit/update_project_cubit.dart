import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/payment_types_cubit/payment_types_cubit.dart';
import 'package:hb/core/cubit/project_types_cubit/project_types_cubit.dart';
import 'package:hb/core/cubit/update_project_cubit/update_project_state.dart';
import 'package:hb/core/data/models/milestone_model.dart';
import 'package:hb/core/service_locator/usecases.dart';

class UpdateProjectCubit extends Cubit<UpdateProjectState> {
  UpdateProjectCubit() : super(UpdateProjectState());

  List<MilestoneModel> milestones = [];

  // Project Controllers
  final TextEditingController titleProjectController = TextEditingController();
  final TextEditingController projectTypeController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController jobFileController = TextEditingController();
  final TextEditingController descriotionController = TextEditingController();

  // Milestone Controllers
  final TextEditingController milestoneTitleController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController budgetAllocationController = TextEditingController();
  final TextEditingController deliverablesDecController = TextEditingController();

  DateTime? deadlineDate;
  DateTime? startDate;
  int? selectedAssignTo;

  // ✅ حقول الـ dropdowns
  String? selectedCategory;
  String? selectedPriority;
  void setDeadline(DateTime date) => emit(state.copyWith(deadlineDate: date,loading: false,success: false));

  void setStartDate(DateTime date) => emit(state.copyWith(startDate: date,loading: false,success: false));

  void setAssignTo(int userId) => emit(state.copyWith(selectedAssignTo: userId,loading: false,success: false));

  void setCategory(String category) => emit(state.copyWith(selectedCategory: category,loading: false,success: false));

  void setPriority(String priority) => emit(state.copyWith(selectedPriority: priority,loading: false,success: false));

  void addMilestone(MilestoneModel milestone) =>
      emit(state.copyWith(milestones: [...state.milestones, milestone]));

  void removeMilestone(int index) {
    final updated = [...state.milestones]..removeAt(index);
    emit(state.copyWith(milestones: updated,loading: false,success: false));
  }

  void clearMilestoneFields() {
    milestoneTitleController.clear();
    dueDateController.clear();
    budgetAllocationController.clear();
    deliverablesDecController.clear();
    selectedAssignTo = null;
  }

  List<Map<String, dynamic>> getMilestonesJson() {
    return milestones.map((m) => m.toJson()).toList();
  }

  void updateProject(BuildContext context, int projectId) async {
    emit(state.copyWith(loading: true, success: false));

    try {
      final projectTypesCubit = context.read<ProjectTypesCubit>();
      final paymentTypesCubit = context.read<PaymentTypesCubit>();

      // ✅ الـ projectData كاملاً مطابق للـ JSON المطلوب
      final Map<String, dynamic> projectData = {
        'title': titleProjectController.text,
        'category': selectedCategory ?? '',
        'project_type': projectTypesCubit.state.selectedProjectType ?? '',
        'start_date': startDateController.text,
        'deadline': deadlineController.text,
        'budget': double.tryParse(budgetController.text) ?? 0,
        'payment_type': paymentTypesCubit.state.selectedPaymentType ?? '',
        'priority': selectedPriority ?? '',
        'description': descriotionController.text,
        'milestones': getMilestonesJson(), // ✅ List<Map<String, dynamic>>
      };

      await UseCases.getConsultantProjectUsecase.updateProject(
        context: context,
        projectId: projectId,
        projectData: projectData,
      );

      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMassage: e.toString(),success: false));
    }
  }

  void clearAllData() {
    // Project Controllers
    titleProjectController.clear();
    projectTypeController.clear();
    startDateController.clear();
    deadlineController.clear();
    budgetController.clear();
    jobFileController.clear();
    descriotionController.clear();

    // Milestone Controllers
    milestoneTitleController.clear();
    dueDateController.clear();
    budgetAllocationController.clear();
    deliverablesDecController.clear();

    // Reset Dates
    deadlineDate = null;
    startDate = null;

    // Reset selections
    selectedAssignTo = null;
    selectedCategory = null;
    selectedPriority = null;

    // Clear milestones list
    milestones.clear();
  }
}
