import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/details_project_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/helper/server_message.dart';

abstract class DetailsProjectDataSource {
  Future<DetailsProjectModel> getDetailsProject(int id);
  Future<void> closeProject(BuildContext context, int id);
}

class DetailsProjectDataSourceImpl extends DetailsProjectDataSource {
  static final DetailsProjectDataSourceImpl _instance = DetailsProjectDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  /// Private constructor for singleton pattern
  DetailsProjectDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  /// Factory constructor to return singleton instance
  factory DetailsProjectDataSourceImpl() {
    return _instance;
  }

  @override
  Future<DetailsProjectModel> getDetailsProject(int id) async {
    try {
      final response = await _remoteConnectionDio.dio.get('${Constants.projectsUrl}/$id');

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        if (data == null || data['data'] == null) {
          throw Exception('Jobs Details data is null');
        }

        final Map<String, dynamic> jobsJson = data['data'];

        return DetailsProjectModel.fromJson(jobsJson);
      } else {
        throw Exception("Failed to load Project Details: Status ${response.statusCode}");
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching Project Details: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching Project Details: $e');
    }
  }

  @override
  Future<void> closeProject(BuildContext context, int id) async {
    try {
      final response = await _remoteConnectionDio.dio.post('${Constants.projectsUrl}/$id/close');

      if (!_isSuccessfulResponse(response)) {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          showCustomSnackBar(context, serverMessage.asBullets, SnackBarType.error);
        }
        throw Exception(serverMessage.asBullets);
      } else {
        if (context.mounted) {
          showCustomSnackBar(context, 'Close Project Success', SnackBarType.success);
        }
      }
    } on dio.DioException catch (e) {
      log('DioException closeProject: ${e.response?.data}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      log('Unexpected error closeProject: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    return response.statusCode == 200;
  }
}
