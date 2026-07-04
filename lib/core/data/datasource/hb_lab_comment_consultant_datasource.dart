import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/datasource/hb_lab_comment_datasource.dart';

/// إضافة تعليق على فكرة HB Lab لقسم الاستشاري (consultant)
/// نفس المنطق، لكن endpoint مختلف: POST /api/consultant/hb-lab/ideas/{id}/comments
class HbLabCommentConsultantDataSourceImpl implements HbLabCommentDataSource {
  static final HbLabCommentConsultantDataSourceImpl _instance =
      HbLabCommentConsultantDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  HbLabCommentConsultantDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory HbLabCommentConsultantDataSourceImpl() => _instance;

  @override
  Future<bool> addComment({required int ideaId, required String body}) async {
    try {
      final formData = dio.FormData.fromMap({'body': body});

      final response = await _remoteConnectionDio.dio.post(
        '${Constants.hbLabIdeasUrl}/$ideaId/comments',
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
