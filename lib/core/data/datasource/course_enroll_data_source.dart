import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/course_enroll_model.dart';

const _studentCoursesUrl =
    'https://workspace.hbconsulting-services.com/api/student/courses';

abstract class CourseEnrollDataSource {
  Future<CourseEnrollResult> enroll(int courseId);
}

class CourseEnrollDataSourceImpl implements CourseEnrollDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<CourseEnrollResult> enroll(int courseId) async {
    try {
      final response = await _dio.post('$_studentCoursesUrl/$courseId/enroll');

      final data = response.data;
      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300 && data is Map && data['status'] == true) {
        return CourseEnrollResult.fromResponse(Map<String, dynamic>.from(data));
      }
      throw Exception(
        (data is Map ? data['message'] : null) ?? 'فشل التسجيل في الدورة.',
      );
    } on dio.DioException catch (e) {
      throw Exception('Network error while enrolling: ${e.message}');
    }
  }
}
