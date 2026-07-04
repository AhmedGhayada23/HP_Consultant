import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/details_my_application_model.dart';

const _jobApplicationsUrl =
    'https://workspace.hbconsulting-services.com/api/student/job-applications';

abstract class DetailsMyApplicationDataSource {
  Future<DetailsMyApplicationModel> getDetails(int applicationId);
}

class DetailsMyApplicationDataSourceImpl implements DetailsMyApplicationDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<DetailsMyApplicationModel> getDetails(int applicationId) async {
    try {
      final response = await _dio.get('$_jobApplicationsUrl/$applicationId');
      final data = response.data;
      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300 && data is Map && data['data'] != null) {
        return DetailsMyApplicationModel.fromJson(Map<String, dynamic>.from(data));
      }
      throw Exception(
        (data is Map ? data['message'] : null) ?? 'فشل جلب تفاصيل الطلب.',
      );
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching application details: ${e.message}');
    }
  }
}
