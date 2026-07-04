import 'package:hb/core/data/datasource/completed_courses_data_source.dart';
import 'package:hb/core/data/models/completed_course_model.dart';

abstract class CompletedCoursesRepository {
  Future<List<CompletedCourseModel>> getCompletedCourses();
}

class CompletedCoursesRepositoryImpl implements CompletedCoursesRepository {
  final CompletedCoursesDataSource dataSource;
  CompletedCoursesRepositoryImpl(this.dataSource);

  @override
  Future<List<CompletedCourseModel>> getCompletedCourses() {
    return dataSource.getCompletedCourses();
  }
}
