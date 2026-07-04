import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/active_project_cubit/active_project_cubit.dart';
import 'package:hb/core/cubit/add_project_cubit/add_project_state.dart';
import 'package:hb/core/cubit/payment_types_cubit/payment_types_cubit.dart';
import 'package:hb/core/cubit/project_types_cubit/project_types_cubit.dart';
import 'package:hb/core/data/models/milestone_model.dart';
import 'package:hb/core/service_locator/usecases.dart';

class AddProjectCubit extends Cubit<AddProjectState> {
  AddProjectCubit() : super(AddProjectState());

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

  String? selectedCategory;
  String? selectedPriority;

  void setDeadline(DateTime date) {
    deadlineDate = date;
    emit(state.copyWith());
  }

  void setStartDate(DateTime date) {
    startDate = date;
    emit(state.copyWith());
  }

  void setAssignTo(int userId) {
    selectedAssignTo = userId;
    emit(state.copyWith());
  }

  void setCategory(String category) {
    selectedCategory = category;
    emit(state.copyWith());
  }

  void setPriority(String priority) {
    selectedPriority = priority;
    emit(state.copyWith());
  }

  void addMilestone(MilestoneModel milestone) {
    milestones.add(milestone);
    emit(state.copyWith());
  }

  void removeMilestone(int index) {
    milestones.removeAt(index);
    emit(state.copyWith());
  }

  void clearMilestoneFields() {
    milestoneTitleController.clear();
    dueDateController.clear();
    budgetAllocationController.clear();
    deliverablesDecController.clear();
    selectedAssignTo = null;
  }

  // تفريغ جميع بيانات النموذج بعد نجاح الإرسال
  void clearAll() {
    // حقول المشروع
    titleProjectController.clear();
    projectTypeController.clear();
    startDateController.clear();
    deadlineController.clear();
    budgetController.clear();
    jobFileController.clear();
    descriotionController.clear();
    // حقول المرحلة
    milestoneTitleController.clear();
    dueDateController.clear();
    budgetAllocationController.clear();
    deliverablesDecController.clear();
    // التواريخ والاختيارات
    deadlineDate = null;
    startDate = null;
    selectedAssignTo = null;
    selectedCategory = null;
    selectedPriority = null;
    // قائمة المراحل
    milestones = [];
    // إعادة ضبط الحالة (state جديدة لمنع إعادة تشغيل listener)
    emit(AddProjectState());
  }

  List<Map<String, dynamic>> getMilestonesJson() {
    return milestones.map((m) => m.toJson()).toList();
  }

  Future<void> newProject(BuildContext context) async {
    emit(state.copyWith(loading: true, success: false));

    try {
      final projectTypesCubit = context.read<ProjectTypesCubit>();
      final paymentTypesCubit = context.read<PaymentTypesCubit>();

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
        'milestones': getMilestonesJson(),
      };

      await UseCases.getConsultantProjectUsecase.addProject(
        context: context,
        projectData: projectData,
      );

      emit(state.copyWith(loading: false, success: true));


    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    titleProjectController.dispose();
    projectTypeController.dispose();
    startDateController.dispose();
    deadlineController.dispose();
    budgetController.dispose();
    jobFileController.dispose();
    descriotionController.dispose();
    milestoneTitleController.dispose();
    dueDateController.dispose();
    budgetAllocationController.dispose();
    deliverablesDecController.dispose();
    return super.close();
  }
}
