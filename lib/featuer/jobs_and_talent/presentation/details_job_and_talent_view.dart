import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/details_job_talent_cubit/details_job_talent_cubit.dart';
import 'package:hb/core/cubit/details_job_talent_cubit/details_job_talent_state.dart';
import 'package:hb/core/cubit/job_application_cubit/job_application_cubit.dart';
import 'package:hb/core/cubit/job_application_cubit/job_application_state.dart';
import 'package:hb/core/cubit/job_details_cubit/job_details_cubit.dart';
import 'package:hb/core/cubit/job_details_cubit/job_details_state.dart';
import 'package:hb/core/cubit/update_job_cubit/update_job_cubit.dart';
import 'package:hb/core/data/models/job_details_modle.dart';
import 'package:hb/core/data/models/jobs_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/featuer/jobs_and_talent/presentation/edit_job_view.dart';
import 'package:hb/featuer/jobs_and_talent/widgets/job_applicants_section_widget.dart';
import 'package:hb/featuer/jobs_and_talent/widgets/job_details_card.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailsJobAndTalentView extends StatefulWidget {
  final JobsModel jobAndTalentModel;
  const DetailsJobAndTalentView({super.key, required this.jobAndTalentModel});

  @override
  State<DetailsJobAndTalentView> createState() => _DetailsJobAndTalentViewState();
}

class _DetailsJobAndTalentViewState extends State<DetailsJobAndTalentView> {
  @override
  void initState() {
    super.initState();
    getDetailsJobTalent();
    getJobApplication();
  }

  void getDetailsJobTalent() {
    context.read<JobDetailsCubit>().fetchJobDetails(widget.jobAndTalentModel.id);
  }

  void getJobApplication() {
    context.read<JobApplicationCubit>().fetchJobApplication(widget.jobAndTalentModel.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        backgroundColor: AppColor.blackColor,
        title: Text(
          AppLocalizations.of(context)!.job_details,
          style: MyTextStyle().textStyleSemiBold16().copyWith(color: AppColor.whiteColor),
        ),
      ),
      bottomNavigationBar: BlocBuilder<DetailsJobTalentCubit, DetailsJobTalentState>(
        builder: (context, jobTalentState) {
          final bool loadingJobTalent = jobTalentState.loading ?? false;

          return BlocBuilder<JobApplicationCubit, JobApplicationState>(
            builder: (context, jobAppState) {
              final bool loadingApplications = jobAppState.loading ?? false;
              // ✅ نفعّل Skeletonizer لو أحد الـ cubits ما زال يحمل بيانات
              final bool isLoading = loadingJobTalent || loadingApplications;
              return Skeletonizer(
                enabled: isLoading,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  height: 100.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButtonBorder(
                          onTap: () {
                                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditJobView(job: widget.jobAndTalentModel)),
                      );
                          }, // تعطيل الزر أثناء التحميل
                          borderColor: AppColor.k1primeryColor,
                          text: AppLocalizations.of(context)!.edit_job,
                        ),
                      ),
                      SizedBox(width: 11.w),
                      Expanded(
                        child: CustomButtonBorder(
                          onTap: () {
                            // تأكيد الإغلاق عبر bottom sheet قبل تنفيذ الطلب
                            showConfirmDialog(
                              context,
                              title: AppLocalizations.of(context)!.close_job,
                              subTitle: AppLocalizations.of(context)!
                                  .close_job_confirm_message,
                              confirmText:
                                  AppLocalizations.of(context)!.close_job,
                              onConfirm: () => context
                                  .read<UpdateJobCubit>()
                                  .closeJob(
                                    context: context,
                                    jobId: widget.jobAndTalentModel.id,
                                  ),
                            );
                          },
                          borderColor: AppColor.countNotificationBgColor,
                          text: AppLocalizations.of(context)!.close_job,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
          child: Column(
            children: [
              BlocBuilder<JobDetailsCubit, JobDetailsState>(
                builder: (context, state) {
                  final bool loading = state.isLoading;
                  final data = state.jobDetails ?? JobDetailsModle.fake();
                  return Skeletonizer(
                    enabled: loading,
                    child: JobDetailsCard(detailsJobTalentModel: data),
                  );
                },
              ),
              SizedBox(height: 20.h),
              BlocBuilder<JobApplicationCubit, JobApplicationState>(
                builder: (context, state) {
                  final bool loading = state.loading ?? false;
                  final data = state.data ?? [];
                  return Skeletonizer(
                    enabled: loading,
                    child: data.isEmpty && !loading
                        ? EmptyStateWidget(
                            title: AppLocalizations.of(context)!.no_applicants,
                            subtitle: AppLocalizations.of(context)!.no_applicants_subtitle,
                            icon: Icons.people_outline,
                          )
                        : JobApplicantsSectionWidget(
                            data: data,
                            currentPage: state.currentPage,
                            totalPages: state.totalPages,
                            onPageChange: (page) => context
                                .read<JobApplicationCubit>()
                                .fetchJobApplication(
                                  widget.jobAndTalentModel.id,
                                  page: page,
                                ),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
