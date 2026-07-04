import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/helper/server_message.dart';

abstract class RejectApplicationDataSource {
  Future<void> rejectApplication(int applicationId);
}

class RejectApplicationDataSourceImpl extends RejectApplicationDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<void> rejectApplication(int applicationId) async {
    try {
      final response = await _dio.post(
        '${Constants.baseUrl}/applications/$applicationId/reject',
      );

      final code = response.statusCode ?? 0;
      final data = response.data;
      final ok = code >= 200 &&
          code < 300 &&
          (data is! Map || (data['success'] != false && data['status'] != false));
      if (!ok) {
        final raw = data is Map ? data['message'] : null;
        throw Exception(ServerMessage.fromResponse(raw).asBullets);
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
