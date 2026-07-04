import 'package:hb/core/data/models/course_enroll_model.dart';

class CourseEnrollState {
  final int? loadingCourseId;
  final CourseEnrollResult? result;
  final String? errorMessage;

  CourseEnrollState({this.loadingCourseId, this.result, this.errorMessage});
}
