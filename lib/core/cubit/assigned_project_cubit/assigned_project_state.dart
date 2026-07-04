import 'package:hb/core/data/models/assigned_project_model.dart';

class AssignedProjectState {
  final List<AssignedProjectModel>? data;
  final bool? loading;
  final String? errorMessage;

  AssignedProjectState({this.data, this.loading, this.errorMessage});

  AssignedProjectState copyWith({
    List<AssignedProjectModel>? data,
    bool? loading,
    String? errorMessage,
  }) {
    return AssignedProjectState(
       data: data ?? this.data,
       loading: loading ?? this.loading,
       errorMessage:  errorMessage ?? this.errorMessage,
    );
  }
}
