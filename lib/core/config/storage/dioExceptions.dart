import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioError(DioException dioError,
      {bool isPopupLoading = false}) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout with API server";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
          dioError.response!.statusCode,
          dioError.response!.data,
        );
        break;
      case DioExceptionType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      case DioExceptionType.unknown:
        if (dioError.message!.contains("SocketException")) {
          message = 'No Internet';
          break;
        }
      case DioExceptionType.badCertificate:
        message = 'badCertificate';
        break;
      case DioExceptionType.connectionError:
        message = 'connectionError';
        break;
    }
    if (isPopupLoading && Get.isDialogOpen!) Get.back();
    GetSnackBar(
      message: message,
      backgroundColor: Colors.red,
    );
    //showMessages(msg: message, backgroundColor: Colors.red);
  }

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        //Get.toNamed(AppRouting.signInView);
        return ' مصرح بك يرجى تسجيل الدخول';
      case 403:
        return 'Forbidden';
      case 404:
        return error['message'];
      case 500:
        return error['message'];
        // ignore: dead_code
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return 'يوجد مشكلة من السيرفر';
    }
  }

  @override
  String toString() => message;
}
