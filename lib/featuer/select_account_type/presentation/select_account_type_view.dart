import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';

class SelectAccountTypeView extends StatelessWidget {
  const SelectAccountTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // الخلفية السوداء
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                color: AppColor.blackColor,
                child: Center(child: Image.asset(AppImage.logoAuthImage)),
              ),

              // الكارد فوق الخلفية الرمادية
              Transform.translate(
                offset: Offset(0, -(MediaQuery.of(context).size.height * 0.08)),
                child: Container(
                  margin: EdgeInsets.only(
                    left: 22.w,
                    right: 22.w,
                    bottom: 32.h,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 24.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 24,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: MyTextStyle().textStyleSemiBold22(),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Select your account type to get started',
                        style: MyTextStyle().textStyleRegular14().copyWith(
                          color: AppColor.gray2,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 28.h),
                      _AccountTypeCard(
                        icon: Icons.business_outlined,
                        label: 'Company',
                        description: 'Manage projects & hire talent',
                        iconColor: AppColor.k2primeryColor,
                        onTap: () => Navigator.pushNamed(
                          context,
                          MyRoutes().authSiginIn,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _AccountTypeCard(
                        icon: Icons.person_outline_rounded,
                        label: 'Consultant',
                        description: 'Offer expertise & grow your clients',
                        iconColor: AppColor.k1primeryColor,
                        onTap: () => Navigator.pushNamed(
                          context,
                          MyRoutes().authSiginIn,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _AccountTypeCard(
                        icon: Icons.school_outlined,
                        label: 'Student',
                        description: 'Learn, intern & build your career',
                        iconColor: AppColor.orangColor,
                        onTap: () => Navigator.pushNamed(
                          context,
                          MyRoutes().authSiginIn,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _AccountTypeCard(
                        icon: Icons.calculate_outlined,
                        label: 'Accounting Client',
                        description: 'Access financial & accounting services',
                        iconColor: AppColor.blackColor,
                        onTap: () => Navigator.pushNamed(
                          context,
                          MyRoutes().authSiginIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountTypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color iconColor;
  final VoidCallback onTap;

  const _AccountTypeCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColor.borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, size: 24.sp, color: iconColor),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: MyTextStyle().textStyleSemiBold14()),
                  SizedBox(height: 3.h),
                  Text(
                    description,
                    style: MyTextStyle().textStyleRegularColored12(
                      AppColor.gray2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.sp,
              color: AppColor.gray2,
            ),
          ],
        ),
      ),
    );
  }
}
