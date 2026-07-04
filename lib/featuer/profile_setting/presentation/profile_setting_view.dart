import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hb/core/cubit/profile_cubit/profile_cubit.dart';
import 'package:hb/core/cubit/profile_cubit/profile_state.dart';
import 'package:hb/core/cubit/user_cubit/user_cubit.dart';
import 'package:hb/core/data/models/user_model.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_accounting_clint.dart';
import 'package:hb/core/widgets/custom_drawer_company.dart';
import 'package:hb/core/widgets/custom_drawer_consultant.dart';
import 'package:hb/core/widgets/custom_drawer_student.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/featuer/profile_setting/presentation/contact_person_view.dart';
import 'package:hb/featuer/profile_setting/presentation/profile_view.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileSettingView extends StatefulWidget {
  const ProfileSettingView({super.key});

  @override
  State<ProfileSettingView> createState() => _ProfileSettingViewState();
}

class _ProfileSettingViewState extends State<ProfileSettingView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final userCubit = context.watch<UserCubit>();

    // تحديد الـ Drawer المناسب حسب نوع المستخدم
    Widget? selectedDrawer;

    switch (userCubit.userType) {
      case UserType.CompanyUser:
        selectedDrawer = const CustomDrawerCompany();
        break;
      case UserType.ConsultantUser:
        selectedDrawer = const CustomDrawerConsultant();
        break;
      case UserType.StudentUser:
        selectedDrawer = const CustomDrawerStudent();
        break;
      case UserType.AccountingClintUser:
        selectedDrawer = const CustomDrawerAccountingClint();
        break;
      case UserType.VisitorUser:
      default:
        selectedDrawer = const Drawer();
    }
    return Scaffold(
      key: _scaffoldKey,
      drawer: selectedDrawer,
      appBar: CustomAppBar(
        title: loc.profile_settings,
        onMenuTap: () {
          _scaffoldKey.currentState
              ?.openDrawer(); // ✅ فتح drawer باستخدام المفتاح
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),

        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state.isLoading == true) {
                    final user = UserModel.fake();
                    return Skeletonizer(
                      enabled: true,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.blackColor,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(radius: 54.r),
                          title: Text(
                            user.name,
                            style: MyTextStyle().textStyleSemiBold16().copyWith(
                              color: AppColor.whiteColor,
                            ),
                          ),
                          subtitle: Text(
                            user.type,
                            style: MyTextStyle().textStyleRegular14().copyWith(
                              color: AppColor.gray1,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  if (state.userModel != null) {
                    final user = state.userModel;
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColor.blackColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 108.r,
                          height: 108.r,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.whiteColor,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: user?.imageUrl ?? '',
                            width: 108.r,
                            height: 108.r,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Icon(
                              Icons.person,
                              size: 48.r,
                              color: AppColor.gray4,
                            ),
                            placeholder: (_, __) => Icon(
                              Icons.person,
                              size: 48.r,
                              color: AppColor.gray4,
                            ),
                          ),
                        ),

                        title: Text(
                          user?.user.name ?? '',
                          style: MyTextStyle().textStyleSemiBold16().copyWith(
                            color: AppColor.whiteColor,
                          ),
                        ),
                        subtitle: Text(
                          user?.user.type ?? '',
                          style: MyTextStyle().textStyleRegular14().copyWith(
                            color: AppColor.gray1,
                          ),
                        ),
                      ),
                    );
                  }
                  return InkWell(
                    onTap: () {
                      log(state.errorMessage.toString());
                    },
                    child: Center(child: Text(state.errorMessage.toString())),
                  );
                },
              ),

              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        // الصفحة تجلب بيانات البروفايل بنفسها
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileView(),
                          ),
                        );
                      },
                      contentPadding: EdgeInsets.zero,
                      minLeadingWidth: 0,
                      minTileHeight: 0,
                      minVerticalPadding: 12.h,

                      title: Text(
                        loc.profile,
                        style: MyTextStyle().textStyleRegular14(),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.r,
                        color: AppColor.blackColor,
                      ),
                    ),

                    DashedLine(),
                    ListTile(
                      onTap: () {
                        // الصفحة تجلب بيانات البروفايل بنفسها
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContactPersonView(),
                          ),
                        );
                      },
                      contentPadding: EdgeInsets.zero,
                      minLeadingWidth: 0,
                      minTileHeight: 0,
                      minVerticalPadding: 12.h,
                      title: Text(
                        loc.contact_person,
                        style: MyTextStyle().textStyleRegular14(),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.r,
                        color: AppColor.blackColor,
                      ),
                    ),

                    DashedLine(),
                    ListTile(
                      onTap: () => showChangeLanguageDialog(context),
                      contentPadding: EdgeInsets.zero,
                      minLeadingWidth: 0,
                      minTileHeight: 0,
                      minVerticalPadding: 12.h,
                      title: Text(
                        loc.change_language,
                        style: MyTextStyle().textStyleRegular14(),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.r,
                        color: AppColor.blackColor,
                      ),
                    ),
                    DashedLine(),
                    ListTile(
                      onTap: () => Navigator.pushNamed(
                        context,
                        MyRoutes().changePasswordView,
                      ),
                      contentPadding: EdgeInsets.zero,
                      minLeadingWidth: 0,
                      minTileHeight: 0,
                      minVerticalPadding: 12.h,
                      title: Text(
                        loc.change_password,
                        style: MyTextStyle().textStyleRegular14(),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.r,
                        color: AppColor.blackColor,
                      ),
                    ),
                    DashedLine(),
                    ListTile(
                      onTap: () => showDeleteAccountDialog(context, () {}),
                      contentPadding: EdgeInsets.zero,
                      minLeadingWidth: 0,
                      minTileHeight: 0,
                      minVerticalPadding: 12.h,
                      title: Text(
                        loc.delete_account,
                        style: MyTextStyle().textStyleRegular14().copyWith(
                          color: AppColor.countNotificationBgColor,
                        ),
                      ),
                    ),
                    DashedLine(),
                    ListTile(
                      onTap: () => showLogOutBottomSheet(context),
                      contentPadding: EdgeInsets.zero,
                      minLeadingWidth: 0,
                      minTileHeight: 0,
                      minVerticalPadding: 12.h,
                      title: Text(
                        loc.log_out,
                        style: MyTextStyle().textStyleRegular14().copyWith(
                          color: AppColor.countNotificationBgColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 20.h),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 16.w),
              //   decoration: BoxDecoration(
              //     color: AppColor.whiteColor,
              //     borderRadius: BorderRadius.circular(16.r),
              //   ),
              //   child: Column(
              //     children: [
              //       ListTile(
              //         contentPadding: EdgeInsets.zero,
              //         minLeadingWidth: 0,
              //         minTileHeight: 0,
              //         minVerticalPadding: 12.h,
              //         title: Text(
              //           loc.terms_conditions,
              //           style: MyTextStyle().textStyleRegular14(),
              //         ),
              //         trailing: Switch(
              //           value: true,
              //           onChanged: (bool value) {},
              //           activeColor: AppColor.k2primeryColor,
              //         ),
              //       ),
              //       DashedLine(),
              //       Text(
              //         loc.two_factor_desc,
              //         style: MyTextStyle().textStyleRegular14().copyWith(
              //           color: AppColor.gray4,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              //    SizedBox(height: 20.h),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 16.w),
              //   decoration: BoxDecoration(
              //     color: AppColor.whiteColor,
              //     borderRadius: BorderRadius.circular(16.r),
              //   ),
              //   child: Column(
              //     children: [
              //       ListTile(
              //         contentPadding: EdgeInsets.zero,
              //         minLeadingWidth: 0,
              //         minTileHeight: 0,
              //         minVerticalPadding: 12.h,
              //         title: Text(
              //           loc.terms_conditions,
              //           style: MyTextStyle().textStyleRegular14(),
              //         ),
              //       ),
              //       DashedLine(),
              //       ListTile(
              //         contentPadding: EdgeInsets.zero,
              //         minLeadingWidth: 0,
              //         minTileHeight: 0,
              //         minVerticalPadding: 12.h,
              //         title: Text(loc.contact_us, style: MyTextStyle().textStyleRegular14()),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
