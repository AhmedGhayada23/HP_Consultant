import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/data/models/details_application_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/l10n/app_localizations.dart';

class ApplicantDetailsCardWidget extends StatelessWidget {
  final DetailsApplicationModel detailsApplicationModel;
  const ApplicantDetailsCardWidget({super.key,required this.detailsApplicationModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.gray1.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.job_applicants, style: MyTextStyle().textStyleMedium20()),
          DashedLine(),
          SizedBox(height: 24.h),

          _buildSection(
            title: AppLocalizations.of(context)!.about,
            content:
                detailsApplicationModel.about ?? '',
          ),

          _buildSection(
            title: AppLocalizations.of(context)!.education,
            content:
               detailsApplicationModel.education ?? '',
          ),

          _buildSection(
            title: AppLocalizations.of(context)!.availability,
            content:
              detailsApplicationModel.availability ?? '',
          ),

          DashedLine(),
          SizedBox(height: 24.h),

          _buildSection(
            title: AppLocalizations.of(context)!.recent_projects,
            content:
               detailsApplicationModel.recentProject ?? '',
          ),

          _buildSection(
            title: AppLocalizations.of(context)!.work_history,
            content:
               detailsApplicationModel.workHistory ?? '',
          ),

          DashedLine(),
          SizedBox(height: 24.h),

          _buildSection(
            title: AppLocalizations.of(context)!.available_dates,
            content:
               detailsApplicationModel.availableDates ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: MyTextStyle().textStyleRegular14()),
        SizedBox(height: 8.h),
        Text(content, style: MyTextStyle().textStyleMedium14()),
        SizedBox(height: 24.h),
      ],
    );
  }
}
