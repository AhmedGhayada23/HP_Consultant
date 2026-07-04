import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/storage/remote_dio.dart';
import '../models/my_application_model.dart';

const _jobApplicationsUrl =
    'https://workspace.hbconsulting-services.com/api/student/job-applications';

abstract class MyApplicationRemoteDataSource {
  Future<List<MyApplicationModel>> getMyApplications();
}

class MyApplicationRemoteDataSourceImpl extends MyApplicationRemoteDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<List<MyApplicationModel>> getMyApplications() async {
    try {
      final response = await _dio.get(_jobApplicationsUrl);
      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        final data = response.data;
        final List list = (data is Map ? data['data'] : null) ?? [];
        return list
            .map((e) => MyApplicationModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      throw Exception('Failed to load applications: Status ${response.statusCode}');
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching applications: ${e.message}');
    }
  }
}
