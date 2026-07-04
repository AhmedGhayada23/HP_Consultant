import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/utils/input_formatter.dart';
import 'package:vector_graphics/vector_graphics.dart';

class MyTextFieldWidget extends StatelessWidget {
  final String hintText;
  final bool showIcon;
  final bool showPrefixIcon;
  final String? assetsIcon;
  final String? assetsPrefixIcon;
  final Color? fillColor;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final Function()? onTap;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  int? maxLines;
  MyTextFieldWidget({
    super.key,
    required this.hintText,
    this.showIcon = false,
    this.assetsIcon,
    this.showPrefixIcon = false,
    this.assetsPrefixIcon,
    this.maxLines = 1,
    this.fillColor = AppColor.gray1,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.textInputAction,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.inputFormatters,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      onTap: onTap,
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      maxLength: maxLength,
      inputFormatters: inputFormatters ?? [InputFormatter().secureTextFormatter],
      decoration: InputDecoration(
        counterText: maxLength != null ? '' : null, // إخفاء عدّاد الأحرف
        filled: true,
        fillColor: fillColor, // لون خلفية الحقل
        hintText: hintText,

        hintStyle: MyTextStyle().textStyleMedium15().copyWith(color: AppColor.hintTextColor),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefixIcon: showPrefixIcon
            ? IconButton(
                onPressed: () {},
                icon: VectorGraphic(loader: AssetBytesLoader(assetsPrefixIcon ?? '')),
              )
            : null,
        suffixIcon: showIcon
            ? IconButton(
                onPressed: () {},
                icon: VectorGraphic(loader: AssetBytesLoader(assetsIcon ?? '')),
              )
            : null,

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
          borderSide: const BorderSide(color: Colors.red, width: 0.8),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 0.8),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.borderColor, width: 0.5),
        ),
      ),
    );
  }
}
