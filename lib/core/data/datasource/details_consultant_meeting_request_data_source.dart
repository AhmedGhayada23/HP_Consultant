import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/details_consultant_meeting_request_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/helper/server_message.dart';

abstract class DetailsConsultantMeetingRequestDataSource {
  Future<DetailsConsultantMeetingRequestModel> getDetailsConsultantMeetingRequest(int id);
  Future<void> cancelMeetingRequest(BuildContext context, int id); // ✅ id مطلوب
}

class DetailsConsultantMeetingRequestDataSourceImpl
    extends DetailsConsultantMeetingRequestDataSource {
  static final DetailsConsultantMeetingRequestDataSourceImpl _instance =
      DetailsConsultantMeetingRequestDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  DetailsConsultantMeetingRequestDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory DetailsConsultantMeetingRequestDataSourceImpl() => _instance;

  @override
  Future<DetailsConsultantMeetingRequestModel> getDetailsConsultantMeetingRequest(int id) async {
    try {
      final response = await _remoteConnectionDio.dio.get(
        '${Constants.meetingRequestsUrl}/$id', // ✅ /api/v1/meeting-requests/{id}
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DetailsConsultantMeetingRequestModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load meeting request: ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      log('DioException: ${e.response?.data}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      log('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> cancelMeetingRequest(BuildContext context, int id) async {
    try {
      final response = await _remoteConnectionDio.dio.post(
        '${Constants.meetingRequestsUrl}/$id/cancel',
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          showCustomSnackBar(context, serverMessage.asBullets, SnackBarType.error);
        }
        throw Exception(serverMessage.asBullets);
      }else{
         if (context.mounted) {
          showCustomSnackBar(context, 'Cancel Request Success', SnackBarType.success);
        }
      }
    } on dio.DioException catch (e) {
      log('DioException cancel: ${e.response?.data}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      log('Unexpected error cancel: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
