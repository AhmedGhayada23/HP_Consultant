import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/l10n/app_localizations.dart';

class JobMarketplaceCardWidget extends StatelessWidget {
  final String category;
  final String title;
  final String company;
  final String budget;
  final String deadline;
  final VoidCallback onApply;
  final VoidCallback onViewDetails;

  const JobMarketplaceCardWidget({
    super.key,
    required this.category,
    required this.title,
    required this.company,
    required this.budget,
    required this.deadline,
    required this.onApply,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CategoryChip(category: category),
          SizedBox(height: 12.h),
          Text(title, style: MyTextStyle().textStyleMedium16()),

          DashedLine(),
          SizedBox(height: 20.h),

          InfoRow(label: '${loc.company}:', value: company),
          SizedBox(height: 20.h),

          InfoRow(label: '${loc.budget}:', value: budget),
          SizedBox(height: 20.h),

          InfoRow(label: '${loc.deadline}:', value: deadline),
          SizedBox(height: 20.h),

          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onTap: onApply,
                  color: AppColor.k1primeryColor,
                  text: loc.apply_now,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: CustomButtonBorder(
                  onTap: onViewDetails,
                  borderColor: AppColor.k1primeryColor,
                  text: loc.view_details,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String category;

  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(color: AppColor.gray4, borderRadius: BorderRadius.circular(50.r)),
          child: Center(
            child: Text(
              category,
              style: MyTextStyle().textStyleMedium12().copyWith(color: AppColor.uploadImageColor),
            ),
          ),
        ),
      ],
    );
  }
}
