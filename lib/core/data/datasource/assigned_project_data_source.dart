import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/assigned_project_model.dart';
import 'package:dio/dio.dart' as dio;

abstract class AssignedProjectModelDataSource {
  Future<List<AssignedProjectModel>> getAssignedProject(int consultantId);
}

class AssignedProjectModelDataSourceImpl extends AssignedProjectModelDataSource {
  static final AssignedProjectModelDataSourceImpl _instance =
      AssignedProjectModelDataSourceImpl._internal();

  late final RemoteConnectionDio _remoteConnectionDio;

  AssignedProjectModelDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory AssignedProjectModelDataSourceImpl() {
    return _instance;
  }

  @override
  Future<List<AssignedProjectModel>> getAssignedProject(int consultantId) async {
    try {
      final response = await _remoteConnectionDio.dio.get(
        '${Constants.consultantsUrl}/$consultantId/projects',
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final List projectsJson = (data?['data'] as List?) ?? [];

        return projectsJson.map((e) => AssignedProjectModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load consultant projects");
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
