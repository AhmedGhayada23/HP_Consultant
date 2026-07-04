import 'package:flutter/material.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/assign_consultant_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hb/core/helper/server_message.dart';
import 'package:hb/core/message/message_snack_bar.dart';

abstract class AssignConsultantRemoteDataSource {
  Future<void> assignConsultant(BuildContext context, int projectId, AssignConsultantModel model);
}

class AssignConsultantRemoteDataSourceImpl extends AssignConsultantRemoteDataSource {
  static final AssignConsultantRemoteDataSourceImpl _instance =
      AssignConsultantRemoteDataSourceImpl._internal();

  late final RemoteConnectionDio _remoteConnectionDio;

  AssignConsultantRemoteDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory AssignConsultantRemoteDataSourceImpl() {
    return _instance;
  }

  @override
  Future<void> assignConsultant(
    BuildContext context,
    int projectId,
    AssignConsultantModel model,
  ) async {
    try {
      final response = await _remoteConnectionDio.dio.post(
        '${Constants.projectsUrl}/$projectId/assign-consultant',
        data: model.toJson(),
      );

      final rawMessage = response.data?['message'];
      final serverMessage = ServerMessage.fromResponse(rawMessage);
      final bool success =
          response.statusCode == 200 && (response.data?['success'] == true);

      if (success) {
        if (context.mounted) {
          showCustomSnackBar(context, serverMessage.asBullets, SnackBarType.success);
        }
      } else {
        if (context.mounted) {
          showCustomSnackBar(context, serverMessage.asBullets, SnackBarType.error);
        }
        throw Exception(serverMessage.asBullets);
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      // أعد رمي رسالة السيرفر كما هي (تم عرضها بالفعل) لمنع متابعة النجاح
      rethrow;
    }
  }
}
