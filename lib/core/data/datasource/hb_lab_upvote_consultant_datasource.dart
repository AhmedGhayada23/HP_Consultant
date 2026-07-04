import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/datasource/hb_lab_upvote_datasource.dart';

/// تصويت (upvote) لفكرة HB Lab لقسم الاستشاري (consultant)
/// نفس المنطق، لكن endpoint مختلف: /api/consultant/hb-lab/ideas/{id}/upvote
class HbLabUpvoteConsultantDataSourceImpl implements HbLabUpvoteDataSource {
  static final HbLabUpvoteConsultantDataSourceImpl _instance =
      HbLabUpvoteConsultantDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  HbLabUpvoteConsultantDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory HbLabUpvoteConsultantDataSourceImpl() => _instance;

  @override
  Future<UpvoteResult> toggleUpvote(int id) async {
    try {
      final response = await _remoteConnectionDio.dio.post(
        '${Constants.hbLabIdeasUrl}/$id/upvote',
      );

      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        final data = response.data['data'] as Map<String, dynamic>;
        return UpvoteResult(
          upvoted: data['upvoted'] as bool? ?? false,
          votesCount: data['votes_count'] as int? ?? 0,
        );
      } else {
        throw Exception('Upvote failed: Status $code');
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
