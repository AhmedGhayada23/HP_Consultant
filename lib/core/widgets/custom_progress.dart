import 'package:flutter/material.dart';
import 'package:hb/core/styles/app_color.dart';

class CustomProgress extends StatelessWidget {
  final double progress;
  const CustomProgress({super.key,required this.progress});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress, // القيمة بين 0.0 و 1.0
      minHeight: 12,
      backgroundColor: AppColor.k1primeryColor.withValues(alpha: 0.15),
      valueColor: AlwaysStoppedAnimation<Color>(AppColor.k1primeryColor),
      borderRadius: BorderRadius.circular(8),
    );
  }
}
