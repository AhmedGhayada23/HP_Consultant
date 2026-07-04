// ═══════════════════════════════════════════════════════════
// 4. USE CASE
// lib/core/domain/usecases/get_courses_usecase.dart
// ═══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:hb/core/data/models/course_details_model.dart';
import 'package:hb/core/data/models/training_course_model.dart';
import 'package:hb/core/domain/repository/training_courses_repository.dart';

class GetTrainingCoursesUsecase {
  final TrainingCoursesRepository _repository;

  GetTrainingCoursesUsecase(this._repository);

  Future<List<TrainingCourseModel>> call({
    String? category,
    String? range,
    String? duration,
    String? leve,
    String? search,
  }) {
    return _repository.getCourses(
      search: search,
      category: category,
      range: range,
      leve: leve,
      duration: duration,
    );
  }

  Future<CourseDetailsModel> getCourseDetails(int courseId) async {
    return await _repository.getCourseDetails(courseId);
  }

  Future<void> purchaseCourse(BuildContext context,{required int courseId}) async {
    return await _repository.purchaseCourse(context,courseId: courseId);
  }
}
