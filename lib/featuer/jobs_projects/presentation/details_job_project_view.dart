import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/details_job_project_cubit/details_job_project_cubit.dart';
import 'package:hb/core/cubit/details_job_project_cubit/details_job_project_state.dart';
import 'package:hb/core/cubit/profile_cubit/profile_cubit.dart';
import 'package:hb/core/cubit/user_cubit/user_cubit.dart';
import 'package:hb/core/data/models/job_project_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vector_graphics/vector_graphics.dart';

class DetailsJobProjectView extends StatefulWidget {
  final JobProjectModel jobProjectModel;
  const DetailsJobProjectView({super.key, required this.jobProjectModel});

  @override
  State<DetailsJobProjectView> createState() => _DetailsJobProjectViewState();
}

class _DetailsJobProjectViewState extends State<DetailsJobProjectView> {
  @override
  void initState() {
    super.initState();
    getDetailsJobProject();
  }

  void getDetailsJobProject() {
    context
        .read<DetailsJobProjectCubit>()
        .fetchDetailsJobProject(widget.jobProjectModel.id);
    // حمّل بيانات البروفايل لعرض اسم المستخدم في نافذة الرفع
    if (context.read<ProfileCubit>().state.userModel == null) {
      context.read<ProfileCubit>().fetchUserProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userCubit = context.watch<UserCubit>();
    return BlocBuilder<DetailsJobProjectCubit, DetailsJobProjectState>(
      builder: (context, state) {
        return Skeletonizer(
          enabled: state.loading ?? false,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.blackColor,
              iconTheme: IconThemeData(color: AppColor.whiteColor),
              title: Text(
                'Job Details',
                style: MyTextStyle().textStyleSemiBold20().copyWith(color: AppColor.whiteColor),
              ),
            ),
            bottomNavigationBar: Container(
              height: 100.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                boxShadow: [BoxShadow(color: AppColor.borderColor, offset: Offset(0, -3))],
              ),
              child: CustomButton(
                onTap: () {
                  if (userCubit.userType == UserType.VisitorUser) {
                    showPlaceLoginDialog(context);
                  } else {
                    final projectId =
                        state.data?.id ?? widget.jobProjectModel.id;
                    final userName = context
                            .read<ProfileCubit>()
                            .state
                            .userModel
                            ?.user
                            .name ??
                        '';
                    showUploadDialog(
                      context,
                      projectId: projectId,
                      milestones: state.data?.mekestonesAndTasks ?? const [],
                      userName: userName,
                      onSuccess: () => context
                          .read<DetailsJobProjectCubit>()
                          .fetchDetailsJobProject(projectId),
                    );
                  }
                },
                color: AppColor.k1primeryColor,
                text: 'Upload New Files',
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w, vertical: 32.h),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoRow(
                              label: 'Job Title',
                              value: state.data?.title ??
                                  widget.jobProjectModel.title ??
                                  ''),
                          SizedBox(height: 20.h),
                          InfoRow(label: 'Type ', value: state.data?.jobTypeLabel ?? ''),
                          SizedBox(height: 20.h),
                          InfoRow(label: 'Budget ', value: state.data?.budget ?? ''),
                          SizedBox(height: 20.h),
                          InfoRow(
                              label: 'Deadline ',
                              value: state.data?.deadline ??
                                  widget.jobProjectModel.deadline ??
                                  ''),
                          SizedBox(height: 20.h),
                          InfoRow(
                              label: 'Status ',
                              value: state.data?.status ??
                                  widget.jobProjectModel.status ??
                                  ''),
                          SizedBox(height: 20.h),
                          InfoRow(label: 'Category ', value: state.data?.category ?? ''),
                          if ((state.data?.companyName ?? '').isNotEmpty) ...[
                            SizedBox(height: 20.h),
                            InfoRow(
                                label: 'Company ', value: state.data?.companyName ?? ''),
                          ],
                          if ((state.data?.jobLocation ?? '').isNotEmpty) ...[
                            SizedBox(height: 20.h),
                            InfoRow(
                                label: 'Location ', value: state.data?.jobLocation ?? ''),
                          ],
                          SizedBox(height: 20.h),
                          Text('Description', style: MyTextStyle().textStyleMedium14()),

                          SizedBox(height: 8.h),
                          Text(
                            state.data?.description ?? '',
                            style: MyTextStyle().textStyleMedium14(),
                          ),

                          if ((state.data?.requiredSkills ?? []).isNotEmpty) ...[
                            SizedBox(height: 20.h),
                            Text('Required Skills',
                                style: MyTextStyle().textStyleSemiBold16()),
                            SizedBox(height: 12.h),
                            Wrap(
                              spacing: 8.r,
                              runSpacing: 8.r,
                              children: state.data!.requiredSkills!
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

                          if ((state.data?.mekestonesAndTasks ?? []).isNotEmpty) ...[
                            DashedLine(),
                            SizedBox(height: 20.h),
                            Text('Milestones & Tasks',
                                style: MyTextStyle().textStyleSemiBold16()),
                            SizedBox(height: 16.h),
                            ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Container(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: AppColor.gray5,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.data?.mekestonesAndTasks?[index].title ?? '',
                                      style: MyTextStyle().textStyleSemiBold16(),
                                    ),
                                    SizedBox(height: 20.h),
                                    InfoRow(
                                      label: 'Deadline: ',
                                      value:
                                          state.data?.mekestonesAndTasks?[index].deadline ?? '',
                                    ),
                                    SizedBox(height: 20.h),
                                    InfoRow(
                                      label: 'Status:  ',
                                      value:
                                          state.data?.mekestonesAndTasks?[index].status ?? '',
                                    ),
                                  ],
                                ),
                              ),
                              separatorBuilder: (context, index) => SizedBox(height: 10.h),
                              itemCount: state.data?.mekestonesAndTasks?.length ?? 0,
                            ),
                          ],

                          if ((state.data?.payments ?? []).isNotEmpty) ...[
                            DashedLine(),
                            SizedBox(height: 20.h),
                            Text('Payments', style: MyTextStyle().textStyleSemiBold16()),
                            SizedBox(height: 16.h),
                            ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Container(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                                decoration: BoxDecoration(
                                  color: AppColor.gray5,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InfoRow(
                                      label: 'Invoice #: ',
                                      value: state.data?.payments?[index].uvoiceNumber ?? '',
                                    ),
                                    SizedBox(height: 20.h),
                                    InfoRow(
                                      label: 'Amount:  ',
                                      value: state.data?.payments?[index].amount ?? '',
                                    ),
                                    SizedBox(height: 20.h),
                                    InfoRow(
                                      label: 'Date:  ',
                                      value: state.data?.payments?[index].date ?? '',
                                    ),
                                    SizedBox(height: 20.h),
                                    InfoRow(
                                      label: 'Status ',
                                      value: state.data?.payments?[index].status ?? '',
                                    ),
                                  ],
                                ),
                              ),
                              separatorBuilder: (context, index) => SizedBox(height: 10.h),
                              itemCount: state.data?.payments?.length ?? 0,
                            ),
                          ],

                          if ((state.data?.attachments ?? []).isNotEmpty) ...[
                            DashedLine(),
                            SizedBox(height: 20.h),
                            Text(
                              'Project Files / Deliverables',
                              style: MyTextStyle().textStyleSemiBold16(),
                            ),
                            SizedBox(height: 20.h),
                            ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final file = state.data!.attachments![index];
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
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                          child: Center(
                                            child: VectorGraphic(
                                              loader: AssetBytesLoader(AppSvg.fileSvg),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          file.fileName,
                                          style: MyTextStyle().textStyleRegular14(),
                                        ),
                                        subtitle: Text(
                                          file.typeLabel,
                                          style: MyTextStyle().textStyleRegular11(),
                                        ),
                                      ),
                                      SizedBox(height: 12.h),
                                      CustomButtonBorder(
                                        onTap: () {},
                                        borderColor: AppColor.k1primeryColor,
                                        text: 'Download File',
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(height: 10.h),
                              itemCount: state.data?.attachments?.length ?? 0,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
