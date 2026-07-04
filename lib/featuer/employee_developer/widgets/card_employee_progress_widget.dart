// ─── card_employee_progress_widget.dart ──────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/data/models/employee_progress_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/dashed_line.dart';

class CardEmployeeProgressWidget extends StatelessWidget {
  final EmployeeProgressModel employee;

  const CardEmployeeProgressWidget({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColor.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(employee.employeeName, style: MyTextStyle().textStyleSemiBold16()),
          DashedLine(),
          SizedBox(height: 20.h),

          _InfoRow(label: 'Course Title:', value: employee.courseTitle),
          SizedBox(height: 20.h),

          _InfoRow(label: 'Progress:', value: '${employee.progress}%'),
          SizedBox(height: 8.h),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: employee.progress / 100,
              minHeight: 6.h,
              backgroundColor: AppColor.borderColor,
              color: AppColor.k1primeryColor,
            ),
          ),
          SizedBox(height: 20.h),

          _InfoRow(
            label: 'Status:',
            value: employee.status,
            valueColor: AppColor.k1primeryColor,
          ),
          SizedBox(height: 20.h),

          CustomButtonBorder(
            onTap: () {},
            borderColor: AppColor.blackColor,
            text: 'Download',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
        ),
        Text(
          value,
          style: MyTextStyle().textStyleMedium14().copyWith(
                color: valueColor ?? AppColor.gray3,
              ),
        ),
      ],
    );
  }
}
