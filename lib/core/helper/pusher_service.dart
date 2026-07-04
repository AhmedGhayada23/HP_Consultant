import 'dart:developer';

import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

/// خدمة Pusher مشتركة:
/// - تُهيّئ الاتصال مرة واحدة (PusherChannelsFlutter هو singleton).
/// - تدعم اشتراكات متعددة في آن واحد (قناة المحادثة + قناة المستخدم).
/// - توجّه كل حدث للمستمع الخاص بقناته (حسب channelName).
/// - لا تقطع الاتصال إلا عند عدم وجود أي مشترك.
class PusherService {
  PusherService._();
  static final PusherService instance = PusherService._();

  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  bool _initialized = false;
  bool _connected = false;

  // قناة → مستمع
  final Map<String, void Function(PusherEvent)> _handlers = {};

  Future<void> _ensureInit() async {
    if (_initialized) return;
    await _pusher.init(
      apiKey: Constants.pusherAppKey,
      cluster: Constants.pusherCluster,
      useTLS: true,
      onEvent: _dispatch,
      authEndpoint: Constants.pusherAuthUrl,
      onAuthorizer: _onAuthorize,
      onConnectionStateChange: (current, previous) =>
          log('Pusher: $previous → $current'),
      onError: (msg, code, error) =>
          log('Pusher error: $msg | code: $code | $error'),
    );
    _initialized = true;
  }

  // توجيه الحدث للمستمع المرتبط بالقناة
  void _dispatch(PusherEvent event) {
    final handler = _handlers[event.channelName];
    handler?.call(event);
  }

  Future<dynamic> _onAuthorize(
      String channelName, String socketId, dynamic options) async {
    try {
      final response = await RemoteConnectionDio().dio.post(
        Constants.pusherAuthUrl,
        data: {'socket_id': socketId, 'channel_name': channelName},
      );
      return response.data;
    } catch (e) {
      log('Pusher auth error: $e');
      return null;
    }
  }

  /// الاشتراك بقناة مع مستمع خاص بها. آمن للاستدعاء من أكثر من Cubit.
  Future<void> subscribe({
    required String channelName,
    required void Function(PusherEvent) onEvent,
  }) async {
    await _ensureInit();
    _handlers[channelName] = onEvent;
    try {
      await _pusher.subscribe(channelName: channelName);
    } catch (e) {
      log('Pusher subscribe error ($channelName): $e');
    }
    if (!_connected) {
      await _pusher.connect();
      _connected = true;
    }
  }

  /// إلغاء الاشتراك. يقطع الاتصال فقط لو ما ضل أي مشترك آخر.
  Future<void> unsubscribe(String channelName) async {
    _handlers.remove(channelName);
    try {
      await _pusher.unsubscribe(channelName: channelName);
    } catch (_) {}
    if (_handlers.isEmpty && _connected) {
      await _pusher.disconnect();
      _connected = false;
    }
  }
}
