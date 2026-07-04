import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/completed_course_model.dart';

const _completedCoursesUrl =
    'https://workspace.hbconsulting-services.com/api/student/completed-training-courses';

abstract class CompletedCoursesDataSource {
  Future<List<CompletedCourseModel>> getCompletedCourses();
}

class CompletedCoursesDataSourceImpl implements CompletedCoursesDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<List<CompletedCourseModel>> getCompletedCourses() async {
    try {
      final response = await _dio.get(_completedCoursesUrl);
      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        final data = response.data;
        final List list = (data is Map ? data['data'] : null) ?? [];
        return list
            .map((e) => CompletedCourseModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      throw Exception('Failed to load completed courses: Status ${response.statusCode}');
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching completed courses: ${e.message}');
    }
  }
}
