import 'package:hb/core/data/models/course_detail_model.dart';
import 'package:hb/core/domain/repository/course_detail_repository.dart';

class GetCourseDetailUseCase {
  final CourseDetailRepository repository;

  GetCourseDetailUseCase(this.repository);

  Future<CourseDetailModel> call(int courseId) async {
    return await repository.getCourseDetail(courseId);
  }
}
