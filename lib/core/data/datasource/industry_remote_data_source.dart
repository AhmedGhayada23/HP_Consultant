import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/industry_model.dart';

abstract class IndustryRemoteDataSource {
  Future<List<IndustryModel>> getIndustries();
}

class IndustryRemoteDataSourceImpl implements IndustryRemoteDataSource {
  static final IndustryRemoteDataSourceImpl _instance =
      IndustryRemoteDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  IndustryRemoteDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory IndustryRemoteDataSourceImpl() => _instance;

  @override
  Future<List<IndustryModel>> getIndustries() async {
    try {
      final response =
          await _remoteConnectionDio.dio.get(Constants.industriesUrl);

      if (_isSuccessfulResponse(response)) {
        final List list = response.data['data'] ?? [];
        return list
            .whereType<Map>()
            .map((e) => IndustryModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        throw Exception('Failed to load industries: ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching industries: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching industries: $e');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    final code = response.statusCode ?? 0;
    return code >= 200 && code < 300;
  }
}
