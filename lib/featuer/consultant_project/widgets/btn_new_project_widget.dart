import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';

class BtnNewProjectWidget extends StatelessWidget {
    final Function()? onTap;
    final String title;
  const BtnNewProjectWidget({super.key,required this.onTap,required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(color: AppColor.whiteColor),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Container(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppColor.k1primeryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1.5.w, color: AppColor.whiteColor),
                  ),
                  child: Center(
                    child: Icon(Icons.add, color: AppColor.whiteColor, size: 15.r),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: MyTextStyle().textStyleMedium15().copyWith(color: AppColor.whiteColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
