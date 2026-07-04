import 'package:hb/core/data/datasource/my_course_details_data_source.dart';
import 'package:hb/core/data/models/my_course_details_model.dart';

abstract class MyCourseDetailsRepository {
  Future<MyCourseDetailsModel> getMyCourseDetails(int courseId);
  Future<void> completeLesson(int lessonId);
}

class MyCourseDetailsRepositoryImpl implements MyCourseDetailsRepository {
  final MyCourseDetailsDataSource dataSource;
  MyCourseDetailsRepositoryImpl(this.dataSource);

  @override
  Future<MyCourseDetailsModel> getMyCourseDetails(int courseId) {
    return dataSource.getMyCourseDetails(courseId);
  }

  @override
  Future<void> completeLesson(int lessonId) =>
      dataSource.completeLesson(lessonId);
}
