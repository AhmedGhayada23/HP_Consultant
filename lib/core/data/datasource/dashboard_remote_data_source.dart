import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/dashboard_campany_model.dart';
import 'package:dio/dio.dart' as dio;

abstract class DashboardRemoteDataSource {
  Future<DashboardCampanyModel> getDashboardCampany();
}

class DashboardRemoteDataSourceImpl extends DashboardRemoteDataSource {
  static final DashboardRemoteDataSourceImpl _instance = DashboardRemoteDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  /// Private constructor for singleton pattern
  DashboardRemoteDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  /// Factory constructor to return singleton instance
  factory DashboardRemoteDataSourceImpl() {
    return _instance;
  }
  @override
  Future<DashboardCampanyModel> getDashboardCampany() async {
    try {
      final response = await _remoteConnectionDio.dio.get(Constants.dashboardCamponyUrl);

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        if (data == null || data['data'] == null) {
          throw Exception('Dashboard Campany data is null');
        }

        return DashboardCampanyModel.fromJson(Map<String, dynamic>.from(data['data']));
      } else {
        throw Exception("Failed to load Dashboard Campany: Status ${response.statusCode}");
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching Dashboard Campany: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching Dashboard Campany: $e');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    return response.statusCode == 200;
  }
}
