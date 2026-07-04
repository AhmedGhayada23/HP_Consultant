import 'package:hb/core/data/models/course_model.dart';
import 'package:hb/core/domain/repository/course_repository.dart';

class GetCoursesUseCase {
  final CourseRepository repository;

  GetCoursesUseCase(this.repository);

  Future<CourseListResult> call({
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
    return repository.getAllCourses(
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
