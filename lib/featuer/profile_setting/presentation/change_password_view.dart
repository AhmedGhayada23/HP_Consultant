import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/change_passsword_cubit/change_passsword_cubit.dart';
import 'package:hb/core/cubit/change_passsword_cubit/change_passsword_state.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/my_text_field_password_widget.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();

  @override
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // ✅
    final cubit = context.read<ChangePassswordCubit>();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColor.whiteColor),
        backgroundColor: AppColor.blackColor,
        title: Text(
          loc.change_password, // ✅
          style: MyTextStyle().textStyleSemiBold16().copyWith(color: AppColor.whiteColor),
        ),
      ),
      bottomNavigationBar: BlocBuilder<ChangePassswordCubit, ChangePassswordState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: state.isLoading == true
                ? CircleAvatar(
                    key: const ValueKey('loader'),
                    radius: 32.r,
                    backgroundColor: AppColor.k1primeryColor,
                    child: CircularProgressIndicator(color: AppColor.whiteColor),
                  )
                : Container(
                    height: 100.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: CustomButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          cubit.changePassword(context: context);
                        }
                      },
                      color: AppColor.k1primeryColor,
                      text: loc.save_changes, // ✅
                    ),
                  ),
          );
        },
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w, vertical: 24.h),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  MyTextFieldWidget(
                    controller: cubit.currentPassController,
                    hintText: loc.previous_password, // ✅
                    validator: (value)=> Validators.password(value, context),
                  ),
                  SizedBox(height: 16.h),
                  MyTextFieldPasswordWidget(
                    controller: cubit.newPassController,
                    hintText: loc.new_password, // ✅
                    validator: (value)=> Validators.password(value, context),
                  ),
                  SizedBox(height: 16.h),
                  MyTextFieldPasswordWidget(
                    controller: cubit.confirmPassController,
                    hintText: loc.confirm_new_password, // ✅
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return loc.please_confirm_password; // ✅
                      }
                      if (value != cubit.newPassController.text) {
                        return loc.passwords_not_match; // ✅
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
