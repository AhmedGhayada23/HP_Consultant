import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/assigned_project_cubit/assigned_project_cubit.dart';
import 'package:hb/core/cubit/assigned_project_cubit/assigned_project_state.dart';
import 'package:hb/core/data/models/consultant_project_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AssignToAProjectView extends StatefulWidget {
  final ConsultantProjectModel consultantProjectModel;
  const AssignToAProjectView({super.key, required this.consultantProjectModel});

  @override
  State<AssignToAProjectView> createState() => _AssignToAProjectViewState();
}

class _AssignToAProjectViewState extends State<AssignToAProjectView> {
  @override
  void initState() {
    super.initState();
    getAssignToAProject();
  }

  void getAssignToAProject() {
    context.read<AssignedProjectCubit>().fetchAssignedProject(
      widget.consultantProjectModel.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        backgroundColor: AppColor.blackColor,
        title: Text(
          AppLocalizations.of(context)!.assigned_projects,
          style: MyTextStyle().textStyleSemiBold16().copyWith(
            color: AppColor.whiteColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              SearchBoxWidget(
                hintText: AppLocalizations.of(context)!.search_by_title,
                fillColor: AppColor.whiteColor,
              ),
              SizedBox(height: 10.h),
              DashedLine(),
              SizedBox(height: 20.h),

              BlocBuilder<AssignedProjectCubit, AssignedProjectState>(
                builder: (context, state) {
                  // Loading Skeleton
                  if (state.loading == true) {
                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 5, // عدد الكروت الوهمية
                      itemBuilder: (context, index) {
                        return Skeletonizer(
                          enabled: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 24.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 0.6.sw,
                                  height: 18.h,
                                  color: Colors.grey.shade300,
                                ),
                                DashedLine(),
                                SizedBox(height: 10.h),
                                Container(
                                  width: 0.4.sw,
                                  height: 14.h,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  width: 0.5.sw,
                                  height: 14.h,
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    );
                  }

                  // Empty State
                  if (state.data?.isEmpty ?? true) {
                    return EmptyStateWidget(
                      title: AppLocalizations.of(context)!.no_projects_found,
                      icon: Icons.search_off,
                      subtitle: AppLocalizations.of(context)!
                          .no_assigned_projects_yet,
                    );
                  }

                  // Data Loaded
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final project = state.data![index];
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 24.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.projectTitle,
                              style: MyTextStyle().textStyleSemiBold16(),
                            ),
                            DashedLine(),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.role_in_project}: ',
                                  style: MyTextStyle().textStyleRegular14(),
                                ),
                                Text(
                                  project.roleInProject,
                                  style: MyTextStyle().textStyleMedium14(),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.duration}: ',
                                  style: MyTextStyle().textStyleRegular14(),
                                ),
                                Text(
                                  project.duration,
                                  style: MyTextStyle().textStyleMedium14(),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.budget}: ',
                                  style: MyTextStyle().textStyleRegular14(),
                                ),
                                Text(
                                  project.budget,
                                  style: MyTextStyle().textStyleMedium14(),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.status}: ',
                                  style: MyTextStyle().textStyleRegular14(),
                                ),
                                Text(
                                  project.statusLabel,
                                  style: MyTextStyle().textStyleMedium14(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
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
