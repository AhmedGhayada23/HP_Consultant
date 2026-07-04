import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/drawer_menu_item.dart';
import 'package:vector_graphics/vector_graphics.dart';

class CustomDrawerVisitor extends StatelessWidget {
  const CustomDrawerVisitor({super.key});

  @override
  Widget build(BuildContext context) {
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
                      title: 'Jobs & Projects',
                      onTap: () => Navigator.pushNamed(context, MyRoutes().visitorHome),
                    ),
                    DashedLine(),
                    DrawerMenuItem(
                      iconPath: AppSvg.projectsSvg,
                      title: 'Course Discovery',
                      onTap: () => Navigator.pushNamed(context, MyRoutes().visitorCourseDiscoveryView),
                    ),
                    DashedLine(),
                    DrawerMenuItem(
                      iconPath: AppSvg.hbLabSvg,
                      title: 'HB Lab',
                      onTap: () => Navigator.pushNamed(context, MyRoutes().hbLabView),
                    ),
                    DashedLine(),
                    DrawerMenuItem(
                      iconPath: AppSvg.jobSvg,
                      title: 'Career Opportunities',
                      onTap: () => Navigator.pushNamed(context, MyRoutes().visitorCareerOpportunities),
                    ),
                    DashedLine(),
                    DrawerMenuItem(
                      iconPath: AppSvg.supportSvg,
                      title: 'Chat & Support',
                      onTap: () => Navigator.pushNamed(context, MyRoutes().chatSupportView),
                    ),
                    DashedLine(),
                    DrawerMenuItem(
                      iconPath: AppSvg.notificationSvg,
                      title: 'Notifications',
                      onTap: () => Navigator.pushNamed(context, MyRoutes().notificationView),
                    ),
                    DashedLine(),
                    DrawerMenuItem(
                      iconPath: AppSvg.loginSvg,
                      title: 'Login',
                      onTap: () => Navigator.pushReplacementNamed(context, MyRoutes().authSiginIn),
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
