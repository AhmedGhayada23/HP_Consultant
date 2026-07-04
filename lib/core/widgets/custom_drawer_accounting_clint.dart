import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/drawer_menu_item.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:vector_graphics/vector_graphics.dart';

class CustomDrawerAccountingClint extends StatelessWidget {
  const CustomDrawerAccountingClint({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Drawer(
      backgroundColor: AppColor.blackColor,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: VectorGraphic(
                  loader: AssetBytesLoader(AppSvg.closeSvg),
                  colorFilter: const ColorFilter.mode(AppColor.whiteColor, BlendMode.srcIn),
                  width: 32.w,
                  height: 32.h,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DrawerMenuItem(
                      iconPath: AppSvg.projectsSvg,
                      title: loc.service_requests,
                      onTap: () => Navigator.pushNamed(context, MyRoutes().accountingClintView),
                    ),
                    DashedLine(),
                    DrawerMenuItem(
                      iconPath: AppSvg.pepolsSvg,
                      title: loc.consultants_directory,
                      onTap: () => Navigator.pushNamed(context, MyRoutes().counsultantsDirectoryView),
                    ),
                    DashedLine(),
                    DrawerMenuItem(
                      iconPath: AppSvg.hbLabSvg,
                      title: loc.hb_lab,
                      onTap: () => Navigator.pushNamed(context, MyRoutes().hbLabAccountingView),
                    ),
                    DashedLine(),
                    DrawerMenuItem(
                      iconPath: AppSvg.paymentSvg,
                      title: loc.reports_invoices,
                      onTap: () => Navigator.pushNamed(context, MyRoutes().reportsIvoicesView),
                    ),
                    DashedLine(),
                    DrawerMenuItem(
                      iconPath: AppSvg.messageSvg,
                      title: loc.messages,
                      onTap: () => Navigator.pushNamed(context, MyRoutes().messageView),
                    ),
                    DashedLine(),
                    DrawerMenuItem(
                      iconPath: AppSvg.supportSvg,
                      title: loc.chat_support,
                      onTap: () => Navigator.pushNamed(context, MyRoutes().chatSupportView),
                    ),
                    DashedLine(),
                    DrawerMenuItem(
                      iconPath: AppSvg.notificationSvg,
                      title: loc.notifications,
                      onTap: () => Navigator.pushNamed(context, MyRoutes().notificationView),
                    ),
                    DashedLine(),
                    DrawerMenuItem(
                      iconPath: AppSvg.profileSvg,
                      title: loc.profile_settings,
                      onTap: () => Navigator.pushNamed(context, MyRoutes().profileSettingView),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
