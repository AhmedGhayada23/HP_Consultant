import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';

class CustomCheckboxTextRow extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final String text;

  const CustomCheckboxTextRow({
    super.key,
    required this.isChecked,
    required this.onChanged,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => onChanged(!isChecked),
          child: Container(
            width: 25.w,
            height: 30.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.borderColor),
              borderRadius: BorderRadius.circular(6),
              color: isChecked ? AppColor.blackColor : Colors.white,
            ),
            child: isChecked
                ? Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: MyTextStyle().textStyleRegular14(),
          ),
        ),
      ],
    );
  }
}
