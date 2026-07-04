import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/update_job_cubit/update_job_cubit.dart';
import 'package:hb/core/data/models/jobs_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_popup_widget.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/featuer/jobs_and_talent/presentation/details_job_and_talent_view.dart';
import 'package:hb/featuer/jobs_and_talent/presentation/edit_job_view.dart';
import 'package:hb/l10n/app_localizations.dart';

class CardJobWidget extends StatelessWidget {
  final JobsModel jobModel;
  const CardJobWidget({super.key, required this.jobModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColor.whiteColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(jobModel.title, style: MyTextStyle().textStyleSemiBold16()),

              CustomPopupWidget(
                items: [
                  PopupMenuItemModel(
                    text: AppLocalizations.of(context)!.view,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailsJobAndTalentView(jobAndTalentModel: jobModel),
                        ),
                      );
                    },
                  ),
                  PopupMenuItemModel(
                    text: AppLocalizations.of(context)!.edit,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditJobView(job: jobModel)),
                      );
                    },
                  ),
                  PopupMenuItemModel(
                    text: AppLocalizations.of(context)!.close,
                    onTap: () {
                      context.read<UpdateJobCubit>().closeJob(context: context, jobId: jobModel.id);
                    },
                    color: Colors.red,
                  ),
                ],
                child: Container(
                  width: 28.w,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColor.gray5,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Center(child: Icon(Icons.more_vert_outlined)),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          DashedLine(),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context)!.applicants}:',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
              Text(
                jobModel.applicantsCount.toString(),
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context)!.budget}:',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
              Text(
                jobModel.budget,
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context)!.created_on}: ',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
              Text(
                jobModel.createdOn,
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context)!.status}: ',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
              Text(
                jobModel.status,
                style: MyTextStyle().textStyleMedium14().copyWith(
                  color: jobModel.statusColor == 'green'
                      ? AppColor.k1primeryColor
                      : AppColor.countNotificationBgColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
