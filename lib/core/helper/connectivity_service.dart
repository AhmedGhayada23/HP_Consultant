import 'package:connectivity_plus/connectivity_plus.dart';

/// خدمة فحص الاتصال بالإنترنت على مستوى التطبيق.
class ConnectivityService {
  ConnectivityService._();
  static final ConnectivityService instance = ConnectivityService._();

  final Connectivity _connectivity = Connectivity();

  bool _connected(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  /// هل يوجد اتصال حالياً؟ (عند فشل الفحص نرجّع true حتى لا نمنع الطلبات بالغلط)
  Future<bool> hasConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _connected(results);
    } catch (_) {
      return true;
    }
  }

  /// تيار يبثّ حالة الاتصال (true = متصل) عند أي تغيّر.
  Stream<bool> get onStatusChange =>
      _connectivity.onConnectivityChanged.map(_connected);
}
