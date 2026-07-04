import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hb/core/config/storage/remote_dio.dart';

abstract class StoreTokenDataSource {
  Future<void> storeToken();
}

class StoreTokenDataSourceImpl implements StoreTokenDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<void> storeToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) return;
    try {
      await _dio.post('/store-token', data: {'fcm_token': token});
      log('store-token sent: $token');
    } on dio.DioException catch (e) {
      throw Exception('Network error while storing token: ${e.message}');
    }
  }
}
