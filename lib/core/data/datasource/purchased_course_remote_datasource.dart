import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/purchased_course_model.dart';
import 'package:dio/dio.dart' as dio;

abstract class PurchasedCourseDatasource {
  Future<List<PurchasedCourseModle>> getPurchasedCourse({
    String? status,
    String? search,
    String? timeline,
  });
}

class PurchasedCourseDatasourceImpl extends PurchasedCourseDatasource {
  static final PurchasedCourseDatasourceImpl _instance = PurchasedCourseDatasourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  /// Private constructor for singleton pattern
  PurchasedCourseDatasourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  /// Factory constructor to return singleton instance
  factory PurchasedCourseDatasourceImpl() {
    return _instance;
  }

  @override
  Future<List<PurchasedCourseModle>> getPurchasedCourse({
    String? status,
    String? search,
    String? timeline,
  }) async {
    final Map<String, dynamic> queryParams = {
      if (status != null) 'status': status,
      if (search != null) 'search': search,
      if (timeline != null) 'timeline': timeline,
    };
    try {
      final response = await _remoteConnectionDio.dio.get(
        Constants.trainingPurchasedUrl,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        if (data == null || data['data'] == null) {
          throw Exception('Jobs data is null');
        }

        final List jobsJson = data['data'];

        return jobsJson.map((purchased) => PurchasedCourseModle.fromJson(purchased)).toList();
      } else {
        throw Exception("Failed to load purchased course: Status ${response.statusCode}");
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching purchased course: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching purchased course: $e');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
