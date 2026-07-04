import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hb/core/config/storage/local_storage.dart';
import 'package:hb/core/cubit/chat_cubit/chat_conversation_cubit.dart';
import 'package:hb/core/cubit/notification_cubit/notification_cubit.dart';
import 'package:hb/core/navigation/app_navigator.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/featuer/chat_support/presentation/chat_message_view.dart';

const String _channelId = 'hb_channel';
const String _channelName = 'HB Notifications';
const String _channelDesc = 'HB Consulting notifications channel';
const String _androidIcon = '@mipmap/ic_launcher';

final FlutterLocalNotificationsPlugin _localNotifications =
    FlutterLocalNotificationsPlugin();

// ─── Top-level: معالج الرسائل في الخلفية / التطبيق مغلق ──────────────────────
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  try {
    final storage = LocalStorage();
    await storage.initStorage();
    await storage.writeValue('hasUnreadNotification', true);
    if (message.data.isNotEmpty) {
      await storage.writeValue('lastNotificationData', jsonEncode(message.data));
    }
  } catch (e) {
    log('Background handler storage error: $e');
  }
}

// ─── Top-level: الضغط على إشعار محلي والتطبيق في الخلفية ─────────────────────
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  log('🔙 [Background tap] payload=${response.payload}');
  FbNotifications._handlePayload(response.payload);
}

class FbNotifications {
  FbNotifications._();

  /// تُستدعى مرة واحدة في main() بعد Firebase.initializeApp()
  static Future<void> initNotifications() async {
    // معالج الخلفية
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // الأذونات (iOS + Android 13)
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // إعداد قناة Android + الإشعارات المحلية
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.high,
        playSound: true,
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings(_androidIcon),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        log('👉 [Foreground tap] payload=${response.payload}');
        _handlePayload(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // iOS: عرض الإشعار والتطبيق مفتوح
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // تخزين الـ FCM token محلياً
    await _saveFcmToken();

    // المستمعات
    _listenForeground();
    _listenBackgroundTap();
  }

  /// تُستدعى بعد runApp — تعالج فتح التطبيق من حالة مغلقة بالضغط على إشعار
  static Future<void> checkInitialMessage() async {
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      log('🚀 [Terminated → opened] data=${initial.data}');
      await Future.delayed(const Duration(milliseconds: 600));
      _refreshUnread();
      _navigate(initial.data);
    }
  }

  // ── Foreground: التطبيق مفتوح ───────────────────────────────────────────────
  static void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('🔔 [Foreground] ${message.notification?.title} | data=${message.data}');

      await LocalStorage().writeValue('hasUnreadNotification', true);
      _refreshUnread();

      final notification = message.notification;
      // Android لا يعرض heads-up تلقائياً في foreground → نعرضه محلياً
      if (notification != null && Platform.isAndroid) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId,
              _channelName,
              channelDescription: _channelDesc,
              importance: Importance.high,
              priority: Priority.high,
              icon: _androidIcon,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });
  }

  // ── Background tap: التطبيق بالخلفية والمستخدم ضغط الإشعار ──────────────────
  static void _listenBackgroundTap() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('👉 [Background → opened] data=${message.data}');
      _refreshUnread();
      _navigate(message.data);
    });
  }

  // ── حفظ الـ FCM token ───────────────────────────────────────────────────────
  static Future<void> _saveFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      log('FCM Token: $token');
      if (token != null) {
        await LocalStorage().writeValue('fcm_token', token);
      }
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        await LocalStorage().writeValue('fcm_token', newToken);
      });
    } catch (e) {
      log('Failed to get FCM token: $e');
    }
  }

  // ── تحديث عداد الإشعارات غير المقروءة إن أمكن ───────────────────────────────
  static void _refreshUnread({bool retry = true}) {
    final ctx = navigatorKey.currentContext;
    if (ctx == null || !ctx.mounted) {
      // الـ Navigator غير جاهز بعد → أعِد المحاولة في الإطار التالي مرة واحدة
      if (retry) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _refreshUnread(retry: false));
      }
      return;
    }
    try {
      ctx.read<NotificationCubit>().fetchNotifications();
    } catch (_) {/* الكيوبت غير متاح في هذا السياق */}
  }

  // ── فك payload الإشعار المحلي ───────────────────────────────────────────────
  static void _handlePayload(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map) {
        _navigate(Map<String, dynamic>.from(decoded));
        return;
      }
    } catch (_) {}
    _navigate({'action': payload});
  }

  // ── دمج الحقول مع كائن data المتداخل (قد يأتي كنص JSON) ─────────────────────
  static Map<String, dynamic> _merge(Map<String, dynamic> raw) {
    final merged = <String, dynamic>{...raw};
    final nested = raw['data'];
    if (nested is String && nested.isNotEmpty) {
      try {
        final m = jsonDecode(nested);
        if (m is Map) merged.addAll(Map<String, dynamic>.from(m));
      } catch (_) {}
    } else if (nested is Map) {
      merged.addAll(Map<String, dynamic>.from(nested));
    }
    return merged;
  }

  /// توجيه عام حسب بيانات الإشعار — يُستخدم من صفحة الإشعارات عند الضغط
  static void navigateFromData(Map<String, dynamic> data) => _navigate(data);

  // ── منطق التوجيه المركزي حسب بيانات الإشعار ─────────────────────────────────
  static void _navigate(Map<String, dynamic> raw) {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return;

    final data = _merge(raw);
    final routes = MyRoutes();
    final action =
        (data['action'] ?? data['type'] ?? data['purpose'] ?? '')
            .toString()
            .toLowerCase();

    // ── المحادثات ──────────────────────────────────────────────────────────
    if (action.contains('chat')) {
      final convId =
          int.tryParse('${data['conversation_id'] ?? data['id'] ?? ''}');
      if (convId != null) {
        navigator.push(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => ChatConversationCubit(
                conversationId: convId,
                title: (data['title'] ?? '').toString(),
              )..fetchMessages(),
              child: const ChatMessageView(),
            ),
          ),
        );
      } else {
        navigator.pushNamed(routes.chatSupportView);
      }
      return;
    }

    // ── باقي الأنواع ───────────────────────────────────────────────────────
    switch (action) {
      case 'project':
      case 'consultant_project':
        navigator.pushNamed(routes.consultantProjectView);
        break;
      case 'job':
        navigator.pushNamed(routes.jobView);
        break;
      case 'meeting':
      case 'meeting_request':
        navigator.pushNamed(routes.consultantMeetingRequestsView);
        break;
      default:
        navigator.pushNamed(routes.notificationView);
    }
  }
}
