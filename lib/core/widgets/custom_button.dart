import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_font.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.color,
    required this.text,
    this.textColor = Colors.white,
    this.icons,
  });

  final void Function() onTap;
  final Color color;
  final String text;
  final Color? textColor;
  final Widget? icons;

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
          color: color,
          borderRadius: BorderRadius.circular(12.r),
          border: textColor == Colors.white
              ? Border.all(color: Colors.transparent)
              : Border.all(color: Colors.grey),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icons != null) ...[
              icons!,
              SizedBox(width: 8.w), // مسافة بين الأيقونة والنص
            ],

            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: MyTextStyle().textStyleMediumColored14(textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
