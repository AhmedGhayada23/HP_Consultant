// lib/featuer/my_coureses/presentation/cubit/courses_state.dart
import 'package:hb/core/data/models/my_coureses_model.dart';

class MyCoursesState {
  final List<MyCouresesModel>? data;
  final bool? loading;
  final String? errorMessage;

  MyCoursesState({
    this.data,
    this.loading,
    this.errorMessage,
  });

  MyCoursesState copyWith({
    List<MyCouresesModel>? data,
    bool? loading,
    String? errorMessage,
  }) {
    return MyCoursesState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
