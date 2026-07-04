import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';

abstract class HbLabCommentDataSource {
  Future<bool> addComment({required int ideaId, required String body});
}

class HbLabCommentDataSourceImpl implements HbLabCommentDataSource {
  static final HbLabCommentDataSourceImpl _instance =
      HbLabCommentDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  HbLabCommentDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory HbLabCommentDataSourceImpl() => _instance;

  @override
  Future<bool> addComment({required int ideaId, required String body}) async {
    try {
      final formData = dio.FormData.fromMap({'body': body});

      final response = await _remoteConnectionDio.dio.post(
        '${Constants.hbLabIdeasAccountingUrl}/$ideaId/comments',
        data: formData,
      );

      final code = response.statusCode ?? 0;
      return code >= 200 && code < 300;
    } on dio.DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
