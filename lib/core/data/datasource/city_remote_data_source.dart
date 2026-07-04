import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/cities_model.dart';

abstract class CityRemoteDataSource {
  Future<List<CitiesModel>> getCitiesByCountry(int countryId);
}

class CityRemoteDataSourceImpl implements CityRemoteDataSource {
  static final CityRemoteDataSourceImpl _instance = CityRemoteDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  /// Private constructor for singleton pattern
  CityRemoteDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  /// Factory constructor to return singleton instance
  factory CityRemoteDataSourceImpl() {
    return _instance;
  }

  @override
  Future<List<CitiesModel>> getCitiesByCountry(int countryId) async {
    try {
      final response = await _remoteConnectionDio.dio.get(
        '${Constants.countryCodesUrl}/$countryId/provinces',
      );

      if (_isSuccessfulResponse(response)) {
        // Replace 'data' with the actual key from your API response
        final List<dynamic> countriesData = response.data['data'];
        return countriesData.map((json) => CitiesModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load country codes: Status ${response.statusCode}");
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching country codes: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching country codes: $e');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    return response.statusCode == 200;
  }
}
