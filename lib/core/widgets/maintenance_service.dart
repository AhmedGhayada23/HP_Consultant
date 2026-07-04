import 'package:flutter/material.dart';
import 'package:hb/core/navigation/app_navigator.dart';
import 'package:hb/core/widgets/maintenance_view.dart';

/// يعرض شاشة الصيانة عند أخطاء السيرفر (500 فما فوق) مرة واحدة فقط
class MaintenanceService {
  MaintenanceService._();
  static final MaintenanceService instance = MaintenanceService._();

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
          opaque: true,
          pageBuilder: (_, __, ___) => const MaintenanceView(),
        ),
      );
    });
  }

  void reset() {
    _isShowing = false;
  }
}
