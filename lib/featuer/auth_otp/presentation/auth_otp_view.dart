import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/auth_otp_cubit/auth_otp_cubit.dart';
import 'package:hb/core/cubit/auth_otp_cubit/auth_otp_state.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/featuer/auth_otp/widgets/rounded_pin_input.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';

class AuthOtpView extends StatefulWidget {
  const AuthOtpView({super.key});

  @override
  State<AuthOtpView> createState() => _AuthOtpViewState();
}

class _AuthOtpViewState extends State<AuthOtpView> {
  final _formKey = GlobalKey<FormState>();
  String otpCode = '';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthOtpCubit>();
    final l = AppLocalizations.of(context)!;
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final email = args != null && args.containsKey('email') ? args['email'] as String : '';
    final isForSignup = args != null && args.containsKey('isForSignup') ? args['isForSignup'] as bool : false;
    final type = args != null && args.containsKey('type') ? args['type'] as String : '';

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
                  child: Center(
                    child: Image.asset(AppImage.logoAuthImage),
                  ),
                ),

                // الكارد
                Container(
                  color: AppColor.backgroundColor,
                  child: Transform.translate(
                    offset: Offset(0, -(MediaQuery.of(context).size.height * 0.08)),
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 22.w,
                        right: 22.w,
                        bottom: 32.h,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(l.email_verification, style: MyTextStyle().textStyleSemiBold16()),
                          const DashedLine(),
                          SizedBox(height: 24.h),
                          Text(
                            l.email_verification_desc,
                            style: MyTextStyle().textStyleRegular16(),
                          ),
                          SizedBox(height: 24.h),
                          RoundedPinInput(
                            validator: (value) => Validators.required(value, context),
                            onCompleted: (pin) {
                              setState(() => otpCode = pin);
                            },
                          ),
                          SizedBox(height: 24.h),
                          BlocBuilder<AuthOtpCubit, AuthOtpState>(
                            builder: (context, state) {
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(opacity: animation, child: child),
                                child: state.isCheckOtpLoading == true
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
                                        key: const ValueKey('submit_button'),
                                        width: double.infinity,
                                        height: 64.h,
                                        child: CustomButton(
                                          onTap: () {
                                            if (_formKey.currentState!.validate()) {
                                              if (isForSignup) {
                                                cubit.checkOtp(
                                                  context: context,
                                                  email: email,
                                                  code: otpCode,
                                                  type: type,
                                                );
                                              } else {
                                                cubit.forgetPasswordCheckOtp(
                                                  context: context,
                                                  email: email,
                                                  code: otpCode,
                                                );
                                              }
                                            }
                                          },
                                          color: AppColor.k1primeryColor,
                                          text: l.submit,
                                        ),
                                      ),
                              );
                            },
                          ),
                          SizedBox(height: 24.h),
                          const DashedLine(),
                          SizedBox(height: 24.h),
                          InkWell(
                            onTap: () {
                              if (isForSignup) {
                                cubit.sentOtp(context: context, email: email, type: type);
                              } else {
                                cubit.forgetPasswordSendCode(context: context, email: email);
                              }
                            },
                            child: Center(
                              child: Text(
                                l.resend_verification_email,
                                style: MyTextStyle().textStyleRegular16().copyWith(
                                  color: AppColor.k1primeryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
