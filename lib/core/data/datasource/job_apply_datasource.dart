import 'package:dio/dio.dart' as dio;
import 'package:flutter/widgets.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/helper/server_message.dart';

abstract class JobApplyDataSource {
  Future<bool> applyJob({
    required BuildContext context,
    required int jobId,
    required String proposedRate,
    required String durationWeeks,
    required String availabilityStartDate,
    required String coverLetter,
    required bool adminPreviewRequested,
    required bool informationAccuracyConfirmed,
    String? supportingDocPath,
  });
}

class JobApplyDataSourceImpl implements JobApplyDataSource {
  static final JobApplyDataSourceImpl _instance =
      JobApplyDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  JobApplyDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory JobApplyDataSourceImpl() => _instance;

  @override
  Future<bool> applyJob({
    required BuildContext context,
    required int jobId,
    required String proposedRate,
    required String durationWeeks,
    required String availabilityStartDate,
    required String coverLetter,
    required bool adminPreviewRequested,
    required bool informationAccuracyConfirmed,
    String? supportingDocPath,
  }) async {
    final formMap = <String, dynamic>{
      'proposed_rate': proposedRate,
      'duration_weeks': durationWeeks,
      'availability_start_date': availabilityStartDate,
      'cover_letter': coverLetter,
      'admin_preview_requested': adminPreviewRequested ? '1' : '0',
      'information_accuracy_confirmed': informationAccuracyConfirmed ? '1' : '0',
    };

    if (supportingDocPath != null && supportingDocPath.isNotEmpty) {
      formMap['supporting_documents[0]'] = await dio.MultipartFile.fromFile(
        supportingDocPath,
        filename: supportingDocPath.split('/').last,
      );
    }

    try {
      final url = '${Constants.consultantJobsUrl}/$jobId/apply';
      final response = await _remoteConnectionDio.dio.post(
        url,
        data: dio.FormData.fromMap(formMap),
      );

      final rawMessage = response.data?['message'];
      final serverMessage = ServerMessage.fromResponse(rawMessage);

      if (_isSuccessfulResponse(response)) {
        if (context.mounted) {
          showCustomSnackBar(
              context, serverMessage.asBullets, SnackBarType.success);
        }
        return true;
      } else {
        if (context.mounted) {
          showCustomSnackBar(
              context, serverMessage.asBullets, SnackBarType.error);
        }
        return false;
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while applying for job: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while applying for job: $e');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    final code = response.statusCode ?? 0;
    return code >= 200 && code < 300;
  }
}
