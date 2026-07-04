import 'package:dio/dio.dart' as dio;
import 'package:flutter/widgets.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/helper/server_message.dart';

abstract class BoostProjectDataSource {
  Future<bool> boostProject({
    required BuildContext context,
    required String title,
    required List<String> categoryTags,
    required String budget,
    required String deadline,
    required String description,
    required String goalsDeliverables,
    String? attachmentPath,
  });
}

class BoostProjectDataSourceImpl implements BoostProjectDataSource {
  static final BoostProjectDataSourceImpl _instance =
      BoostProjectDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  BoostProjectDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory BoostProjectDataSourceImpl() => _instance;

  @override
  Future<bool> boostProject({
    required BuildContext context,
    required String title,
    required List<String> categoryTags,
    required String budget,
    required String deadline,
    required String description,
    required String goalsDeliverables,
    String? attachmentPath,
  }) async {
    final formData = dio.FormData.fromMap({
      'title': title,
      'budget': budget,
      'deadline': deadline,
      'description': description,
      'goals_deliverables': goalsDeliverables,
    });

    for (final tag in categoryTags) {
      formData.fields.add(MapEntry('category_tags[]', tag));
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
        '${Constants.hbLabProjectsUrl}/boost',
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
