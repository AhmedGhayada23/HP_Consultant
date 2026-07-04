import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/milestone_model.dart';
import 'package:dio/dio.dart' as dio;

abstract class MilestoneRemoteDataSource {
  Future<List<MilestoneModel>> milestone(int projectId);
}

class MilestoneRemoteDataSourceImpl extends MilestoneRemoteDataSource {
  static final MilestoneRemoteDataSourceImpl _instance = MilestoneRemoteDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  /// Private constructor for singleton pattern
  MilestoneRemoteDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  /// Factory constructor to return singleton instance
  factory MilestoneRemoteDataSourceImpl() {
    return _instance;
  }

  @override
  Future<List<MilestoneModel>> milestone(int projectId) async {
    try {
      final response = await _remoteConnectionDio.dio.get(
        '${Constants.projectsUrl}/$projectId/milestones',
      );

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        final List milestonesJson = (data?['data']?['milestones'] as List?) ?? [];

        return milestonesJson.map((e) => MilestoneModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load milestones: Status ${response.statusCode}");
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching milestones: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching milestones: $e');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    return response.statusCode == 200;
  }
}
