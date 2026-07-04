import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/job_application_model.dart';
import 'package:dio/dio.dart' as dio;

abstract class JobApplicationDataSource {
  Future<JobApplicationsResult> getJobApplications(int jobId, {int page});
}

class JobApplicationDataSourceImpl extends JobApplicationDataSource {
  static final JobApplicationDataSourceImpl _instance = JobApplicationDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  /// Private constructor for singleton pattern
  JobApplicationDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  /// Factory constructor to return singleton instance
  factory JobApplicationDataSourceImpl() {
    return _instance;
  }

  @override
  Future<JobApplicationsResult> getJobApplications(int jobId, {int page = 1}) async {
    try {
      final response = await _remoteConnectionDio.dio.get(
        '${Constants.jobsUrl}/$jobId/applicants',
        queryParameters: {'page': page},
      );

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        if (data == null || data['data'] == null || data['data']['applicants'] == null) {
          throw Exception('Jobs data is null');
        }

        final List jobsJson = data['data']['applicants'];
        final pag = data['data']['pagination'] as Map? ?? {};

        return JobApplicationsResult(
          items: jobsJson.map((job) => JobApplicationModel.fromJson(job)).toList(),
          currentPage: pag['current_page'] ?? 1,
          totalPages: pag['total_pages'] ?? 1,
          total: pag['total'] ?? jobsJson.length,
          perPage: pag['per_page'] ?? 10,
        );
      } else {
        throw Exception("Failed to load Jobs Applications: Status ${response.statusCode}");
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching Jobs Applications: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching Jobs Applications: $e');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    return response.statusCode == 200;
  }
}
