import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/helper/server_message.dart';

const _studentJobsUrl =
    'https://workspace.hbconsulting-services.com/api/student/jobs';

abstract class ApplyJobDataSource {
  Future<void> apply({
    required int jobId,
    required String applicantName,
    required String applicantEmail,
    required String availabilityStartDate,
    required bool informationAccuracyConfirmed,
    required bool adminPreviewRequested,
    String? coverLetter,
    String? cvPath,
    List<int> completedCourseIds,
  });
}

class ApplyJobDataSourceImpl implements ApplyJobDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<void> apply({
    required int jobId,
    required String applicantName,
    required String applicantEmail,
    required String availabilityStartDate,
    required bool informationAccuracyConfirmed,
    required bool adminPreviewRequested,
    String? coverLetter,
    String? cvPath,
    List<int> completedCourseIds = const [],
  }) async {
    try {
      final map = <String, dynamic>{
        'applicant_name': applicantName,
        'applicant_email': applicantEmail,
        'availability_start_date': availabilityStartDate,
        'information_accuracy_confirmed': informationAccuracyConfirmed ? 1 : 0,
        'admin_preview_requested': adminPreviewRequested ? 1 : 0,
        if (coverLetter != null && coverLetter.isNotEmpty)
          'cover_letter': coverLetter,
      };

      for (var i = 0; i < completedCourseIds.length; i++) {
        map['completed_training_course_ids[$i]'] = completedCourseIds[i];
      }

      if (cvPath != null && cvPath.isNotEmpty) {
        map['cv'] = await dio.MultipartFile.fromFile(
          cvPath,
          filename: cvPath.split('/').last,
        );
      }

      final formData = dio.FormData.fromMap(map);

      final response = await _dio.post(
        '$_studentJobsUrl/$jobId/apply',
        data: formData,
      );

      final code = response.statusCode ?? 0;
      final data = response.data;
      final ok = code >= 200 &&
          code < 300 &&
          (data is! Map || (data['status'] != false && data['success'] != false));
      if (!ok) {
        final raw = data is Map ? data['message'] : null;
        throw Exception(ServerMessage.fromResponse(raw).asBullets);
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while applying: ${e.message}');
    }
  }
}
