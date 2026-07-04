import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/details_job_project_model.dart';

abstract class DetailsJobProjectDataSource {
  Future<DetailsJobProjectModel> getDetailsJobProject(int jobId);
}

class DetailsJobProjectDataSourceImpl extends DetailsJobProjectDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<DetailsJobProjectModel> getDetailsJobProject(int jobId) async {
    try {
      final response =
          await _dio.get('${Constants.consultantProjectsUrl}/$jobId');

      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        final body = response.data as Map<String, dynamic>? ?? {};
        if (body['data'] == null) {
          throw Exception(body['message'] ?? 'فشل جلب تفاصيل الوظيفة.');
        }
        return DetailsJobProjectModel.fromJson(body);
      }
      throw Exception('Failed to load job details: Status ${response.statusCode}');
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching job details: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching job details: $e');
    }
  }
}
