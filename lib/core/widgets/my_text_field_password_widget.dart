import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:vector_graphics/vector_graphics.dart';

class MyTextFieldPasswordWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const MyTextFieldPasswordWidget({
    super.key,
    required this.hintText,
    this.controller,
    this.validator,
  });

  @override
  State<MyTextFieldPasswordWidget> createState() => _MyTextFieldPasswordWidgetState();
}

class _MyTextFieldPasswordWidgetState extends State<MyTextFieldPasswordWidget> {
  bool _obscureText = true; // التحكم بإظهار أو إخفاء كلمة السر

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.gray1,
        hintText: widget.hintText,
        hintStyle: MyTextStyle().textStyleMedium15().copyWith(color: AppColor.hintTextColor),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText; // تبديل حالة الإظهار/الإخفاء
            });
          },
          icon: VectorGraphic(
            loader: AssetBytesLoader(_obscureText ? AppSvg.eyeSvg : AppSvg.eyeOffSvg),
            colorFilter: const ColorFilter.mode(AppColor.blackColor, BlendMode.srcIn),

            width: 24.w,
            height: 24.h,
            // أيقونة مختلفة لكل حالة
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.borderColor, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.borderColor, width: 0.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.borderColor, width: 0.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.borderColor, width: 0.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.borderColor, width: 0.5),
        ),
      ),
    );
  }
}
