import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:pinput/pinput.dart';

class RoundedPinInput extends StatelessWidget {
  final void Function(String)? onCompleted;
  final String? Function(String?)? validator;

  const RoundedPinInput({super.key, this.onCompleted, this.validator});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60.w,
      height: 70.h,
      textStyle: TextStyle(fontSize: 20.sp, color: Colors.black, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: AppColor.gray1, // لون الخلفية
        borderRadius: BorderRadius.circular(12), // شكل دائري
        border: Border.all(color: AppColor.borderColor, width: 0.5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.borderColor, width: 0.5),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColor.gray1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.borderColor, width: 0.5),
      ),
    );

    return Pinput(
      length: 5, // أو 6 حسب حاجتك
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      onCompleted: onCompleted,
      validator: validator,
    );
  }
}
