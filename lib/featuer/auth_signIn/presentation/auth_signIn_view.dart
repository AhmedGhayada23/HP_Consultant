import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/auth_sigin_cubit/auth_sigin_cubit.dart';
import 'package:hb/core/cubit/auth_sigin_cubit/auth_sigin_state.dart';
// ignore: unused_import
import 'package:hb/core/cubit/user_cubit/user_cubit.dart';
// ignore: unused_import
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
// ignore: unused_import
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/my_text_field_password_widget.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:hb/utils/validators.dart';

class AuthSigninView extends StatefulWidget {
  const AuthSigninView({super.key});

  @override
  State<AuthSigninView> createState() => _AuthSigninViewState();
}

class _AuthSigninViewState extends State<AuthSigninView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthSiginCubit>();
    Locale current = Localizations.localeOf(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: SafeArea(
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
                    margin: EdgeInsets.only(left: 22.w, right: 22.w, bottom: 32.h),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        // Header
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.welcome_back,
                                  style: MyTextStyle().textStyleSemiBold16(),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.please_sign_in,
                                  style: MyTextStyle().textStyleRegular14(),
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                log('✅ تم الضغط'); // شوف إذا بتظهر بالـ console
                                showChangeLanguageDialog(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: AppColor.gray1,
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(width: 0.5, color: AppColor.borderColor),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.language, size: 18),
                                    SizedBox(width: 6.w),
                                    Text(
                                      current.languageCode == 'en' ? 'English' : 'العربية',
                                      style: MyTextStyle().textStyleRegular14(),
                                    ),
                                    SizedBox(width: 4.w),
                                    const Icon(Icons.keyboard_arrow_down, size: 16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),
                        const DashedLine(),
                        SizedBox(height: 24.h),

                        // Email
                        MyTextFieldWidget(
                          controller: cubit.emailController,
                          hintText: AppLocalizations.of(context)!.email_address,
                          validator: (value) => Validators.email(value, context),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),

                        SizedBox(height: 16.h),

                        // Password
                        MyTextFieldPasswordWidget(
                          controller: cubit.passwordController,
                          hintText: AppLocalizations.of(context)!.password,
                          validator: (value) => Validators.password(value, context),
                        ),

                        SizedBox(height: 16.h),

                        // Remember Me + Forgot Password
                        BlocBuilder<AuthSiginCubit, AuthSiginState>(
                          builder: (context, state) {
                            return Row(
                              children: [
                                Switch(
                                  activeColor: AppColor.k2primeryColor,
                                  value: state.remember ?? false,
                                  onChanged: (value) {
                                    context.read<AuthSiginCubit>().toggleRememberMe(value);
                                  },
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  AppLocalizations.of(context)!.remember_me,
                                  style: MyTextStyle().textStyleRegular14().copyWith(
                                    color: AppColor.gray2,
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () => showForgetPasswordPopUp(context),
                                  child: Text(
                                    AppLocalizations.of(context)!.forgot_password,
                                    style: MyTextStyle().textStyleRegular14().copyWith(
                                      color: AppColor.gray2,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        SizedBox(height: 24.h),

                        // Login Button
                        BlocBuilder<AuthSiginCubit, AuthSiginState>(
                          builder: (context, state) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              transitionBuilder: (child, animation) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                              child: state.loading == true
                                  ? SizedBox(
                                      key: const ValueKey('loader'),
                                      width: double.infinity,
                                      height: 64.h,
                                      child: Center(
                                        child: CircleAvatar(
                                          radius: 32.r,
                                          backgroundColor: AppColor.k1primeryColor,
                                          child: CircularProgressIndicator(
                                            color: AppColor.whiteColor,
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      key: const ValueKey('login_button'),
                                      width: double.infinity,
                                      height: 64.h,
                                      child: CustomButton(
                                        onTap: () {
                                          if (_formKey.currentState!.validate()) {
                                            cubit.signIn(context);
                                          }
                                        },
                                        color: AppColor.k1primeryColor,
                                        text: AppLocalizations.of(context)!.login,
                                      ),
                                    ),
                            );
                          },
                        ),

                        // ⛔️ زر "Join as a Guest" موقوف مؤقتاً — للرجوع إليه شيل التعليق
                        /*
                        SizedBox(height: 12.h),
                        CustomButtonBorder(
                          onTap: () {
                            BlocProvider.of<UserCubit>(
                              context,
                            ).getUserState(UserType.VisitorUser);
                            Navigator.pushReplacementNamed(context, MyRoutes().userView);
                          },
                          borderColor: AppColor.k1primeryColor,
                          text: AppLocalizations.of(context)!.join_as_guest,
                        ),
                        */

                        SizedBox(height: 24.h),
                        const DashedLine(),
                        SizedBox(height: 16.h),

                        // Sign Up
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.dont_have_account,
                              style: MyTextStyle().textStyleRegular16(),
                            ),
                            SizedBox(width: 12.w),
                            InkWell(
                              onTap: () => shSignUpAs(context),
                              child: Text(
                                AppLocalizations.of(context)!.sign_up,
                                style: MyTextStyle().textStyleRegular16().copyWith(
                                  color: AppColor.k1primeryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
