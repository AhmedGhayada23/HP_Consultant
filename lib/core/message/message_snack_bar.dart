import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_font.dart';

enum SnackBarType { success, error, warning, noConnection, successInterNet }

void showCustomSnackBar(BuildContext context, String message, SnackBarType type,
    {VoidCallback? onTap}) {
  IconData icon;
  Color iconColor;
  Color backgroundColor;

  switch (type) {
    case SnackBarType.success:
      icon = Icons.check_circle;
      iconColor = Colors.green;
      backgroundColor = Colors.black;
      break;

    case SnackBarType.successInterNet:
      icon = Icons.wifi;
      iconColor = Colors.green;
      backgroundColor = Colors.black;
      break;

    case SnackBarType.error:
      icon = Icons.error;
      iconColor = Colors.red;
      backgroundColor = Colors.black;
      break;
    case SnackBarType.warning:
      icon = Icons.warning;
      iconColor = Colors.orange;
      backgroundColor = Colors.black;
      break;
    case SnackBarType.noConnection:
      icon = Icons.signal_wifi_off;
      iconColor = Colors.red;
      backgroundColor = Colors.black;
      break;
  }

  final snackBar = SnackBar(
    content: GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 12.r,
                child: Center(child: Icon(icon, color: iconColor, size: 18.r)),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  message,
                  style: MyTextStyle().textStyleMediumColored14(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
  );

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } else {
    print("State is unmounted, cannot show snackbar.");
  }
}
