import 'package:hb/core/data/models/purchased_course_model.dart';
import 'package:hb/core/domain/repository/employee_developer_repository.dart';

class GetPurchasedCourseUsecase {
  final GetPurchasedCourseRepository _repository;

  GetPurchasedCourseUsecase(this._repository);

  Future<List<PurchasedCourseModle>> call({String? status, String? search, String? timeline}) {
    return _repository.getPurchasedCourse(
      search: search,status: status,timeline: timeline
    );
  }
}
