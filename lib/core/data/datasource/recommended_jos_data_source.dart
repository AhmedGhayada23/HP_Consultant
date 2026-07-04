import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/recommended_jos_model.dart';

abstract class RecommendedJosDataSource {
  Future<JobsPageResponse> getRecommendedJob({
    String? search,
    int page = 1,
    Map<String, dynamic>? filters,
  });
}

class RecommendedJosDataSourceImpl extends RecommendedJosDataSource {
  static final RecommendedJosDataSourceImpl _instance =
      RecommendedJosDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  RecommendedJosDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory RecommendedJosDataSourceImpl() => _instance;

  @override
  Future<JobsPageResponse> getRecommendedJob({
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
        Constants.consultantJobsUrl,
        queryParameters: queryParams,
      );

      if (_isSuccessfulResponse(response)) {
        final body = response.data as Map<String, dynamic>? ?? {};
        final list = (body['data'] as List? ?? [])
            .map((e) => RecommendedJobModel.fromJson(e as Map<String, dynamic>))
            .toList();
        final meta = body['meta'] as Map<String, dynamic>? ?? {};
        return JobsPageResponse(
          jobs: list,
          currentPage: meta['current_page'] ?? 1,
          lastPage: meta['last_page'] ?? 1,
          total: meta['total'] ?? list.length,
        );
      } else {
        throw Exception(
            'Failed to load jobs: Status ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching jobs: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching jobs: $e');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    final code = response.statusCode ?? 0;
    return code >= 200 && code < 300;
  }
}
