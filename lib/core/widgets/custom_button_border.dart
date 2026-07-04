import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';

class CustomButtonBorder extends StatelessWidget {
  final VoidCallback onTap;
  final Color borderColor;
  final String text;

  const CustomButtonBorder({super.key, required this.onTap, required this.borderColor,required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height: 50.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(width: 1.w, color: borderColor),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: MyTextStyle().textStyleMediumColored14(borderColor),
        ),
      ),
    );
  }
}
