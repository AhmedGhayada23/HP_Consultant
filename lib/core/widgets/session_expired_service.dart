import 'package:flutter/material.dart';
import 'package:hb/core/navigation/app_navigator.dart';
import 'package:hb/core/widgets/session_expired_view.dart';

/// يعرض نافذة "انتهت الجلسة" عند 401 مرة واحدة فقط
class SessionExpiredService {
  SessionExpiredService._();
  static final SessionExpiredService instance = SessionExpiredService._();

  bool _isShowing = false;

  void show() {
    if (_isShowing) return;
    final nav = navigatorKey.currentState;
    if (nav == null) return;
    _isShowing = true;
    // تأجيل الدفع لتفادي التعارض مع دورة البناء الحالية
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nav.push(
        PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.transparent,
          pageBuilder: (_, __, ___) => const SessionExpiredView(),
        ),
      );
    });
  }

  void reset() {
    _isShowing = false;
  }
}
