import 'package:hb/core/data/datasource/course_detail_data_source.dart';
import 'package:hb/core/data/models/course_detail_model.dart';

abstract class CourseDetailRepository {
  Future<CourseDetailModel> getCourseDetail(int courseId);
}

class CourseDetailRepositoryImpl implements CourseDetailRepository {
  final CourseDetailDataSource dataSource;

  CourseDetailRepositoryImpl(this.dataSource);

  @override
  Future<CourseDetailModel> getCourseDetail(int courseId) {
    return dataSource.getCourseDetail(courseId);
  }
}
