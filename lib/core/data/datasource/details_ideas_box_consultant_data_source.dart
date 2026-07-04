import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/datasource/details_ideas_box_data_source.dart';
import 'package:hb/core/data/models/details_ideas_box_model.dart';

/// تفاصيل فكرة HB Lab لقسم الاستشاري (consultant)
/// نفس البيانات والمنطق، لكن endpoint مختلف: /api/consultant/hb-lab/ideas/{id}
class DetailsIdeasBoxConsultantDataSourceImpl
    extends DetailsIdeasBoxDataSource {
  static final DetailsIdeasBoxConsultantDataSourceImpl _instance =
      DetailsIdeasBoxConsultantDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  DetailsIdeasBoxConsultantDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory DetailsIdeasBoxConsultantDataSourceImpl() => _instance;

  @override
  Future<DetailsIdeasBoxModel> getDetailsIdeasBox(int id) async {
    try {
      final response = await _remoteConnectionDio.dio.get(
        '${Constants.hbLabIdeasUrl}/$id',
      );

      if (_isSuccessfulResponse(response)) {
        return DetailsIdeasBoxModel.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        throw Exception(
            'Failed to load idea details: Status ${response.statusCode}');
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
