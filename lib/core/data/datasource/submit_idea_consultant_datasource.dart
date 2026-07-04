import 'package:dio/dio.dart' as dio;
import 'package:flutter/widgets.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/datasource/submit_idea_datasource.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/helper/server_message.dart';

/// إرسال فكرة HB Lab لقسم الاستشاري (consultant)
/// نفس البيانات والمنطق، لكن endpoint مختلف: POST /api/consultant/hb-lab/ideas
class SubmitIdeaConsultantDataSourceImpl implements SubmitIdeaDataSource {
  static final SubmitIdeaConsultantDataSourceImpl _instance =
      SubmitIdeaConsultantDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  SubmitIdeaConsultantDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory SubmitIdeaConsultantDataSourceImpl() => _instance;

  @override
  Future<bool> submitIdea({
    required BuildContext context,
    required String title,
    required String description,
    required String confidentialityLevel,
    required List<String> tags,
    String? attachmentPath,
  }) async {
    final formData = dio.FormData.fromMap({
      'title': title,
      'description': description,
      'confidentiality_level': confidentialityLevel,
    });

    for (final tag in tags) {
      formData.fields.add(MapEntry('tags[]', tag));
    }

    if (attachmentPath != null && attachmentPath.isNotEmpty) {
      formData.files.add(MapEntry(
        'attachments[0]',
        await dio.MultipartFile.fromFile(
          attachmentPath,
          filename: attachmentPath.split('/').last,
        ),
      ));
    }

    try {
      final response = await _remoteConnectionDio.dio.post(
        Constants.hbLabIdeasUrl,
        data: formData,
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
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    final code = response.statusCode ?? 0;
    return code >= 200 && code < 300;
  }
}
