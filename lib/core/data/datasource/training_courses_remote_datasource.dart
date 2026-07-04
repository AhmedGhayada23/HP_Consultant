// ═══════════════════════════════════════════════════════════
// 2. DATASOURCE
// lib/core/data/datasource/courses_remote_datasource.dart
// ═══════════════════════════════════════════════════════════

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/course_details_model.dart';
import 'package:hb/core/data/models/training_course_model.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/helper/server_message.dart';

abstract class TrainingCoursesRemoteDatasource {
  Future<List<TrainingCourseModel>> getCourses({
    String? category,
    String? range,
    String? duration,
    String? leve,
    String? search,
  });
  Future<CourseDetailsModel> getCourseDetails(int courseId);
  Future<void> purchaseCourse(BuildContext context,{required int courseId});
}

class TrainingCoursesRemoteDatasourceImpl extends TrainingCoursesRemoteDatasource {
  static final TrainingCoursesRemoteDatasourceImpl _instance =
      TrainingCoursesRemoteDatasourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  TrainingCoursesRemoteDatasourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory TrainingCoursesRemoteDatasourceImpl() => _instance;

  @override
  Future<List<TrainingCourseModel>> getCourses({
    String? category,
    String? range,
    String? duration,
    String? leve,
    String? search,
  }) async {
    final Map<String, dynamic> queryParams = {
      if (category != null) 'category': category,
      if (search != null) 'search': search,
      if (duration != null) 'duration': duration,
      if (range != null) 'range': range,
      if (leve != null) 'leve': leve,
    };
    try {
      final response = await _remoteConnectionDio.dio.get(
        Constants.trainingCoursesUrl, // '/api/v1/training/courses'
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        if (data == null || data['data'] == null) {
          throw Exception('Courses data is null');
        }

        final List coursesJson = data['data'];
        return coursesJson.map((c) => TrainingCourseModel.fromJson(c)).toList();
      } else {
        throw Exception('Failed to load courses: Status ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching courses: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching courses: $e');
    }
  }

  @override
  Future<CourseDetailsModel> getCourseDetails(int courseId) async {
    try {
      final response = await _remoteConnectionDio.dio.get(
        '${Constants.trainingCoursesUrl}/$courseId',
      );

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        if (data == null || data['data'] == null) {
          throw Exception('Course details data is null');
        }

        return CourseDetailsModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to load Course Details: Status ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching Course Details: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching Course Details: $e');
    }
  }

  @override
  Future<void> purchaseCourse(BuildContext context, {required int courseId}) async {
    try {
      final formData = dio.FormData.fromMap({'course_id': courseId, 'number_of_employees': 1});

      final response = await _remoteConnectionDio.dio.post(
        Constants.trainingPurchaseUrl,
        data: formData,
      );

      if (!_isSuccessfulResponse(response)) {
       final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          showCustomSnackBar(context, serverMessage.asBullets, SnackBarType.error);
        }
        throw Exception(serverMessage.asBullets);
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while purchasing course: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while purchasing course: $e');
    }
  }
}

bool _isSuccessfulResponse(dio.Response response) {
  return response.statusCode == 200 || response.statusCode == 201;
}
