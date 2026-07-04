import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/hb_lab_ideas_box_model.dart';

abstract class HbLabIdeasBoxAccountingDataSource {
  Future<HbLabIdeasPageResponse> getHbLabIdeasBox({
    String? search,
    int page,
    Map<String, dynamic>? filters,
  });
}

class HbLabIdeasBoxAccountingDataSourceImpl
    extends HbLabIdeasBoxAccountingDataSource {
  final RemoteConnectionDio _remoteConnectionDio = RemoteConnectionDio();

  @override
  Future<HbLabIdeasPageResponse> getHbLabIdeasBox({
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
        Constants.hbLabIdeasAccountingUrl,
        queryParameters: queryParams,
      );

      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        final body = response.data as Map<String, dynamic>? ?? {};
        final list = (body['data'] as List? ?? [])
            .map((e) => HbLabIdeasBoxModel.fromJson(e as Map<String, dynamic>))
            .toList();
        final meta = body['meta'] as Map<String, dynamic>? ?? {};
        return HbLabIdeasPageResponse(
          ideas: list,
          currentPage: meta['current_page'] ?? 1,
          lastPage: meta['last_page'] ?? 1,
          total: meta['total'] ?? list.length,
        );
      } else {
        throw Exception(
            'Failed to load HB Lab ideas: Status ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
