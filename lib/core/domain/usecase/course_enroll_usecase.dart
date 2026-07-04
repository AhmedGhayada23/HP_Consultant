import 'package:hb/core/data/models/course_enroll_model.dart';
import 'package:hb/core/domain/repository/course_enroll_repository.dart';

class CourseEnrollUsecase {
  final CourseEnrollRepository repository;
  CourseEnrollUsecase(this.repository);

  Future<CourseEnrollResult> call(int courseId) {
    return repository.enroll(courseId);
  }
}
