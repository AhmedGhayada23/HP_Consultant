import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/my_course_details_model.dart';

const _myCoursesUrl =
    'https://workspace.hbconsulting-services.com/api/student/my-courses';
const _lessonsUrl =
    'https://workspace.hbconsulting-services.com/api/student/lessons';

abstract class MyCourseDetailsDataSource {
  Future<MyCourseDetailsModel> getMyCourseDetails(int courseId);
  Future<void> completeLesson(int lessonId);
}

class MyCourseDetailsDataSourceImpl implements MyCourseDetailsDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<MyCourseDetailsModel> getMyCourseDetails(int courseId) async {
    try {
      final response = await _dio.get('$_myCoursesUrl/$courseId');
      final data = response.data;
      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300 && data is Map && data['data'] != null) {
        return MyCourseDetailsModel.fromJson(Map<String, dynamic>.from(data));
      }
      throw Exception(
        (data is Map ? data['message'] : null) ?? 'فشل جلب تفاصيل الدورة.',
      );
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching course details: ${e.message}');
    }
  }

  @override
  Future<void> completeLesson(int lessonId) async {
    try {
      final response = await _dio.post('$_lessonsUrl/$lessonId/complete');
      final data = response.data;
      final code = response.statusCode ?? 0;
      final ok = code >= 200 &&
          code < 300 &&
          (data is Map ? data['status'] != false : true);
      if (!ok) {
        throw Exception(
          (data is Map ? data['message'] : null) ?? 'فشل تسجيل إكمال الدرس.',
        );
      }
    } on dio.DioException catch (e) {
      final d = e.response?.data;
      final msg = d is Map ? d['message'] : null;
      throw Exception(msg ?? 'Network error while completing lesson: ${e.message}');
    }
  }
}
