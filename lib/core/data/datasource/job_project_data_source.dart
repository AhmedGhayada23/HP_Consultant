import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/job_project_model.dart';

abstract class JobProjectDataSource {
  Future<List<JobProjectModel>> getJobProject({
    String? search,
    String? status,
    String? projectType,
    String? role,
    int page,
    int perPage,
  });
}

class JobProjectDataSourceImpl extends JobProjectDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<List<JobProjectModel>> getJobProject({
    String? search,
    String? status,
    String? projectType,
    String? role,
    int page = 1,
    int perPage = 15,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
      if (status != null && status.isNotEmpty) 'status': status,
      if (projectType != null && projectType.isNotEmpty) 'project_type': projectType,
      if (role != null && role.isNotEmpty) 'role': role,
    };

    try {
      final response = await _dio.get(
        Constants.consultantProjectsUrl,
        queryParameters: queryParams,
      );

      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        final body = response.data as Map<String, dynamic>? ?? {};
        return (body['data'] as List? ?? [])
            .map((e) => JobProjectModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      throw Exception('Failed to load projects: Status ${response.statusCode}');
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching projects: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching projects: $e');
    }
  }
}
