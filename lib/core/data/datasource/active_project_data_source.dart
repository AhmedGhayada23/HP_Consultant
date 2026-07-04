import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/active_project_model.dart';
import 'package:dio/dio.dart' as dio;

abstract class ActiveProjectDataSource {
  Future<List<ActiveProjectModel>> getActiveProject({
    String? status,
    String? deadlineFrom,
    String? deadlineTo,
    String? name,
    String? consultant,
  });
}

class ActiveProjectDataSourceImpl extends ActiveProjectDataSource {
  static final ActiveProjectDataSourceImpl _instance = ActiveProjectDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  /// Private constructor for singleton pattern
  ActiveProjectDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  /// Factory constructor to return singleton instance
  factory ActiveProjectDataSourceImpl() {
    return _instance;
  }
  @override
  Future<List<ActiveProjectModel>> getActiveProject({
    String? status,
    String? deadlineFrom,
    String? deadlineTo,
    String? name,
    String? consultant,
  }) async {
    final Map<String, dynamic> queryParams = {
      if (status != null) 'status': status,
      if (deadlineFrom != null) 'deadline_from': deadlineFrom,
      if (deadlineTo != null) 'deadline_to': deadlineTo,
      if (name != null) 'name': name,
      if (consultant != null) 'consultant': consultant,
    };

    try {
      final response = await _remoteConnectionDio.dio.get(
        Constants.projectsUrl,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        if (data == null || data['data'] == null) {
          throw Exception('Jobs data is null');
        }

        final List jobsJson = data['data'];

        return jobsJson.map((job) => ActiveProjectModel.fromJson(job)).toList();
      } else {
        throw Exception("Failed to load project: Status ${response.statusCode}");
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching project: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching project: $e');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    return response.statusCode == 200;
  }
}
