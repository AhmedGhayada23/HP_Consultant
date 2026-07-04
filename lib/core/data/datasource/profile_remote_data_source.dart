import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/config/constants.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hb/core/data/models/user_model.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/helper/server_message.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileResponseModel> fetchUserProfile();
  Future<void> updateUserProfile({
    required BuildContext context,
    required Map<String, dynamic> profileData,
  });
  Future<void> changePassword({
    required BuildContext context,
    required String previousPassword,
    required String newPassword,
  });
  Future<void> deleteAccount({required String password});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  static final ProfileRemoteDataSourceImpl _instance = ProfileRemoteDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  /// Private constructor for singleton pattern
  ProfileRemoteDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  /// Factory constructor to return singleton instance
  factory ProfileRemoteDataSourceImpl() {
    return _instance;
  }

  @override
  Future<ProfileResponseModel> fetchUserProfile() async {
    try {
      final response = await _remoteConnectionDio.dio.get(Constants.profileUrl);

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        final d = data?['data'];
        // المستخدم العادي عبر user، وعميل المحاسبة عبر contact_person
        if (d == null || (d['user'] == null && d['contact_person'] == null)) {
          throw Exception('Profile data is null');
        }
        return ProfileResponseModel.fromJson(response.data);
      } else {
        throw Exception("Failed to load profile: Status ${response.statusCode}");
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching profile: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching profile: $e');
    }
  }

  @override
  Future<void> updateUserProfile({
    required BuildContext context,
    required Map<String, dynamic> profileData,
  }) async {
    try {
      // تحويل البيانات إلى FormData لدعم رفع الصورة
      final formDataMap = <String, dynamic>{};

      for (final entry in profileData.entries) {
        if (entry.value != null) {
          formDataMap[entry.key] = entry.value;
        }
      }

      // إضافة الصورة إن وُجدت
      if (profileData['profileImage'] != null) {
        final file = profileData['profileImage'] as File;
        formDataMap['image'] = await dio.MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        );
      }

      final response = await _remoteConnectionDio.dio.post(
        Constants.profileUpdateDataUrl,
        data: dio.FormData.fromMap(formDataMap),
      );

      if (_isSuccessfulResponse(response)) {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          showCustomSnackBar(context, serverMessage.asBullets, SnackBarType.success);
        }
      } else {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          showCustomSnackBar(context, serverMessage.asBullets, SnackBarType.error);
        }
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while updating profile: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while updating profile: $e');
    }
  }

  @override
  Future<void> changePassword({
    required BuildContext context,
    required String previousPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _remoteConnectionDio.dio.post(
        Constants.updatePasswordUrl,
        data: {
          'current_password': previousPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPassword,
        },
      );

      if (_isSuccessfulResponse(response)) {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          showCustomSnackBar(context, serverMessage.asBullets, SnackBarType.success);
        }
      } else {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          showCustomSnackBar(context, serverMessage.asBullets, SnackBarType.error);
        }
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching change Password: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching change Password: $e');
    }
  }

  @override
  Future<void> deleteAccount({required String password}) async {
    try {
      final response = await _remoteConnectionDio.dio.post(
        Constants.deleteAccountUrl,
        data: {'password': password},
      );
      final ok = _isSuccessfulResponse(response) &&
          (response.data is Map ? response.data['status'] != false : true);
      if (!ok) {
        final rawMessage =
            response.data is Map ? response.data['message'] : null;
        throw Exception(ServerMessage.fromResponse(rawMessage).asBullets);
      }
    } on dio.DioException catch (e) {
      final data = e.response?.data;
      final rawMessage = data is Map ? data['message'] : null;
      if (rawMessage != null) {
        throw Exception(ServerMessage.fromResponse(rawMessage).asBullets);
      }
      throw Exception('Network error while deleting account: ${e.message}');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    return response.statusCode == 200;
  }
}
