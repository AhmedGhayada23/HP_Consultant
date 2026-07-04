import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/notification_cubit/notification_cubit.dart';
import 'package:hb/core/cubit/notification_cubit/notification_state.dart';
import 'package:hb/core/data/models/notification_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/fb_notifications.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vector_graphics/vector_graphics.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().fetchNotifications();
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) {
      final now = DateTime.now();
      return "${now.day.toString().padLeft(2, '0')}-"
          "${now.month.toString().padLeft(2, '0')}-"
          "${now.year}";
    }
    try {
      final dt = DateTime.parse(iso).toLocal();
      return "${dt.day.toString().padLeft(2, '0')}-"
          "${dt.month.toString().padLeft(2, '0')}-"
          "${dt.year}";
    } catch (_) {
      return iso;
    }
  }

  String _formatTime(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      int hour = dt.hour % 12;
      if (hour == 0) hour = 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour < 12 ? 'AM' : 'PM';
      return '$hour:$minute $period';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColor.gray5,
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppColor.whiteColor),
        ),
        title: Text(
          loc.notifications,
          style: MyTextStyle().textStyleSemiBold16().copyWith(color: AppColor.whiteColor),
        ),
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              final count = state.unreadCount;
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: GestureDetector(
                  onTap: count > 0
                      ? () => context.read<NotificationCubit>().markAllAsRead()
                      : null,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Center(
                          child: VectorGraphic(
                            loader: AssetBytesLoader(AppSvg.notificationSvg),
                            width: 22.w,
                            height: 22.h,
                            colorFilter: const ColorFilter.mode(
                              AppColor.whiteColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      if (count > 0)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: EdgeInsets.all(4.r),
                            constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.h),
                            decoration: const BoxDecoration(
                              color: AppColor.countNotificationBgColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$count',
                                textAlign: TextAlign.center,
                                style: MyTextStyle().textStyleRegular11().copyWith(
                                      color: AppColor.whiteColor,
                                      fontSize: 9.sp,
                                    ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          final bool loading = state.loading;

          if (!loading && state.notifications != null && state.notifications!.isEmpty) {
            return EmptyStateWidget(
              title: loc.no_data_available,
              icon: Icons.notifications_off_outlined,
            );
          }

          // أثناء التحميل: عناصر وهمية بنصوص حتى يظهر شكل الـ Skeleton
          final data = (loading && (state.notifications?.isEmpty ?? true))
              ? List.generate(
                  6,
                  (_) => NotificationModel(
                    title: 'Notification title placeholder',
                    subTitle:
                        'Notification subtitle placeholder text goes here',
                    createdAt: DateTime.now().toIso8601String(),
                  ),
                )
              : (state.notifications ?? const <NotificationModel>[]);

          // تجميع الإشعارات حسب التاريخ مع الحفاظ على الترتيب
          final groups = <String, List<NotificationModel>>{};
          for (final n in data) {
            (groups[_formatDate(n.createdAt)] ??= []).add(n);
          }

          return Skeletonizer(
            enabled: loading,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              children: [
                for (final entry in groups.entries) ...[
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        entry.key,
                        style: MyTextStyle().textStyleSemiBold16(),
                      ),
                    ),
                  ),
                  ...entry.value.map((n) => _NotificationCard(
                        notification: n,
                        time: _formatTime(n.createdAt),
                        onTap: () {
                          if (!n.isRead && n.id != 0) {
                            context.read<NotificationCubit>().markAsRead(n.id);
                          }
                          // التوجيه للصفحة المطلوبة حسب نوع/بيانات الإشعار
                          FbNotifications.navigateFromData(n.navigationPayload);
                        },
                      )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final String time;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(width: 0.5, color: AppColor.borderColor),
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: AppColor.gray5,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: VectorGraphic(
                  loader: AssetBytesLoader(AppSvg.notificationSvg),
                  width: 22.w,
                  height: 22.h,
                  colorFilter: const ColorFilter.mode(
                    AppColor.blackColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: MyTextStyle().textStyleSemiBold16(),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        time,
                        style: MyTextStyle().textStyleRegular11().copyWith(
                              color: AppColor.gray2,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    notification.subTitle,
                    style: MyTextStyle().textStyleRegular14().copyWith(
                          color: AppColor.gray2,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
