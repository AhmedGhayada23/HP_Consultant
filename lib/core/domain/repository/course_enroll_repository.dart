import 'package:hb/core/data/datasource/course_enroll_data_source.dart';
import 'package:hb/core/data/models/course_enroll_model.dart';

abstract class CourseEnrollRepository {
  Future<CourseEnrollResult> enroll(int courseId);
}

class CourseEnrollRepositoryImpl implements CourseEnrollRepository {
  final CourseEnrollDataSource dataSource;
  CourseEnrollRepositoryImpl(this.dataSource);

  @override
  Future<CourseEnrollResult> enroll(int courseId) {
    return dataSource.enroll(courseId);
  }
}
