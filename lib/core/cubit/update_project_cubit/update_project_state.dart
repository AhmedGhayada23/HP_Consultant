import 'package:hb/core/data/models/milestone_model.dart';

class UpdateProjectState {
  final bool? success;
  final bool? loading;
  final String? errorMassage;

  // ✅ fields للـ UI elements
  final DateTime? deadlineDate;
  final DateTime? startDate;
  final int? selectedAssignTo;
  final String? selectedCategory;
  final String? selectedPriority;
  final List<MilestoneModel> milestones;

  UpdateProjectState({
    this.success,
    this.loading,
    this.errorMassage,
    this.deadlineDate,
    this.startDate,
    this.selectedAssignTo,
    this.selectedCategory,
    this.selectedPriority,
    this.milestones = const [],
  });

  UpdateProjectState copyWith({
    bool? success,
    bool? loading,
    String? errorMassage,
    DateTime? deadlineDate,
    DateTime? startDate,
    int? selectedAssignTo,
    String? selectedCategory,
    String? selectedPriority,
    List<MilestoneModel>? milestones,
  }) {
    return UpdateProjectState(
      success: success ?? this.success,
      loading: loading ?? this.loading,
      errorMassage: errorMassage ?? this.errorMassage,
      deadlineDate: deadlineDate ?? this.deadlineDate,
      startDate: startDate ?? this.startDate,
      selectedAssignTo: selectedAssignTo ?? this.selectedAssignTo,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedPriority: selectedPriority ?? this.selectedPriority,
      milestones: milestones ?? this.milestones,
    );
  }
}
