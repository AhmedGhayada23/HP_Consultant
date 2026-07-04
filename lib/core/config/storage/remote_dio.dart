import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/local_storage.dart';
import 'package:hb/core/helper/connectivity_service.dart';
import 'package:hb/core/widgets/maintenance_service.dart';
import 'package:hb/core/widgets/session_expired_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'DioExceptions.dart';

class RemoteConnectionDio {
  late final Dio _dio;
  static RemoteConnectionDio? _instance;
  static double? lat;
  static double? lng;

  RemoteConnectionDio._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
        validateStatus: (_) => true,
        // Optimized timeouts for better performance
        receiveTimeout: const Duration(seconds: Constants.receiveTimeout),
        connectTimeout: const Duration(seconds: Constants.connectionTimeout),
        // Keep alive connections for better performance
        extra: {'keep-alive': true},
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${LocalStorage().readValue<String>(Constants.token) ?? ''}',
        },
      ),
    );

    // ⚠️ مؤقّت (وضع التطوير فقط): الخادم يقدّم أحياناً شهادة SSL لا تطابق
    // النطاق (hostname mismatch) فيفشل الـ handshake. نتسامح مع ذلك للنطاقات
    // المعروفة فقط لكي يستمر الاختبار. الإنتاج (release) يبقى بتحقق SSL كامل.
    // الحل الصحيح النهائي: إصلاح شهادة الخادم (CN/SAN) من جهة الـ backend.
    if (!kReleaseMode) {
      final allowedHosts = <String>{
        Uri.parse(Constants.baseUrl).host,
        Uri.parse(Constants.imageUrl).host,
      };
      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback =
              (cert, host, port) => allowedHosts.contains(host);
          return client;
        },
      );
    }

    // Add interceptors with proper error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) {
          log('Response Error :: $e');
          handler.next(e);
          DioExceptions.fromDioError(e).toString();
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          log('Response :: ${response.statusCode}');

          // خطأ سيرفر (500 فما فوق مثل 502/503) → عرض شاشة الصيانة
          if ((response.statusCode ?? 0) >= 500) {
            MaintenanceService.instance.show();
          }

          final isUnauthorized = response.statusCode == 401;
          final data = response.data;
          final hasUnauthenticatedMessage =
              data is Map<String, dynamic> && data['message'] == 'Unauthenticated.';

          if (isUnauthorized || hasUnauthenticatedMessage) {
            log('Session expired');
            // انتهت الجلسة → نافذة تُجبر المستخدم على تسجيل الخروج
            SessionExpiredService.instance.show();
          }

          handler.next(response);
        },
        onRequest: (options, handler) async {
          // ⛔️ منع تنفيذ أي ريكوست عند عدم وجود اتصال بالإنترنت
          final connected = await ConnectivityService.instance.hasConnection();
          if (!connected) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
                error: 'NO_INTERNET',
                message: 'لا يوجد اتصال بالإنترنت',
              ),
            );
          }

          // اللغة المحفوظة للمستخدم (en / ar) تُرسَل مع كل ريكوست
          final lang =
              (LocalStorage().readValue<String>('lang') ?? 'en');
          options.headers['Accept'] = 'application/json';
          options.headers['Accept-Language'] = lang;
          options.headers['X-localization'] = lang;

          final token = LocalStorage().readValue<String>(Constants.token);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    // Add logging interceptor only in debug mode
    if (!const bool.fromEnvironment('dart.vm.product')) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true,
          maxWidth: 30,
        ),
      );
    }
  }

  factory RemoteConnectionDio() {
    return _instance ??= RemoteConnectionDio._();
  }

  Dio get dio => _dio;

  /// Clear cached data if needed
  void clearCache() {
    _dio.httpClientAdapter.close(force: true);
  }

  /// Update authorization token
  void updateToken(String token) {
    _dio.options.headers['Authorization'] = token;
  }
}
