import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/core/cubit/details_my_application_cubit/details_my_application_cubit.dart';
import 'package:hb/core/cubit/details_my_application_cubit/details_my_application_state.dart';
import 'package:hb/core/data/models/details_my_application_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vector_graphics/vector_graphics.dart';

class DetailsMyApplicationView extends StatefulWidget {
  final int applicationId;
  const DetailsMyApplicationView({super.key, required this.applicationId});

  @override
  State<DetailsMyApplicationView> createState() => _DetailsMyApplicationViewState();
}

class _DetailsMyApplicationViewState extends State<DetailsMyApplicationView> {
  @override
  void initState() {
    super.initState();
    context.read<DetailsMyApplicationCubit>().fetchDetails(widget.applicationId);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocBuilder<DetailsMyApplicationCubit, DetailsMyApplicationState>(
      builder: (context, state) {
        final loading = state.loading;
        final data = state.data ?? DetailsMyApplicationModel();

        return Skeletonizer(
          enabled: loading,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.blackColor,
              iconTheme: const IconThemeData(color: AppColor.whiteColor),
              title: Text(
                loc.request_details,
                style: MyTextStyle()
                    .textStyleSemiBold20()
                    .copyWith(color: AppColor.whiteColor),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
                child: Column(
                  children: [
                    if ((data.recruiterContactNote ?? '').isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: AppColor.k1primeryColor.withValues(alpha: 0.15),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 39.w,
                            height: 42.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: AppColor.k1primeryColor.withValues(alpha: 0.10),
                            ),
                            child: Center(
                              child: VectorGraphic(
                                loader: AssetBytesLoader(AppSvg.notificationSvg),
                                colorFilter: ColorFilter.mode(
                                    AppColor.k1primeryColor, BlendMode.srcIn),
                              ),
                            ),
                          ),
                          title: Text(
                            data.recruiterContactNote ?? '',
                            style: MyTextStyle().textStyleRegular14().copyWith(
                                  color: AppColor.k1primeryColor,
                                ),
                          ),
                        ),
                      ),

                    SizedBox(height: 24.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: AppColor.whiteColor,
                      ),
                      child: Column(
                        children: [
                          InfoRow(label: loc.job_title, value: data.jobTitle ?? ''),
                          SizedBox(height: 20.h),
                          InfoRow(label: loc.company, value: data.companyName ?? ''),
                          SizedBox(height: 20.h),
                          InfoRow(
                              label: loc.type_label, value: data.jobTypeLabel ?? ''),
                          SizedBox(height: 20.h),
                          InfoRow(
                            label: loc.application_date,
                            value: data.applicationDateDisplay ?? '',
                          ),
                          SizedBox(height: 20.h),
                          InfoRow(label: loc.status, value: data.statusLabel ?? ''),
                          SizedBox(height: 20.h),
                          InfoRow(
                              label: loc.stipend_pay, value: data.stipendLabel ?? ''),
                          if ((data.deadlineDisplay ?? '').isNotEmpty) ...[
                            SizedBox(height: 20.h),
                            InfoRow(
                                label: loc.deadline,
                                value: data.deadlineDisplay ?? ''),
                          ],
                        ],
                      ),
                    ),

                    if ((data.coverLetter ?? '').isNotEmpty) ...[
                      SizedBox(height: 24.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: AppColor.whiteColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(loc.cover_letter_proposal,
                                style: MyTextStyle().textStyleSemiBold16()),
                            SizedBox(height: 12.h),
                            Text(data.coverLetter ?? '',
                                style: MyTextStyle().textStyleRegular14()),
                          ],
                        ),
                      ),
                    ],

                    if (data.cv != null) ...[
                      SizedBox(height: 24.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: AppColor.whiteColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.supporting_document,
                              style: MyTextStyle().textStyleSemiBold16(),
                            ),
                            SizedBox(height: 20.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 16.h),
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
                                      height: 42.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: AppColor.k1primeryColor
                                            .withValues(alpha: 0.10),
                                      ),
                                      child: Center(
                                        child: VectorGraphic(
                                            loader: AssetBytesLoader(AppSvg.fileSvg)),
                                      ),
                                    ),
                                    title: Text(
                                      data.cv?.fileName ?? '',
                                      style: MyTextStyle().textStyleRegular14(),
                                    ),
                                    subtitle: Text(
                                      data.cv?.typeLabel ?? '',
                                      style: MyTextStyle().textStyleRegular11(),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  CustomButtonBorder(
                                    onTap: () {},
                                    borderColor: AppColor.k1primeryColor,
                                    text: loc.download,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
