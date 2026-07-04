// ═══════════════════════════════════════════════════════════
// 3. REPOSITORY
// lib/core/domain/repository/courses_repository.dart
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:hb/core/data/datasource/training_courses_remote_datasource.dart';
import 'package:hb/core/data/models/course_details_model.dart';
import 'package:hb/core/data/models/training_course_model.dart';

abstract class TrainingCoursesRepository {
  Future<List<TrainingCourseModel>> getCourses({
    String? category,
    String? range,
    String? duration,
    String? leve,
    String? search,
  });
  Future<CourseDetailsModel> getCourseDetails(int courseId);
  Future<void> purchaseCourse(BuildContext context,{required int courseId});
}

class TrainingCoursesRepositoryImpl extends TrainingCoursesRepository {
  final TrainingCoursesRemoteDatasource _datasource;
  TrainingCoursesRepositoryImpl(this._datasource);

  @override
  Future<List<TrainingCourseModel>> getCourses({
    String? category,
    String? range,
    String? duration,
    String? leve,
    String? search,
  }) {
    return _datasource.getCourses(search: search, category: category, range: range,leve: leve,duration: duration);
  }

  @override
  Future<CourseDetailsModel> getCourseDetails(int courseId) async {
    try {
      return await _datasource.getCourseDetails(courseId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> purchaseCourse(BuildContext context,{required int courseId}) async {
    try {
      return await _datasource.purchaseCourse(context,courseId: courseId);
    } catch (e) {
      rethrow;
    }
  }
}
