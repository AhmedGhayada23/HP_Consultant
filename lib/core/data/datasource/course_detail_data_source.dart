import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/course_detail_model.dart';

const _studentCoursesUrl =
    'https://workspace.hbconsulting-services.com/api/student/courses';

abstract class CourseDetailDataSource {
  Future<CourseDetailModel> getCourseDetail(int courseId);
}

class CourseDetailDataSourceImpl implements CourseDetailDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<CourseDetailModel> getCourseDetail(int courseId) async {
    final response = await _dio.get('$_studentCoursesUrl/$courseId');

    final data = response.data;
    if (data is Map && data['status'] == true && data['data'] != null) {
      return CourseDetailModel.fromJson(
        Map<String, dynamic>.from(data['data'] as Map),
      );
    }

    throw Exception(
      (data is Map ? data['message'] : null) ?? 'فشل جلب تفاصيل الدورة.',
    );
  }
}
