// ═══════════════════════════════════════════════════════════
// 6. CUBIT
// lib/core/cubit/courses_cubit/courses_cubit.dart
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/training_courses_cubit/training_courses_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class TrainingCoursesCubit extends Cubit<TrainingCoursesState> {
  TrainingCoursesCubit() : super(TrainingCoursesState());
  Future<void> fetchCourses({
    String? category,
    String? range,
    String? duration,
    String? leve,
    String? search,
  }) async {
    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      final data = await UseCases.getTrainingCoursesUsecase(
        search: search,
        category: category,
        range: range,
        leve: leve,
        duration: duration,
      );
      emit(state.copyWith(courses: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
