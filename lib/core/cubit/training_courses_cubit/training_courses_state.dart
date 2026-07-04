// ═══════════════════════════════════════════════════════════
// 5. STATE
// lib/core/cubit/courses_cubit/courses_state.dart
// ═══════════════════════════════════════════════════════════

import 'package:hb/core/data/models/training_course_model.dart';

class TrainingCoursesState {
  final List<TrainingCourseModel>? courses;
  final bool loading;
  final String? errorMessage;

  TrainingCoursesState({this.courses, this.loading = false, this.errorMessage});

  TrainingCoursesState copyWith({List<TrainingCourseModel>? courses, bool? loading, String? errorMessage}) {
    return TrainingCoursesState(
      courses: courses ?? this.courses,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
