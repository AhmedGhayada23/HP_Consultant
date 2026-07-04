import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/local_storage.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hb/core/cubit/user_cubit/user_cubit.dart';
import 'package:hb/core/data/models/consultant_register_model.dart';
import 'package:hb/core/data/models/register_model.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/helper/server_message.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/widgets/dialogs.dart';

abstract class AuthRemoteDataSource {
  Future<String> login({
    required BuildContext context,
    required String email,
    required String password,
  });
  Future<void> register({
    required BuildContext context,
    required RegisterModel registerModel,
  });
  Future<void> registerConsultant({
    required BuildContext context,
    required ConsultantRegisterModel model,
  });

  Future<void> sendActivationCode({
    required BuildContext context,
    required String email,
    required String type,
  });
  Future<void> chackActivationCode({
    required BuildContext context,
    required String email,
    required String code,
    required String type,
  });

  Future<void> forgetPasswordSendCode({
    required BuildContext context,
    required String email,
  });
  Future<void> forgetPasswordChackCode({
    required BuildContext context,
    required String email,
    required String code,
  });
  Future<void> forgetResetPassword({
    required BuildContext context,
    required String email,
    required String newPassword,
    required String confirmPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static final AuthRemoteDataSourceImpl _instance =
      AuthRemoteDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  /// Private constructor for singleton pattern
  AuthRemoteDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  /// Factory constructor to return singleton instance
  factory AuthRemoteDataSourceImpl() {
    return _instance;
  }

  @override
  Future<String> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteConnectionDio.dio.post(
        Constants.loginUrl,
        data: {'email': email, 'password': password},
      );

      if (_isSuccessfulResponse(response)) {
        final token = response.data['data']['access_token'] as String;
        final userType = response.data['data']['type'];
        LocalStorage().writeValue(Constants.token, token);
        if (userType == 'company') {
          BlocProvider.of<UserCubit>(
            context,
          ).getUserState(UserType.CompanyUser);
        } else if (userType == 'consultant') {
          BlocProvider.of<UserCubit>(
            context,
          ).getUserState(UserType.ConsultantUser);
        } else if (userType == 'student') {
          BlocProvider.of<UserCubit>(
            context,
          ).getUserState(UserType.StudentUser);
        } else if (userType == 'accounting' || userType == 'accounting_client') {
          BlocProvider.of<UserCubit>(
            context,
          ).getUserState(UserType.AccountingClintUser);
        } else {
          BlocProvider.of<UserCubit>(
            context,
          ).getUserState(UserType.ConsultantUser);
        }
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            MyRoutes().userView,
            (route) => false,
          );
        }

        return token;
      } else {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (serverMessage.contains("عذرا حسابك غير مفعل")) {
          log(' Showing activation dialog');
          if (context.mounted) {
            await showActivationDialog(
              context: context,
              email: email,
              type: 'company',
            );
          }
        }
        if (context.mounted) {
          showCustomSnackBar(
            context,
            serverMessage.asBullets,
            SnackBarType.error,
          );
        }
        throw Exception(serverMessage.asBullets);
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error during login: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during login: $e');
    }
  }

  @override
  Future<void> register({
    required BuildContext context,
    required RegisterModel registerModel,
  }) async {
    try {
      final formData = await registerModel.toFormData();

      final response = await _remoteConnectionDio.dio.post(
        Constants.registerUrl,
        data: formData,
        options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (_isSuccessfulResponse(response)) {
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            MyRoutes().authOtpView,
            arguments: {
              'email': registerModel.email,
              'isForSignup': true,
              'type': registerModel.type,
            },
          );
        }
        return;
      } else {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          showCustomSnackBar(
            context,
            serverMessage.asBullets,
            SnackBarType.error,
          );
        }
        throw Exception(serverMessage.asBullets);
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error during register: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during register: $e');
    }
  }

  @override
  Future<void> registerConsultant({
    required BuildContext context,
    required ConsultantRegisterModel model,
  }) async {
    try {
      final formData = await model.toFormData();
      final response = await _remoteConnectionDio.dio.post(
        Constants.consultantRegisterUrl,
        data: formData,
        options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      if (_isSuccessfulResponse(response)) {
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            MyRoutes().authOtpView,
            arguments: {'email': model.email, 'isForSignup': true},
          );
        }
        return;
      } else {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          showCustomSnackBar(
            context,
            serverMessage.asBullets,
            SnackBarType.error,
          );
        }
        throw Exception(serverMessage.asBullets);
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error during consultant register: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during consultant register: $e');
    }
  }

  @override
  Future<void> sendActivationCode({
    required BuildContext context,
    required String email,
    required String type,
  }) async {
    try {
      final response = await RemoteConnectionDio().dio.post(
        Constants.sendCodeForActivateUrl,
        data: {'email': email, 'type': type},
      );

      if (_isSuccessfulResponse(response)) {
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            MyRoutes().authOtpView,
            arguments: {'email': email, 'isForSignup': true},
          );
        }
      } else {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          showCustomSnackBar(
            context,
            serverMessage.asBullets,
            SnackBarType.error,
          );
        }
        throw Exception(serverMessage.asBullets);
      }
    } on dio.DioException catch (e) {
      // قراءة رسالة السيرفر من جسم الخطأ (مثل 403) وعرضها
      final data = e.response?.data;
      final rawMessage = data is Map ? data['message'] : null;
      if (rawMessage != null) {
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          showCustomSnackBar(context, serverMessage.asBullets, SnackBarType.error);
        }
        throw Exception(serverMessage.asBullets);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> chackActivationCode({
    required BuildContext context,
    required String email,
    required String code,
    required String type,
  }) async {
    try {
      final response = await RemoteConnectionDio().dio.post(
        Constants.checkCodeForActivateUrl,
        data: {'email': email, 'code': code, 'type': type},
      );

      if (_isSuccessfulResponse(response)) {
        if (context.mounted) {
          showCustomSnackBar(
            context,
            'تم تفعيل الحساب بنجاح',
            SnackBarType.success,
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            MyRoutes().authSiginIn,
            (route) => false,
          );
        }
      } else {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          showCustomSnackBar(
            context,
            serverMessage.asBullets,
            SnackBarType.error,
          );
        }
        throw Exception(serverMessage.asBullets);
      }
    } on dio.DioException catch (e) {
      // قراءة رسالة السيرفر من جسم الخطأ (مثل 403) وعرضها
      final data = e.response?.data;
      final rawMessage = data is Map ? data['message'] : null;
      if (rawMessage != null) {
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          showCustomSnackBar(context, serverMessage.asBullets, SnackBarType.error);
        }
        throw Exception(serverMessage.asBullets);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> forgetPasswordSendCode({
    required BuildContext context,
    required String email,
  }) async {
    try {
      final response = await RemoteConnectionDio().dio.post(
        Constants.forgetPasswordSendCodeUrl,
        data: {'email': email},
      );

      if (_isSuccessfulResponse(response)) {
        Navigator.pushNamed(
          context,
          MyRoutes().authOtpView,
          arguments: {'email': email, 'isForSignup': false},
        );
      } else {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          // العرض بالأعلى لأن النداء يتم من داخل الـ bottom sheet
          showCustomSnackBar(
            context,
            serverMessage.asBullets,
            SnackBarType.error,
            alignTop: true,
          );
        }
        throw Exception(serverMessage.asBullets);
      }
    } on dio.DioException catch (e) {
      // قراءة رسالة السيرفر من جسم الخطأ (مثل 403) وعرضها
      final data = e.response?.data;
      final rawMessage = data is Map ? data['message'] : null;
      if (rawMessage != null) {
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          // العرض بالأعلى لأن النداء يتم من داخل الـ bottom sheet
          showCustomSnackBar(
            context,
            serverMessage.asBullets,
            SnackBarType.error,
            alignTop: true,
          );
        }
        throw Exception(serverMessage.asBullets);
      }
      throw Exception('Network error during sending activation code: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> forgetPasswordChackCode({
    required BuildContext context,
    required String email,
    required String code,
  }) async {
    try {
      final response = await RemoteConnectionDio().dio.post(
        Constants.forgetPasswordCheckCodeUrl,
        data: {'email': email, 'code': code},
      );

      if (_isSuccessfulResponse(response)) {
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            MyRoutes().forgetPasswordScreen,
            arguments: {'email': email},
          );
        }
      } else {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          showCustomSnackBar(
            context,
            serverMessage.asBullets,
            SnackBarType.error,
          );
        }
        throw Exception(serverMessage.asBullets);
      }
    } on dio.DioException catch (e) {
      // قراءة رسالة السيرفر من جسم الخطأ (مثل 403) وعرضها
      final data = e.response?.data;
      final rawMessage = data is Map ? data['message'] : null;
      if (rawMessage != null) {
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          showCustomSnackBar(context, serverMessage.asBullets, SnackBarType.error);
        }
        throw Exception(serverMessage.asBullets);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> forgetResetPassword({
    required BuildContext context,
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await RemoteConnectionDio().dio.post(
        Constants.forgetResetPasswordUrl,
        data: {
          'email': email,
          'new_password': newPassword,
          'confirm_new_password': confirmPassword,
        },
      );

      final rawMessage = response.data is Map ? response.data['message'] : null;
      final serverMessage = ServerMessage.fromResponse(rawMessage);
      final bool ok = _isSuccessfulResponse(response) &&
          (response.data is Map ? response.data['status'] == true : true);

      if (ok) {
        if (context.mounted) {
          // رسالة النجاح من السيرفر ثم الانتقال لتسجيل الدخول
          showCustomSnackBar(
            context,
            serverMessage.asBullets,
            SnackBarType.success,
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            MyRoutes().authSiginIn,
            (route) => false,
          );
        }
      } else {
        if (context.mounted) {
          showCustomSnackBar(
            context,
            serverMessage.asBullets,
            SnackBarType.error,
          );
        }
        throw Exception(serverMessage.asBullets);
      }
    } on dio.DioException catch (e) {
      // قراءة رسالة السيرفر من جسم الخطأ (مثل 403) وعرضها
      final data = e.response?.data;
      final rawMessage = data is Map ? data['message'] : null;
      if (rawMessage != null) {
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context.mounted) {
          showCustomSnackBar(context, serverMessage.asBullets, SnackBarType.error);
        }
        throw Exception(serverMessage.asBullets);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    final code = response.statusCode ?? 0;
    return code >= 200 && code < 300;
  }
}
