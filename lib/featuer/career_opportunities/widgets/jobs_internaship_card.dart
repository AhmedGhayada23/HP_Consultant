import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/data/models/jobs_internship_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/featuer/career_opportunities/presentation/apply_new_job_application_view.dart';
import 'package:hb/featuer/career_opportunities/presentation/details_job_application_view.dart';
import 'package:hb/l10n/app_localizations.dart';

class JobsInternashipCard extends StatelessWidget {
  final JobsInternshipModel? jobsInternshipModel;
  const JobsInternashipCard({super.key,this.jobsInternshipModel});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColor.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(jobsInternshipModel?.title  ?? '', style: MyTextStyle().textStyleSemiBold14()),
          SizedBox(height: 8.h),
          Text(jobsInternshipModel?.company  ?? '', style: MyTextStyle().textStyleMedium14()),
          DashedLine(),
          SizedBox(height: 20.h),
          InfoRow(label: '${loc.duration}: ', value: jobsInternshipModel?.duration  ?? ''),
          SizedBox(height: 12.h),

          InfoRow(label: '${loc.location}: ', value: jobsInternshipModel?.location  ?? ''),
          SizedBox(height: 12.h),

          InfoRow(label: '${loc.requirements}: ', value: ''),
          SizedBox(height: 12.h),

          Text(jobsInternshipModel?.requirements  ?? '', style: MyTextStyle().textStyleMedium15()),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApplyNewJobApplicationView(
                        jobId: jobsInternshipModel?.id ?? 0,
                        jobTitle: jobsInternshipModel?.title,
                        duration: jobsInternshipModel?.duration,
                        company: jobsInternshipModel?.company,
                      ),
                    ),
                  ),
                  color: AppColor.k1primeryColor,
                  text: loc.apply_now,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomButtonBorder(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsJobApplicationView(
                        jobId: jobsInternshipModel?.id ?? 0,
                      ),
                    ),
                  ),
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
