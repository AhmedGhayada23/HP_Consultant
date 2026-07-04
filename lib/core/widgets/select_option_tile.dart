import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';

class SelectOptionTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final TextStyle? textStyle;

  const SelectOptionTile({
    super.key,
    required this.title,
    this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            width: 0.3.w,
            color: AppColor.borderColor,
          ),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: textStyle ?? MyTextStyle().textStyleRegular16(),
        ),
      ),
    );
  }
}
