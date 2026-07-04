import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/hb_lab_ideas_box_model.dart';

abstract class HbLabIdeasBoxDataSource {
  Future<HbLabIdeasPageResponse> getHbLabIdeasBox({
    String? search,
    int page = 1,
    Map<String, dynamic>? filters,
  });
}

class HbLabIdeasBoxDataSourceImpl extends HbLabIdeasBoxDataSource {
  static final HbLabIdeasBoxDataSourceImpl _instance =
      HbLabIdeasBoxDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  HbLabIdeasBoxDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory HbLabIdeasBoxDataSourceImpl() => _instance;

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
        Constants.hbLabIdeasUrl,
        queryParameters: queryParams,
      );

      if (_isSuccessfulResponse(response)) {
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
        throw Exception('Failed to load HB Lab ideas: Status ${response.statusCode}');
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
