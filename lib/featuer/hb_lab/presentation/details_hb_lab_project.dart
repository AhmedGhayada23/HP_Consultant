import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/details_hb_lab_project_cubit/details_hb_lab_project_consultant_cubit.dart';
import 'package:hb/core/cubit/details_hb_lab_project_cubit/details_hb_lab_project_state.dart';
import 'package:hb/core/data/models/details_hb_lab_project_model.dart';
import 'package:hb/core/data/models/hb_lab_project_model.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:hb/utils/universal_downloader.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vector_graphics/vector_graphics.dart';

class DetailsHbLabProject extends StatefulWidget {
  final HbLabProjectModel hbLabProjectModel;
  const DetailsHbLabProject({super.key, required this.hbLabProjectModel});

  @override
  State<DetailsHbLabProject> createState() => _DetailsHbLabProjectState();
}

class _DetailsHbLabProjectState extends State<DetailsHbLabProject> {
  @override
  void initState() {
    super.initState();
    context.read<DetailsHbLabProjectConsultantCubit>().fetchDetailsHbLabProject(
      widget.hbLabProjectModel.id ?? 0,
    );
  }

  // تنزيل ملف المشروع (محمي بالتوكن) ثم فتحه بعارض الجهاز — بناءً على download_url
  Future<void> _downloadFile(BuildContext context, String url) async {
    if (url.isEmpty) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      // تنزيل + فتح — الاسم يُقرأ من ترويسة الخادم تلقائياً
      final status = await UniversalDownloader().downloadAndOpen(url: url);
      if (!context.mounted) return;
      Navigator.pop(context); // إغلاق مؤشّر التحميل
      final loc = AppLocalizations.of(context)!;
      switch (status) {
        case DownloadOpenStatus.downloadFailed:
          showCustomSnackBar(context, loc.download_failed, SnackBarType.error);
          break;
        case DownloadOpenStatus.downloadedNotOpened:
          showCustomSnackBar(
              context, loc.downloaded_no_viewer, SnackBarType.warning);
          break;
        case DownloadOpenStatus.opened:
          break; // فُتح بنجاح
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      showCustomSnackBar(
        context,
        e.toString().replaceFirst('Exception: ', ''),
        SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsHbLabProjectConsultantCubit, DetailsHbLabProjectState>(
      builder: (context, state) {
        final loc = AppLocalizations.of(context)!;
        if (state.errorMessage != null && !state.loading) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.blackColor,
              iconTheme: IconThemeData(color: AppColor.whiteColor),
              title: Text(
                widget.hbLabProjectModel.title ?? '',
                style: MyTextStyle().textStyleSemiBold20().copyWith(
                  color: AppColor.whiteColor,
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(16.w),
              child: EmptyStateWidget(
                title: 'Failed to load project details',
                subtitle: state.errorMessage,
                icon: Icons.error_outline,
                actionButtonText: loc.retry,
                onActionPressed: () => context
                    .read<DetailsHbLabProjectConsultantCubit>()
                    .fetchDetailsHbLabProject(widget.hbLabProjectModel.id ?? 0),
              ),
            ),
          );
        }

        final isLoading = state.loading;
        final data = state.data ?? DetailsHbLabProjectModel.fake();

        return Skeletonizer(
          enabled: isLoading,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.blackColor,
              iconTheme: IconThemeData(color: AppColor.whiteColor),
              title: Text(
                data.title ?? widget.hbLabProjectModel.title ?? '',
                style: MyTextStyle().textStyleSemiBold20().copyWith(
                  color: AppColor.whiteColor,
                ),
              ),
            ),
            bottomNavigationBar: Container(
              height: 100.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: CustomButton(
                onTap: () => showRequestToJoinProjectDialog(
                  context,
                  projectId: data.id ?? widget.hbLabProjectModel.id ?? 0,
                  consultant: true,
                ),
                color: AppColor.k1primeryColor,
                text: loc.assign_to_project,
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Project info ──
                    InfoRow(label: 'Project ID', value: data.publicCode ?? ''),
                    SizedBox(height: 12.h),
                    InfoRow(label: loc.title, value: data.title ?? ''),
                    SizedBox(height: 12.h),
                    InfoRow(label: loc.category, value: data.category ?? ''),
                    SizedBox(height: 12.h),
                    InfoRow(
                      label: loc.deadline,
                      value: data.deadlineDisplay ?? '',
                    ),
                    SizedBox(height: 12.h),
                    InfoRow(label: loc.status, value: data.statusLabel ?? ''),
                    SizedBox(height: 12.h),
                    InfoRow(label: loc.budget, value: data.budgetDisplay ?? ''),
                    SizedBox(height: 16.h),

                    // ── Description ──
                    Text(
                      loc.description,
                      style: MyTextStyle().textStyleSemiBold16(),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      data.description ?? '',
                      style: MyTextStyle().textStyleRegular14(),
                    ),

                    // ── Goals & Deliverables ──
                    if (data.goalsDeliverables != null &&
                        data.goalsDeliverables!.isNotEmpty) ...[
                      DashedLine(),
                      SizedBox(height: 16.h),
                      Text(
                        'Goals & Deliverables',
                        style: MyTextStyle().textStyleSemiBold16(),
                      ),
                      SizedBox(height: 8.h),
                      ...data.goalsDeliverables!.map(
                        (goal) => Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• ',
                                style: MyTextStyle()
                                    .textStyleRegular14()
                                    .copyWith(color: AppColor.k1primeryColor),
                              ),
                              Expanded(
                                child: Text(
                                  goal,
                                  style: MyTextStyle().textStyleRegular14(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // ── Milestones ──
                    if (data.milestones != null &&
                        data.milestones!.isNotEmpty) ...[
                      DashedLine(),
                      SizedBox(height: 16.h),
                      Text(
                        'Milestones & Tasks',
                        style: MyTextStyle().textStyleSemiBold16(),
                      ),
                      SizedBox(height: 12.h),
                      ...data.milestones!.map(
                        (m) => Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.gray1,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m.title ?? '',
                                  style: MyTextStyle().textStyleSemiBold16(),
                                ),
                                SizedBox(height: 12.h),
                                InfoRow(
                                  label: '${loc.deadline}: ',
                                  value: m.dueDateDisplay ?? '',
                                ),
                                SizedBox(height: 8.h),
                                InfoRow(
                                  label: '${loc.status}: ',
                                  value: m.statusLabel ?? '',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],

                    // ── Files ──
                    if (data.files != null && data.files!.isNotEmpty) ...[
                      DashedLine(),
                      SizedBox(height: 16.h),
                      Text(
                        'Project Files',
                        style: MyTextStyle().textStyleSemiBold16(),
                      ),
                      SizedBox(height: 12.h),
                      ...data.files!.map(
                        (f) => Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: AppColor.gray1,
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
                                      color: AppColor.k1primeryColor.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
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
                                    f.fileName ?? '',
                                    style: MyTextStyle().textStyleRegular14(),
                                  ),
                                  subtitle: Text(
                                    f.uploaderDisplay ?? f.typeLabel ?? '',
                                    style: MyTextStyle().textStyleRegular11(),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                CustomButtonBorder(
                                  onTap: () => _downloadFile(
                                    context,
                                    f.downloadUrl ?? f.url ?? '',
                                  ),
                                  borderColor: AppColor.k1primeryColor,
                                  text: loc.download,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],

                    // ── Team ──
                    if (data.team != null && data.team!.isNotEmpty) ...[
                      DashedLine(),
                      SizedBox(height: 16.h),
                      Text(
                        'Project Team',
                        style: MyTextStyle().textStyleSemiBold16(),
                      ),
                      SizedBox(height: 12.h),
                      ...data.team!.map(
                        (member) => Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: AppColor.gray1,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: ListTile(
                              minLeadingWidth: 0,
                              minTileHeight: 0,
                              minVerticalPadding: 0,
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                radius: 20.r,
                                backgroundColor: AppColor.gray5,
                                child: Text(
                                  (member.name ?? 'U')
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: MyTextStyle()
                                      .textStyleSemiBold16()
                                      .copyWith(color: AppColor.whiteColor),
                                ),
                              ),
                              title: Text(
                                member.name ?? '',
                                style: MyTextStyle().textStyleRegular14(),
                              ),
                              subtitle: Text(
                                member.roleLabel ?? '',
                                style: MyTextStyle().textStyleRegular11(),
                              ),
                              trailing: member.isYou == true
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColor.k1primeryColor
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                      ),
                                      child: Text(
                                        'You',
                                        style: MyTextStyle()
                                            .textStyleRegular11()
                                            .copyWith(
                                              color: AppColor.k1primeryColor,
                                            ),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
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
