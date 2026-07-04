import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/details_hb_lab_project_model.dart';

abstract class DetailsHbLabProjectDataSource {
  Future<DetailsHbLabProjectModel> getDetailsHbLabProject(int id);
}

class DetailsHbLabProjectDataSourceImpl extends DetailsHbLabProjectDataSource {
  static final DetailsHbLabProjectDataSourceImpl _instance =
      DetailsHbLabProjectDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  DetailsHbLabProjectDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory DetailsHbLabProjectDataSourceImpl() => _instance;

  @override
  Future<DetailsHbLabProjectModel> getDetailsHbLabProject(int id) async {
    try {
      final response = await _remoteConnectionDio.dio.get(
        '${Constants.hbLabProjectsAccountingUrl}/$id',
      );

      if (_isSuccessfulResponse(response)) {
        return DetailsHbLabProjectModel.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        throw Exception(
            'Failed to load project details: Status ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    final code = response.statusCode ?? 0;
    return code >= 200 && code < 300;
  }
}
