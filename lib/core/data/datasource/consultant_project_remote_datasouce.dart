import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/consultant_project_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hb/core/helper/server_message.dart';
import 'package:hb/core/message/message_snack_bar.dart';

abstract class ConsultantProjectRemoteDatasouce {
  Future<List<ConsultantProjectModel>> getConsultantProject({String? search, String? status, String? project, String? role});
  Future<void> addProject({BuildContext? context, required Map<String, dynamic> projectData});
  Future<void> addMeetingRequests({
    BuildContext? context,
    required Map<String, dynamic> meetingData,
  });
  Future<void> updateProject({
    BuildContext? context,
    required int projectId,
    required Map<String, dynamic> projectData,
  });
}

class ConsultantProjectRemoteDatasouceImpl extends ConsultantProjectRemoteDatasouce {
  static final ConsultantProjectRemoteDatasouceImpl _instance =
      ConsultantProjectRemoteDatasouceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  /// Private constructor for singleton pattern
  ConsultantProjectRemoteDatasouceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  /// Factory constructor to return singleton instance
  factory ConsultantProjectRemoteDatasouceImpl() {
    return _instance;
  }

  @override
  Future<List<ConsultantProjectModel>> getConsultantProject({
    String? search,
    String? status,
    String? project,
    String? role,
  }) async {
    final Map<String, dynamic> queryParams = {
      if (search != null) 'search': search,
      if (status != null) 'status': status,
      if (project != null) 'project': project,
      if (role != null) 'role': role,
    };
    try {
      final response = await _remoteConnectionDio.dio.get(
        Constants.consultantsUrl,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        if (data == null || data['data'] == null) {
          throw Exception('Jobs data is null');
        }

        final List jobsJson = data['data'];

        return jobsJson.map((job) => ConsultantProjectModel.fromJson(job)).toList();
      } else {
        throw Exception("Failed to load Consultant: Status ${response.statusCode}");
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching Consultant: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching Consultant: $e');
    }
  }

  @override
  Future<void> addProject({
    BuildContext? context,
    required Map<String, dynamic> projectData,
  }) async {
    try {
      log('Sending project data: $projectData');

      final response = await _remoteConnectionDio.dio.post(
        Constants.projectsUrl,
        data: projectData, // ✅ JSON مباشرة بدل FormData
        options: dio.Options(
          contentType: 'application/json', // ✅ application/json مش multipart
        ),
      );

      if (!_isSuccessfulResponse(response)) {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context != null && context.mounted) {
          showCustomSnackBar(context, serverMessage.asBullets, SnackBarType.error);
        }
        throw Exception(serverMessage.asBullets);
      }
    } on dio.DioException catch (e) {
      log('DioException status: ${e.response?.statusCode}');
      log('DioException data: ${e.response?.data}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      log('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> addMeetingRequests({
    BuildContext? context,
    required Map<String, dynamic> meetingData,
  }) async {
    try {
      log('Sending meeting data: $meetingData');

      // ✅ FormData لأن فيه file
      final formData = dio.FormData.fromMap({
        'title': meetingData['title'],
        'category': meetingData['category'],
        'consultant_type': meetingData['consultant_type'],
        'preferred_start_date': meetingData['preferred_start_date'],
        'urgency': meetingData['urgency'],
        'estimated_duration': meetingData['estimated_duration'],
        'budget_min': meetingData['budget_min'],
        'budget_max': meetingData['budget_max'],
        'description': meetingData['description'],

        // ✅ الـ file يتم إضافته بشكل منفصل
        if (meetingData['supporting_document'] != null)
          'supporting_document': await dio.MultipartFile.fromFile(
            meetingData['supporting_document'], // المسار الكامل للملف
            filename: meetingData['supporting_document'].toString().split('/').last,
          ),
      });

      final response = await _remoteConnectionDio.dio.post(
        Constants.meetingRequestsUrl, // أضف هذا في Constants
        data: formData,
      );

      if (!_isSuccessfulResponse(response)) {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context != null && context.mounted) {
          showCustomSnackBar(context, serverMessage.asBullets, SnackBarType.error);
        }
        throw Exception(serverMessage.asBullets);
      } else {
        log('Meeting request added successfully: ${response.data}');
        if (context != null && context.mounted) {
          showCustomSnackBar(context, 'Meeting request sent successfully!', SnackBarType.success);
        }
      }
    } on dio.DioException catch (e) {
      log('DioException status: ${e.response?.statusCode}');
      log('DioException data: ${e.response?.data}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      log('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    return response.statusCode == 200 || response.statusCode == 201;
  }

  @override
  Future<void> updateProject({
    BuildContext? context,
    required int projectId,
    required Map<String, dynamic> projectData,
  }) async {
    try {
      log('Updating project id: $projectId');
      log('Sending project data: $projectData');

      final response = await _remoteConnectionDio.dio.post(
        "${Constants.projectsUrl}/$projectId",
        data: projectData,
        options: dio.Options(contentType: 'application/json'),
      );

      if (!_isSuccessfulResponse(response)) {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);

        if (context != null && context.mounted) {
          showCustomSnackBar(context, serverMessage.asBullets, SnackBarType.error);
        }

        throw Exception(serverMessage.asBullets);
      } else {
        log('Project updated successfully: ${response.data}');

        if (context != null && context.mounted) {
          showCustomSnackBar(context, 'Project updated successfully!', SnackBarType.success);
        }
      }
    } on dio.DioException catch (e) {
      log('DioException status: ${e.response?.statusCode}');
      log('DioException data: ${e.response?.data}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      log('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
