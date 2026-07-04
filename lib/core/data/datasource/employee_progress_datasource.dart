import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/employee_progress_model.dart';
import 'package:dio/dio.dart' as dio;

abstract class EmployeeProgressDatasource {
  Future<List<EmployeeProgressModel>> getEmployeesProgress();
}

class EmployeeProgressDatasourceImpl extends EmployeeProgressDatasource {
  static final EmployeeProgressDatasourceImpl _instance =
      EmployeeProgressDatasourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  EmployeeProgressDatasourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory EmployeeProgressDatasourceImpl() => _instance;

  bool _isSuccessfulResponse(dio.Response response) {
    return response.statusCode == 200 || response.statusCode == 201;
  }

  @override
  Future<List<EmployeeProgressModel>> getEmployeesProgress() async {
    try {
      final response = await _remoteConnectionDio.dio.get(
        Constants.employeesProgressUrl, // '/api/v1/training/employees-progress'
      );

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        if (data == null || data['data'] == null) {
          throw Exception('Employees progress data is null');
        }

        final List progressJson = data['data'];
        return progressJson
            .map((item) => EmployeeProgressModel.fromJson(item))
            .toList();
      } else {
        throw Exception(
          'Failed to load employees progress: Status ${response.statusCode}',
        );
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching employees progress: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching employees progress: $e');
    }
  }
}
