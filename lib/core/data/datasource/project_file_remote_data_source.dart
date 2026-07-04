import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/helper/server_message.dart';

abstract class ProjectFileRemoteDataSource {
  Future<void> uploadFile({
    required BuildContext context,
    required int projectId,
    required File file,
    required String fileType,
  });

  Future<void> uploadDeliverables({
    required int projectId,
    required int milestoneId,
    required bool markCompleted,
    required File file,
  });
}

class ProjectFileRemoteDataSourceImpl extends ProjectFileRemoteDataSource {
  static final ProjectFileRemoteDataSourceImpl _instance =
      ProjectFileRemoteDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  /// Private constructor for singleton pattern
  ProjectFileRemoteDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  /// Factory constructor to return singleton instance
  factory ProjectFileRemoteDataSourceImpl() {
    return _instance;
  }

  @override
  Future<void> uploadFile({
    required BuildContext context,
    required int projectId,
    required File file,
    required String fileType,
  }) async {
    try {
      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
        'file_type': fileType,
      });

      final response = await _remoteConnectionDio.dio.post(
        '${Constants.projectsUrl}/$projectId/upload-file',
        data: formData,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        if (context.mounted) {
          Navigator.pop(context);
        }
      } else {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          showCustomSnackBar(context, serverMessage.asBullets, SnackBarType.error);
        }
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> uploadDeliverables({
    required int projectId,
    required int milestoneId,
    required bool markCompleted,
    required File file,
  }) async {
    try {
      final formData = dio.FormData.fromMap({
        'milestone_id': milestoneId,
        'mark_milestone_completed': markCompleted ? 1 : 0,
        'files[0]': await dio.MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await _remoteConnectionDio.dio.post(
        '${Constants.consultantProjectsUrl}/$projectId/deliverables',
        data: formData,
      );

      final code = response.statusCode ?? 0;
      final ok = code >= 200 &&
          code < 300 &&
          (response.data is! Map || response.data['status'] != false);
      if (!ok) {
        final rawMessage =
            response.data is Map ? response.data['message'] : null;
        throw Exception(
          ServerMessage.fromResponse(rawMessage).asBullets,
        );
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
