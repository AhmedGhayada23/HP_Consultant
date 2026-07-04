import 'package:hb/core/data/models/completed_course_model.dart';

class CompletedCoursesState {
  final List<CompletedCourseModel>? data;
  final bool loading;
  final String? errorMessage;

  CompletedCoursesState({this.data, this.loading = false, this.errorMessage});

  CompletedCoursesState copyWith({
    List<CompletedCourseModel>? data,
    bool? loading,
    String? errorMessage,
  }) {
    return CompletedCoursesState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }
}
