import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/hb_lab_project_model.dart';

abstract class HbLabProjectDataSource {
  Future<HbLabProjectPageResponse> getHbLabProject({
    String? search,
    int page = 1,
    Map<String, dynamic>? filters,
  });
}

class HbLabProjectDataSourceImpl extends HbLabProjectDataSource {
  static final HbLabProjectDataSourceImpl _instance =
      HbLabProjectDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  HbLabProjectDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory HbLabProjectDataSourceImpl() => _instance;

  @override
  Future<HbLabProjectPageResponse> getHbLabProject({
    String? search,
    int page = 1,
    Map<String, dynamic>? filters,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      if (search != null && search.isNotEmpty) 'search': search,
      ...?filters,
    };

    try {
      final response = await _remoteConnectionDio.dio.get(
        Constants.hbLabProjectsUrl,
        queryParameters: queryParams,
      );

      if (_isSuccessfulResponse(response)) {
        final body = response.data as Map<String, dynamic>? ?? {};
        final list = (body['data'] as List? ?? [])
            .map((e) => HbLabProjectModel.fromJson(e as Map<String, dynamic>))
            .toList();
        final meta = body['meta'] as Map<String, dynamic>? ?? {};
        return HbLabProjectPageResponse(
          projects: list,
          currentPage: meta['current_page'] ?? 1,
          lastPage: meta['last_page'] ?? 1,
          total: meta['total'] ?? list.length,
        );
      } else {
        throw Exception('Failed to load HB Lab projects: Status ${response.statusCode}');
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
