import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/datasource/details_hb_lab_project_data_source.dart';
import 'package:hb/core/data/models/details_hb_lab_project_model.dart';

/// مصدر بيانات تفاصيل مشروع HB Lab لقسم الاستشاري (consultant)
/// نفس البيانات والمنطق، لكن endpoint مختلف: /api/consultant/hb-lab/projects/{id}
class DetailsHbLabProjectConsultantDataSourceImpl
    extends DetailsHbLabProjectDataSource {
  static final DetailsHbLabProjectConsultantDataSourceImpl _instance =
      DetailsHbLabProjectConsultantDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  DetailsHbLabProjectConsultantDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory DetailsHbLabProjectConsultantDataSourceImpl() => _instance;

  @override
  Future<DetailsHbLabProjectModel> getDetailsHbLabProject(int id) async {
    try {
      final response = await _remoteConnectionDio.dio.get(
        '${Constants.hbLabProjectsUrl}/$id',
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
