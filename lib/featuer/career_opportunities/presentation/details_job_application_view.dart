import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/core/cubit/job_opportunity_details_cubit/job_opportunity_details_cubit.dart';
import 'package:hb/core/cubit/job_opportunity_details_cubit/job_opportunity_details_state.dart';
import 'package:hb/core/data/models/job_opportunity_details_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/featuer/career_opportunities/presentation/apply_new_job_application_view.dart';
import 'package:hb/featuer/user_home/student_home/widgets/course_overview_section.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vector_graphics/vector_graphics.dart';

class DetailsJobApplicationView extends StatefulWidget {
  final int jobId;
  const DetailsJobApplicationView({super.key, required this.jobId});

  @override
  State<DetailsJobApplicationView> createState() =>
      _DetailsJobApplicationViewState();
}

class _DetailsJobApplicationViewState extends State<DetailsJobApplicationView> {
  @override
  void initState() {
    super.initState();
    context.read<JobOpportunityDetailsCubit>().fetchJobDetails(widget.jobId);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocBuilder<JobOpportunityDetailsCubit, JobOpportunityDetailsState>(
      builder: (context, state) {
        final loading = state.loading;
        final data = state.data ?? JobOpportunityDetailsModel();

        return Skeletonizer(
          enabled: loading,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.blackColor,
              iconTheme: const IconThemeData(color: AppColor.whiteColor),
              title: Text(
                data.title ?? loc.job_title,
                style: MyTextStyle()
                    .textStyleSemiBold20()
                    .copyWith(color: AppColor.whiteColor),
              ),
            ),
            bottomNavigationBar: Container(
              height: 100.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    offset: const Offset(0, -3),
                    color: AppColor.borderColor,
                  ),
                ],
              ),
              child: CustomButton(
                onTap: data.alreadyApplied
                    ? () {}
                    : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplyNewJobApplicationView(
                            jobId: data.id,
                            jobTitle: data.title,
                            duration: data.duration,
                            company: data.companyName,
                          ),
                        ),
                      ),
                color: AppColor.k1primeryColor,
                text: data.alreadyApplied ? loc.already_applied : loc.apply_now,
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoRow(label: loc.job_title, value: data.title ?? ''),
                        SizedBox(height: 20.h),
                        InfoRow(
                          label: loc.company,
                          value: data.companyName ?? '',
                        ),
                        SizedBox(height: 20.h),
                        InfoRow(label: loc.type_label, value: data.jobTypeLabel ?? ''),
                        SizedBox(height: 20.h),
                        InfoRow(
                          label: loc.stipend_pay,
                          value: data.stipend ?? '',
                        ),
                        SizedBox(height: 20.h),
                        InfoRow(label: loc.duration, value: data.duration ?? ''),
                        SizedBox(height: 20.h),
                        InfoRow(
                          label: loc.company_location,
                          value: data.companyLocation ?? '',
                        ),
                        SizedBox(height: 20.h),
                        InfoRow(
                          label: loc.job_location,
                          value: data.jobLocation ?? data.location ?? '',
                        ),
                        SizedBox(height: 20.h),
                        InfoRow(
                          label: loc.start_date,
                          value: data.startDateDisplay ?? '',
                        ),
                        SizedBox(height: 20.h),
                        InfoRow(
                          label: loc.deadline,
                          value: data.deadlineDisplay ?? '',
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          loc.description,
                          style: MyTextStyle().textStyleMedium14(),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          data.description ?? '',
                          style: MyTextStyle().textStyleMedium15(),
                        ),

                        if (data.responsibilities.isNotEmpty) ...[
                          SizedBox(height: 20.h),
                          Text(
                            loc.responsibilities,
                            style: MyTextStyle().textStyleMedium14(),
                          ),
                          SizedBox(height: 12.h),
                          ...data.responsibilities.map(
                            (e) => BulletPoint(text: e),
                          ),
                        ],

                        if (data.requirements.isNotEmpty) ...[
                          SizedBox(height: 20.h),
                          Text(
                            loc.requirements,
                            style: MyTextStyle().textStyleMedium14(),
                          ),
                          SizedBox(height: 12.h),
                          ...data.requirements.map((e) => BulletPoint(text: e)),
                        ],

                        if (data.benefits.isNotEmpty) ...[
                          SizedBox(height: 20.h),
                          Text(
                            loc.benefits,
                            style: MyTextStyle().textStyleMedium14(),
                          ),
                          SizedBox(height: 12.h),
                          ...data.benefits.map((e) => BulletPoint(text: e)),
                        ],

                        if (data.requiredSkills.isNotEmpty) ...[
                          SizedBox(height: 20.h),
                          Text(
                            loc.required_skills,
                            style: MyTextStyle().textStyleMedium14(),
                          ),
                          SizedBox(height: 12.h),
                          Wrap(
                            spacing: 8.r,
                            runSpacing: 8.r,
                            children: data.requiredSkills
                                .map(
                                  (skill) => Chip(
                                    backgroundColor: AppColor.gray5,
                                    side: BorderSide.none,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    label: Text(
                                      skill,
                                      style: MyTextStyle()
                                          .textStyleMedium16()
                                          .copyWith(color: AppColor.blackColor),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (data.attachments.isNotEmpty) ...[
                    SizedBox(height: 24.h),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.project_files_deliverables,
                            style: MyTextStyle().textStyleMedium16(),
                          ),
                          SizedBox(height: 20.h),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.attachments.length,
                            separatorBuilder: (_, __) => SizedBox(height: 10.h),
                            itemBuilder: (context, index) {
                              final file = data.attachments[index];
                              return Container(
                                padding: EdgeInsets.all(16.r),
                                decoration: BoxDecoration(
                                  color: AppColor.gray5,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      minLeadingWidth: 0,
                                      minTileHeight: 0,
                                      minVerticalPadding: 0,
                                      contentPadding: EdgeInsets.zero,
                                      leading: Container(
                                        width: 39.w,
                                        height: 43.h,
                                        decoration: BoxDecoration(
                                          color: AppColor.k1primeryColor
                                              .withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                        child: Center(
                                          child: VectorGraphic(
                                            loader: AssetBytesLoader(
                                              AppSvg.fileSvg,
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        file.fileName,
                                        style: MyTextStyle()
                                            .textStyleRegular14(),
                                      ),
                                      subtitle: Text(
                                        file.typeLabel,
                                        style: MyTextStyle()
                                            .textStyleRegular11(),
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    CustomButtonBorder(
                                      onTap: () {},
                                      borderColor: AppColor.k1primeryColor,
                                      text: loc.download_file,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
