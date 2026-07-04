import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/hb_lab_project_model.dart';

abstract class HbLabProjectAccountingDataSource {
  Future<HbLabProjectPageResponse> getHbLabProject({
    String? search,
    int page,
    Map<String, dynamic>? filters,
  });
}

class HbLabProjectAccountingDataSourceImpl
    extends HbLabProjectAccountingDataSource {
  final RemoteConnectionDio _remoteConnectionDio = RemoteConnectionDio();

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
        Constants.hbLabProjectsAccountingUrl,
        queryParameters: queryParams,
      );

      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
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
        throw Exception(
            'Failed to load HB Lab projects: Status ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
