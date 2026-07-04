import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/forget_password_cubit/forget_password_cubit.dart';
import 'package:hb/core/cubit/forget_password_cubit/forget_password_state.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/my_text_field_password_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _newPasswordTextEditingController;
  late TextEditingController _confirmNewPasswordTextEditingController;

  @override
  void initState() {
    super.initState();
    _newPasswordTextEditingController = TextEditingController();
    _confirmNewPasswordTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _newPasswordTextEditingController.dispose();
    _confirmNewPasswordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final email = args != null && args.containsKey('email') ? args['email'] as String : '';

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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              l.forgot_password,
                              style: MyTextStyle().textStyleSemiBold16(),
                            ),
                          ),
                          const DashedLine(),
                          SizedBox(height: 24.h),

                          // New Password
                          MyTextFieldPasswordWidget(
                            controller: _newPasswordTextEditingController,
                            hintText: l.new_password,
                            validator: (value) => Validators.password(value, context),
                          ),
                          SizedBox(height: 16.h),

                          // Confirm New Password
                          MyTextFieldPasswordWidget(
                            controller: _confirmNewPasswordTextEditingController,
                            hintText: l.confirm_new_password,
                            validator: (value) => Validators.match(
                              value,
                              _newPasswordTextEditingController.text,
                              context,
                              fieldName: l.confirm_new_password,
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // Save Button
                          BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                            builder: (context, state) {
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(opacity: animation, child: child),
                                child: state.isLoading == true
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
                                        key: const ValueKey('save_button'),
                                        width: double.infinity,
                                        height: 64.h,
                                        child: CustomButton(
                                          onTap: () {
                                            if (_formKey.currentState!.validate()) {
                                              context.read<ForgetPasswordCubit>().forgetPassword(
                                                context: context,
                                                email: email,
                                                newPassword: _newPasswordTextEditingController.text,
                                                confirmPassword: _confirmNewPasswordTextEditingController.text,
                                              );
                                            }
                                          },
                                          color: AppColor.k1primeryColor,
                                          text: l.save_changes,
                                        ),
                                      ),
                              );
                            },
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
