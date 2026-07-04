import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/auth_otp_cubit/auth_otp_cubit.dart';
import 'package:hb/core/cubit/auth_otp_cubit/auth_otp_state.dart';
import 'package:hb/core/styles/app_color.dart';

Future<void> showActivationDialog({required BuildContext context, required String email, required String type}) {
  return showDialog(
    context: context,
    barrierDismissible: false, // المستخدم يجب أن يضغط زر لإغلاقه
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // حواف دائرية
        ),
        backgroundColor: AppColor.whiteColor,
        title: Text(
          'تفعيل الحساب',
          style: TextStyle(
            color: AppColor.k1primeryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'هل تريد تفعيل الحساب الخاص بك؟',
          style: TextStyle(color: AppColor.blackColor, fontSize: 16),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          BlocBuilder<AuthOtpCubit, AuthOtpState>(
            builder: (context, state) {
              if (state.isSentOtpLoading != true) {
                return OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColor.gray2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('إلغاء', style: TextStyle(color: AppColor.gray2, fontSize: 16)),
                );
              }
              return SizedBox.shrink();
            },
          ),

          BlocBuilder<AuthOtpCubit, AuthOtpState>(
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: state.isSentOtpLoading == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(),
                          CircleAvatar(
                            key: const ValueKey('loader'),
                            radius: 32.r,
                            backgroundColor: AppColor.k1primeryColor,
                            child: Center(
                              child: CircularProgressIndicator(color: AppColor.whiteColor),
                            ),
                          ),
                          Spacer(),
                        ],
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.k1primeryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: () {
                          context.read<AuthOtpCubit>().sentOtp(context: context, email: email, type: type);
                        },
                        child: Text(
                          'تفعيل',
                          style: TextStyle(
                            color: AppColor.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              );
            },
          ),
        ],
      );
    },
  );
}
