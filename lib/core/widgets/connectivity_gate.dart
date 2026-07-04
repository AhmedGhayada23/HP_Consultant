import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hb/core/helper/connectivity_service.dart';
import 'package:hb/core/widgets/no_internet_view.dart';

/// بوابة اتصال على مستوى التطبيق:
/// تعرض شاشة "لا يوجد اتصال بالإنترنت" فوق التطبيق عند انقطاع الشبكة.
class ConnectivityGate extends StatefulWidget {
  final Widget? child;
  const ConnectivityGate({super.key, required this.child});

  @override
  State<ConnectivityGate> createState() => _ConnectivityGateState();
}

class _ConnectivityGateState extends State<ConnectivityGate> {
  bool _online = true;
  StreamSubscription<bool>? _sub;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final online = await ConnectivityService.instance.hasConnection();
    if (mounted) setState(() => _online = online);
    _sub = ConnectivityService.instance.onStatusChange.listen((online) {
      if (mounted) setState(() => _online = online);
    });
  }

  Future<void> _retry() async {
    final online = await ConnectivityService.instance.hasConnection();
    if (mounted) setState(() => _online = online);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child ?? const SizedBox.shrink(),
        if (!_online)
          Positioned.fill(child: NoInternetView(onRetry: _retry)),
      ],
    );
  }
}
