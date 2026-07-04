import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:vector_graphics/vector_graphics.dart';

class DrawerMenuItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback? onTap;

  const DrawerMenuItem({super.key, required this.iconPath, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 32.w,
        height: 32.h,
        child: VectorGraphic(
          loader: AssetBytesLoader(iconPath),
          colorFilter: const ColorFilter.mode(AppColor.whiteColor, BlendMode.srcIn),
          width: 32.w,
          height: 32.h,
          fit: BoxFit.contain,
        ),
      ),

      // VectorGraphic(iconPath,colorFilter : ColorFilter.mode(AppColor.whiteColor, BlendMode.srcIn)),
      title: Text(
        title,
        style: MyTextStyle().textStyleRegular16().copyWith(color: AppColor.whiteColor),
      ),
      onTap: onTap,
    );
  }
}
