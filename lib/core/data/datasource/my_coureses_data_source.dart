import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/my_coureses_model.dart';

const _myCoursesUrl =
    'https://workspace.hbconsulting-services.com/api/student/my-courses';

abstract class MyCouresesDataSource {
  Future<List<MyCouresesModel>> getMyCourses();
}

class MyCouresesDataSourceImpl extends MyCouresesDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<List<MyCouresesModel>> getMyCourses() async {
    try {
      final response = await _dio.get(_myCoursesUrl);

      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        final data = response.data;
        final List list = (data is Map ? data['data'] : null) ?? [];
        return list
            .map((e) => MyCouresesModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      throw Exception('Failed to load my courses: Status ${response.statusCode}');
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching my courses: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching my courses: $e');
    }
  }
}
