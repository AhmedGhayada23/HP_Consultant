import 'package:dio/dio.dart' as dio;
import 'package:flutter/widgets.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/helper/server_message.dart';

abstract class SubmitIdeaDataSource {
  Future<bool> submitIdea({
    required BuildContext context,
    required String title,
    required String description,
    required String confidentialityLevel,
    required List<String> tags,
    String? attachmentPath,
  });
}

class SubmitIdeaDataSourceImpl implements SubmitIdeaDataSource {
  static final SubmitIdeaDataSourceImpl _instance =
      SubmitIdeaDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  SubmitIdeaDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory SubmitIdeaDataSourceImpl() => _instance;

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
        Constants.hbLabIdeasAccountingUrl,
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
