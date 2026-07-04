import 'package:flutter/widgets.dart';

/// يلفّ التطبيق ليتيح "إعادة تشغيل ناعمة": إعادة بناء الشجرة كاملة بمفتاح جديد
/// (تُعاد تهيئة كل الـ Cubits وتُقرأ اللغة المحفوظة من جديد).
class RestartWidget extends StatefulWidget {
  final Widget child;
  const RestartWidget({super.key, required this.child});

  // مرجع ثابت للحالة لتفادي البحث في الشجرة (الذي قد يفشل بسبب DevicePreview)
  static _RestartWidgetState? _state;

  static void restartApp() => _state?.restart();

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    RestartWidget._state = this;
  }

  void restart() {
    setState(() => _key = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.child);
  }
}
