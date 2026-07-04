import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? svgPath;
  final double? iconSize;
  final Color? iconColor;
  final VoidCallback? onActionPressed;
  final String? actionButtonText;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.svgPath,
    this.iconSize,
    this.iconColor,
    this.onActionPressed,
    this.actionButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColor.borderColor ?? Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon or SVG
          if (svgPath != null)
            SvgPicture.asset(
              svgPath!,
              width: iconSize ?? 60.w,
              height: iconSize ?? 60.h,
              colorFilter: ColorFilter.mode(
                iconColor ?? Colors.grey[400]!,
                BlendMode.srcIn,
              ),
            )
          else if (icon != null)
            Icon(
              icon,
              size: iconSize ?? 60.sp,
              color: iconColor ?? Colors.grey[400],
            )
          else
            Icon(
              Icons.inbox_outlined,
              size: iconSize ?? 60.sp,
              color: iconColor ?? Colors.grey[400],
            ),

          SizedBox(height: 16.h),

          // Title
          Text(
            title,
            style: MyTextStyle().textStyleSemiBold16().copyWith(
                  color: Colors.black87,
                ),
            textAlign: TextAlign.center,
          ),

          // Subtitle (optional)
          if (subtitle != null) ...[
            SizedBox(height: 8.h),
            Text(
              subtitle!,
              style: MyTextStyle().textStyleRegular14().copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],

          // Action Button (optional)
          if (onActionPressed != null && actionButtonText != null) ...[
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: onActionPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.k1primeryColor,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                actionButtonText!,
                style: MyTextStyle().textStyleMedium14().copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
