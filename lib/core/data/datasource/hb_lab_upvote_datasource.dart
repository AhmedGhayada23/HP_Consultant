import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';

class UpvoteResult {
  final bool upvoted;
  final int votesCount;
  UpvoteResult({required this.upvoted, required this.votesCount});
}

abstract class HbLabUpvoteDataSource {
  Future<UpvoteResult> toggleUpvote(int id);
}

class HbLabUpvoteDataSourceImpl implements HbLabUpvoteDataSource {
  static final HbLabUpvoteDataSourceImpl _instance =
      HbLabUpvoteDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  HbLabUpvoteDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory HbLabUpvoteDataSourceImpl() => _instance;

  @override
  Future<UpvoteResult> toggleUpvote(int id) async {
    try {
      final response = await _remoteConnectionDio.dio.post(
        '${Constants.hbLabIdeasAccountingUrl}/$id/upvote',
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
