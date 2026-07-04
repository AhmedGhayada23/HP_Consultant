import 'package:dio/dio.dart' as dio;
import 'package:flutter/widgets.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/helper/server_message.dart';

abstract class HbLabJoinDataSource {
  Future<bool> joinProject({
    required BuildContext context,
    required int projectId,
    required String message,
    required String expertise,
  });
}

class HbLabJoinDataSourceImpl implements HbLabJoinDataSource {
  static final HbLabJoinDataSourceImpl _instance =
      HbLabJoinDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  HbLabJoinDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory HbLabJoinDataSourceImpl() => _instance;

  @override
  Future<bool> joinProject({
    required BuildContext context,
    required int projectId,
    required String message,
    required String expertise,
  }) async {
    try {
      final response = await _remoteConnectionDio.dio.post(
        '${Constants.hbLabProjectsAccountingUrl}/$projectId/join',
        data: {'message': message, 'expertise': expertise},
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
