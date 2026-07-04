import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:vector_graphics/vector_graphics.dart';

class DashboardCardConsultant extends StatelessWidget {
  final String count;
  final String label;
  final String iconPath;

  const DashboardCardConsultant({
    super.key,
    required this.count,
    required this.label,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(count, style: MyTextStyle().textStyleSemiBold20()),
              VectorGraphic(
                width: 32.w,
                height: 32.h,
                loader: AssetBytesLoader(iconPath),

                colorFilter: ColorFilter.mode(AppColor.uploadImageColor, BlendMode.srcIn),
              ),
            ],
          ),
          SizedBox(height: 26.h),
          Text(label, style: MyTextStyle().textStyleRegularColored12(AppColor.blackColor)),
        ],
      ),
    );
  }
}
