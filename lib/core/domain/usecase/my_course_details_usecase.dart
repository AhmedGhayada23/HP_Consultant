import 'package:hb/core/data/models/my_course_details_model.dart';
import 'package:hb/core/domain/repository/my_course_details_repository.dart';

class MyCourseDetailsUsecase {
  final MyCourseDetailsRepository repository;
  MyCourseDetailsUsecase(this.repository);

  Future<MyCourseDetailsModel> call(int courseId) {
    return repository.getMyCourseDetails(courseId);
  }

  Future<void> completeLesson(int lessonId) =>
      repository.completeLesson(lessonId);
}
