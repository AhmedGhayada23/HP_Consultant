import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/details_jobs_marketplace_model.dart';

abstract class DetailsJobsMarketplaceDataSource {
  Future<DetailsJobsMarketplaceModel> getDetailsJobsMarketplace(int id);
}

class DetailsJobsMarketplaceDataSourceImpl
    implements DetailsJobsMarketplaceDataSource {
  static final DetailsJobsMarketplaceDataSourceImpl _instance =
      DetailsJobsMarketplaceDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  DetailsJobsMarketplaceDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory DetailsJobsMarketplaceDataSourceImpl() => _instance;

  @override
  Future<DetailsJobsMarketplaceModel> getDetailsJobsMarketplace(int id) async {
    try {
      final response = await _remoteConnectionDio.dio.get(
        '${Constants.consultantJobsUrl}/$id',
      );

      if (_isSuccessfulResponse(response)) {
        final body = response.data;
        if (body == null) throw Exception('Job details data is null');
        return DetailsJobsMarketplaceModel.fromJson(
          Map<String, dynamic>.from(body),
        );
      } else {
        throw Exception(
            'Failed to load job details: Status ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching job details: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching job details: $e');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    final code = response.statusCode ?? 0;
    return code >= 200 && code < 300;
  }
}
