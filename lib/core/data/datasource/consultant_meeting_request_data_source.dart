import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/consultant_meeting_request_modle.dart';
import 'package:hb/core/helper/server_message.dart';

abstract class ConsultantMeetingRequestDataSource {
  Future<List<ConsultantMeetingRequestModel>> getConsultantMeetingRequest({
    String? category,
    String? status,
    String? name,
  });
  Future<void> addMeetingRequests({
    BuildContext? context,
    required Map<String, dynamic> meetingData,
  });
}

class ConsultantMeetingRequestDataSourceImpl extends ConsultantMeetingRequestDataSource {
  static final ConsultantMeetingRequestDataSourceImpl _instance =
      ConsultantMeetingRequestDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  /// Private constructor for singleton pattern
  ConsultantMeetingRequestDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  /// Factory constructor to return singleton instance
  factory ConsultantMeetingRequestDataSourceImpl() {
    return _instance;
  }

  @override
  Future<List<ConsultantMeetingRequestModel>> getConsultantMeetingRequest({
    String? category,
    String? status,
    String? name,
  }) async {
    final Map<String, dynamic> queryParams = {
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (status != null) 'status': status,
    };

    try {
      final response = await _remoteConnectionDio.dio.get(
        Constants.meetingRequestsUrl,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        if (data == null || data['data'] == null) {
          throw Exception('Jobs data is null');
        }

        final List jobsJson = data['data'];

        return jobsJson.map((job) => ConsultantMeetingRequestModel.fromJson(job)).toList();
      } else {
        throw Exception("Failed to load Consultant MeetingRequest: Status ${response.statusCode}");
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching Consultant MeetingRequest: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching Consultant MeetingRequest: $e');
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
        // رمي رسالة السيرفر فقط — العرض يتم في الواجهة عبر showCustomSnackBar
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        throw serverMessage.asBullets;
      }
    } on dio.DioException catch (e) {
      log('DioException status: ${e.response?.statusCode}');
      log('DioException data: ${e.response?.data}');
      // محاولة قراءة رسالة السيرفر من جسم الخطأ إن وُجدت
      final rawMessage = e.response?.data is Map ? e.response?.data['message'] : null;
      if (rawMessage != null) {
        throw ServerMessage.fromResponse(rawMessage).asBullets;
      }
      rethrow;
    } catch (e) {
      log('Unexpected error: $e');
      rethrow;
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
