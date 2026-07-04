import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/data/models/job_details_modle.dart';
import 'package:hb/core/data/models/jobs_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/l10n/app_localizations.dart';

// تأكد أنك عرّفت AppColor و MyTextStyle في مكان مناسب

class JobDetailsCard extends StatelessWidget {
  final JobDetailsModle detailsJobTalentModel;
  const JobDetailsCard({
    super.key,
    required this.detailsJobTalentModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(AppLocalizations.of(context)!.job_title, detailsJobTalentModel.title),
          SizedBox(height: 20.h),
          _buildRow(AppLocalizations.of(context)!.budget, detailsJobTalentModel.budgetDisplay),
          SizedBox(height: 20.h),
          _buildRow(AppLocalizations.of(context)!.created_on, detailsJobTalentModel.createdOn),
          SizedBox(height: 20.h),
          _buildRow(AppLocalizations.of(context)!.deadline, detailsJobTalentModel.deadline  ),
          SizedBox(height: 20.h),
          Text(AppLocalizations.of(context)!.required_skills, style: MyTextStyle().textStyleRegular14()),
          SizedBox(height: 12.h),
          Text(detailsJobTalentModel.requiredSkills.map((s) => s).join('- '), style: MyTextStyle().textStyleMedium14()),
          SizedBox(height: 20.h),
          Text(AppLocalizations.of(context)!.job_description, style: MyTextStyle().textStyleRegular14()),
          SizedBox(height: 12.h),
          Text(
           detailsJobTalentModel.description,
            style: MyTextStyle().textStyleMedium14(),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: MyTextStyle().textStyleRegular14()),
        Text(value, style: MyTextStyle().textStyleMedium14()),
      ],
    );
  }
}
