import 'package:flutter/material.dart';

/// Global navigator key — مشترك بين main.dart والـ FbNotifications
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppNavigator {
  static NavigatorState? get _navigator => navigatorKey.currentState;

  /// انتقال بسيط لصفحة مسجّلة في MyRoutes
  static void pushNamed(String routeName, {Object? arguments}) {
    _navigator?.pushNamed(routeName, arguments: arguments);
  }

  /// انتقال مع إزالة كل الصفحات السابقة
  static void pushNamedAndRemoveAll(String routeName, {Object? arguments}) {
    _navigator?.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
}
