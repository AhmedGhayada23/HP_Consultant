import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/notification_cubit/notification_cubit.dart';
import 'package:hb/core/cubit/notification_cubit/notification_state.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:vector_graphics/vector_graphics.dart';

class NotificationIconWidget extends StatefulWidget {
  const NotificationIconWidget({super.key});

  @override
  State<NotificationIconWidget> createState() => _NotificationIconWidgetState();
}

class _NotificationIconWidgetState extends State<NotificationIconWidget> {
  @override
  void initState() {
    super.initState();
    // تحديث عدّاد غير المقروء عند ظهور الـ AppBar في أي صفحة
    // نستخدم fetchNotifications (تحسب العدد من القائمة) لأنها مصدر موثوق
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<NotificationCubit>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, MyRoutes().notificationView),
      child: Container(
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: AppColor.hintTextColor,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: VectorGraphic(
                width: 24.w,
                height: 24.h,
                loader: AssetBytesLoader(AppSvg.notificationSvg),
                colorFilter: const ColorFilter.mode(
                  AppColor.whiteColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            BlocBuilder<NotificationCubit, NotificationState>(
              buildWhen: (prev, curr) => prev.unreadCount != curr.unreadCount,
              builder: (context, state) {
                final count = state.unreadCount;
                if (count <= 0) return const SizedBox.shrink();
                return Positioned(
                  right: -3,
                  top: -4,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    constraints: BoxConstraints(
                      minWidth: 16.w,
                      minHeight: 16.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.countNotificationBgColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColor.blackColor, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      textAlign: TextAlign.center,
                      style: MyTextStyle().textStyleRegular11().copyWith(
                            color: AppColor.whiteColor,
                            fontSize: 9.sp,
                            height: 1,
                          ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
