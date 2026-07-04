import 'package:hb/core/data/datasource/course_remote_data_source.dart';
import 'package:hb/core/data/models/course_model.dart';

abstract class CourseRepository {
  Future<CourseListResult> getAllCourses({
    String? search,
    String? level,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    int? durationMin,
    int? durationMax,
    int page,
    int perPage,
  });
}

class CourseRepositoryImpl implements CourseRepository {
  final CourseDataSource dataSource;

  CourseRepositoryImpl(this.dataSource);

  @override
  Future<CourseListResult> getAllCourses({
    String? search,
    String? level,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    int? durationMin,
    int? durationMax,
    int page = 1,
    int perPage = 15,
  }) {
    return dataSource.getCourses(
      search: search,
      level: level,
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      durationMin: durationMin,
      durationMax: durationMax,
      page: page,
      perPage: perPage,
    );
  }
}
