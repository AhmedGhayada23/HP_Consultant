import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/consultant_dashboard_model.dart';

abstract class ConsultantDashboardDataSource {
  Future<ConsultantDashboardModel> getConsultantDashboard();
}

class ConsultantDashboardDataSourceImpl
    implements ConsultantDashboardDataSource {
  static final ConsultantDashboardDataSourceImpl _instance =
      ConsultantDashboardDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  ConsultantDashboardDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory ConsultantDashboardDataSourceImpl() => _instance;

  @override
  Future<ConsultantDashboardModel> getConsultantDashboard() async {
    try {
      const url = Constants.consultantDashboardUrl;
      final response = await _remoteConnectionDio.dio.get(url);

      if (_isSuccessfulResponse(response)) {
        final data = response.data;
        if (data == null) throw Exception('Consultant dashboard data is null');
        return ConsultantDashboardModel.fromJson(
          Map<String, dynamic>.from(data),
        );
      } else {
        throw Exception(
          'Failed to load consultant dashboard: Status ${response.statusCode}',
        );
      }
    } on dio.DioException catch (e) {
      throw Exception(
        'Network error while fetching consultant dashboard: ${e.message}',
      );
    } catch (e) {
      throw Exception(
        'Unexpected error while fetching consultant dashboard: $e',
      );
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    final code = response.statusCode ?? 0;
    return code >= 200 && code < 300;
  }
}
