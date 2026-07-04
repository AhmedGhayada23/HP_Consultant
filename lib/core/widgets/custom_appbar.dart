import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart'; // أو AppSvg
import 'package:vector_graphics/vector_graphics.dart';
import 'notification_icon_widget.dart'; // استورد الويدجت السابق

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuTap;

  const CustomAppBar({super.key, required this.title, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.blackColor,
      leading: IconButton(
        onPressed: onMenuTap,
        icon: VectorGraphic(
          loader: AssetBytesLoader(AppSvg.menuSvg),
          colorFilter: const ColorFilter.mode(AppColor.whiteColor, BlendMode.srcIn),
          width: 24.w,
          height: 24.h,
        ),
      ),
      title: Text(
        title,
        style: MyTextStyle().textStyleSemiBold20().copyWith(color: AppColor.whiteColor),
      ),
      actions: [
        const NotificationIconWidget(),
        SizedBox(width: 8.w),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
