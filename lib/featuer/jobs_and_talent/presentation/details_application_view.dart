import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/details_application_cubit/details_application_cubit.dart';
import 'package:hb/core/cubit/details_application_cubit/details_application_state.dart';
import 'package:hb/core/cubit/reject_application_cubit/reject_application_cubit.dart';
import 'package:hb/core/cubit/reject_application_cubit/reject_application_state.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/data/models/details_application_model.dart';
import 'package:hb/core/data/models/job_application_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/featuer/jobs_and_talent/widgets/applicant_details_card_widget.dart';
import 'package:hb/featuer/jobs_and_talent/widgets/job_applicant_card_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailsApplicationView extends StatefulWidget {
  final JobApplicationModel jobApplicationModel;
  const DetailsApplicationView({super.key, required this.jobApplicationModel});

  @override
  State<DetailsApplicationView> createState() => _DetailsApplicationViewState();
}

class _DetailsApplicationViewState extends State<DetailsApplicationView> {
  String selectedStatus = 'Invite to Interview';

  @override
  void initState() {
    super.initState();
    getDetailsAppLication();
  }

  void getDetailsAppLication() {
    context.read<DetailsApplicationCubit>().fetchDetailsApplication(
      widget.jobApplicationModel.applicationId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        backgroundColor: AppColor.blackColor,
        title: Text(
          AppLocalizations.of(context)!.applicant_details,
          style: MyTextStyle().textStyleSemiBold16().copyWith(
            color: AppColor.whiteColor,
          ),
        ),
      ),
      bottomNavigationBar:
          BlocBuilder<DetailsApplicationCubit, DetailsApplicationState>(
            builder: (context, state) {
              final bool loading = state.loading ?? false;
              return Skeletonizer(
                enabled: loading,
                child: Container(
                  height: 100.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.gray1.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(
                          0,
                          -3,
                        ), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onTap: () {
                            setState(() {
                              selectedStatus = AppLocalizations.of(
                                context,
                              )!.hire;
                            });

                            if (selectedStatus ==
                                AppLocalizations.of(context)!.hire) {
                              showScheduleMeetingDialog(
                                context,
                                applicationId:
                                    widget.jobApplicationModel.applicationId,
                              );
                            }
                          },
                          color: AppColor.k1primeryColor,
                          text: selectedStatus == 'Invite to Interview'
                              ? AppLocalizations.of(
                                  context,
                                )!.invite_to_interview
                              : selectedStatus,
                          textColor: AppColor.whiteColor,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child:
                            BlocConsumer<
                              RejectApplicationCubit,
                              RejectApplicationState
                            >(
                              listener: (context, rejectState) {
                                if (rejectState.success == true) {
                                  showRequestSubmittedDialog(
                                    context,
                                    title: 'Application Rejected',
                                    subTitle:
                                        'The application has been rejected.',
                                    textBtn: 'Done',
                                    onDone: () => Navigator.pop(context),
                                  );
                                } else if (rejectState.success == false &&
                                    rejectState.errorMessage != null) {
                                  showCustomSnackBar(
                                    context,
                                    rejectState.errorMessage!,
                                    SnackBarType.error,
                                  );
                                }
                              },
                              builder: (context, rejectState) {
                                return CustomButtonBorder(
                                  onTap: rejectState.isLoading
                                      ? () {}
                                      : () => context
                                            .read<RejectApplicationCubit>()
                                            .rejectApplication(
                                              widget
                                                  .jobApplicationModel
                                                  .applicationId,
                                            ),
                                  borderColor:
                                      AppColor.countNotificationBgColor,
                                  text: rejectState.isLoading
                                      ? '...'
                                      : AppLocalizations.of(context)!.reject,
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      body: BlocBuilder<DetailsApplicationCubit, DetailsApplicationState>(
        builder: (context, state) {
          final bool loading = state.loading ?? false;
          final data = state.data ?? DetailsApplicationModel();
          return Skeletonizer(
            enabled: loading,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
                child: Column(
                  children: [
                    JobApplicantCardWidget(
                      jobApplicationModel: widget.jobApplicationModel,
                    ),
                    SizedBox(height: 10.h),
                    ApplicantDetailsCardWidget(detailsApplicationModel: data),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
