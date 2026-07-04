import 'package:hb/core/data/datasource/purchased_course_remote_datasource.dart';
import 'package:hb/core/data/models/purchased_course_model.dart';

abstract class GetPurchasedCourseRepository {
  Future<List<PurchasedCourseModle>> getPurchasedCourse({
    String? status,
    String? search,
    String? timeline,
  });
}

class GetPurchasedCourseRepositoryImpl extends GetPurchasedCourseRepository {
  final PurchasedCourseDatasource _datasource;
  GetPurchasedCourseRepositoryImpl(this._datasource);

  @override
  Future<List<PurchasedCourseModle>> getPurchasedCourse({
    String? status,
    String? search,
    String? timeline,
  }) {
    return _datasource.getPurchasedCourse(
      search: search,status: status,timeline: timeline
    );
  }
}
