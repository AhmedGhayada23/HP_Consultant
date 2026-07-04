import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/job_opportunity_details_model.dart';

const _studentJobsUrl =
    'https://workspace.hbconsulting-services.com/api/student/jobs';

abstract class JobOpportunityDetailsDataSource {
  Future<JobOpportunityDetailsModel> getJobDetails(int jobId);
}

class JobOpportunityDetailsDataSourceImpl implements JobOpportunityDetailsDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<JobOpportunityDetailsModel> getJobDetails(int jobId) async {
    try {
      final response = await _dio.get('$_studentJobsUrl/$jobId');
      final data = response.data;
      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300 && data is Map && data['data'] != null) {
        return JobOpportunityDetailsModel.fromJson(Map<String, dynamic>.from(data));
      }
      throw Exception(
        (data is Map ? data['message'] : null) ?? 'فشل جلب تفاصيل الفرصة.',
      );
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching job details: ${e.message}');
    }
  }
}
