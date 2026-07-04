import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/details_application_model.dart';

abstract class DetailsApplicationDataSource {
  Future<DetailsApplicationModel> getDetailsApplication(int applicationId);
}

class DetailsApplicationDataSourceImpl extends DetailsApplicationDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<DetailsApplicationModel> getDetailsApplication(int applicationId) async {
    try {
      final response =
          await _dio.get('${Constants.baseUrl}/applications/$applicationId');

      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return DetailsApplicationModel.fromJson(data);
        }
        return DetailsApplicationModel();
      }
      throw Exception('Failed to load application details: Status ${response.statusCode}');
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching application details: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching application details: $e');
    }
  }
}
