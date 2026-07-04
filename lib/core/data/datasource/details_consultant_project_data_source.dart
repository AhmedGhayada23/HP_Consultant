import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/details_consultant_project_model.dart';
import 'package:dio/dio.dart' as dio;

abstract class DetailsConsultantProjectDataSource {
  Future<DetailsConsultantProjectModel> getDetailsConsultantProject(int id);
}

class DetailsConsultantProjectDataSourceImpl extends DetailsConsultantProjectDataSource {
  static final DetailsConsultantProjectDataSourceImpl _instance =
      DetailsConsultantProjectDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  /// Private constructor for singleton pattern
  DetailsConsultantProjectDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  /// Factory constructor to return singleton instance
  factory DetailsConsultantProjectDataSourceImpl() {
    return _instance;
  }
  @override
  Future<DetailsConsultantProjectModel> getDetailsConsultantProject(int id) async {
    try {
      final response = await _remoteConnectionDio.dio.get('${Constants.consultantsUrl}/$id');

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        if (data == null || data['data'] == null) {
          throw Exception('Jobs Details data is null');
        }

        final Map<String, dynamic> jobsJson = data['data'];

        return DetailsConsultantProjectModel.fromJson(jobsJson);
      } else {
        throw Exception("Failed to load Consultant Details: Status ${response.statusCode}");
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching Consultant Details: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching Consultant Details: $e');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    return response.statusCode == 200;
  }
}
