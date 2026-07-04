import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/jobs_internship_model.dart';

const _studentJobsUrl =
    'https://workspace.hbconsulting-services.com/api/student/jobs';

abstract class JobsInternshipDataSource {
  Future<List<JobsInternshipModel>> getJobsInternships({
    String? search,
    int? categoryId,
    String? jobType,
    String? minBudget,
    String? maxBudget,
    String? deadlineFrom,
    String? deadlineTo,
    int page,
    int perPage,
  });
}

class JobsInternshipDataSourceImpl implements JobsInternshipDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<List<JobsInternshipModel>> getJobsInternships({
    String? search,
    int? categoryId,
    String? jobType,
    String? minBudget,
    String? maxBudget,
    String? deadlineFrom,
    String? deadlineTo,
    int page = 1,
    int perPage = 15,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
      if (categoryId != null) 'category_id': categoryId,
      if (jobType != null && jobType.isNotEmpty) 'job_type': jobType,
      if (minBudget != null && minBudget.isNotEmpty) 'min_budget': minBudget,
      if (maxBudget != null && maxBudget.isNotEmpty) 'max_budget': maxBudget,
      if (deadlineFrom != null && deadlineFrom.isNotEmpty) 'deadline_from': deadlineFrom,
      if (deadlineTo != null && deadlineTo.isNotEmpty) 'deadline_to': deadlineTo,
    };

    try {
      final response = await _dio.get(_studentJobsUrl, queryParameters: params);
      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        final data = response.data;
        final List list = (data is Map ? data['data'] : null) ?? [];
        return list
            .map((e) => JobsInternshipModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      throw Exception('Failed to load jobs: Status ${response.statusCode}');
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching jobs: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching jobs: $e');
    }
  }
}
