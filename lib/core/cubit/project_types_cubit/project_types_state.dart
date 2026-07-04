import 'package:hb/core/data/models/project_types_model.dart';

class ProjectTypesState {
  final List<ProjectTypesModel>? projectTypes;
  final String? selectedProjectType;
  final String? errorMessage;
  final bool isLoading;

  ProjectTypesState({
    this.projectTypes,
    this.selectedProjectType,
    this.errorMessage,
    this.isLoading = false,
  });

  ProjectTypesState copyWith({
    List<ProjectTypesModel>? projectTypes,
    String? selectedProjectType,
    String? errorMessage,
    bool? isLoading,
  }) {
    return ProjectTypesState(
      projectTypes: projectTypes ?? this.projectTypes,
      selectedProjectType: selectedProjectType ?? this.selectedProjectType,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
