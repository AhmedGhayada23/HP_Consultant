import 'package:hb/core/data/models/completed_course_model.dart';
import 'package:hb/core/domain/repository/completed_courses_repository.dart';

class CompletedCoursesUsecase {
  final CompletedCoursesRepository repository;
  CompletedCoursesUsecase(this.repository);

  Future<List<CompletedCourseModel>> call() {
    return repository.getCompletedCourses();
  }
}
