import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/chat_cubit/chat_conversation_cubit.dart';
import 'package:hb/core/cubit/details_consultant_project_cubit/details_consultant_project_cubit.dart';
import 'package:hb/core/cubit/details_consultant_project_cubit/details_consultant_project_state.dart';
import 'package:hb/core/data/models/consultant_project_model.dart';
import 'package:hb/core/data/models/details_consultant_project_model.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/service_locator/usecases.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/featuer/chat_support/presentation/chat_message_view.dart';
import 'package:hb/featuer/consultant_project/presentation/assign_a_project_view.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/universal_downloader.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ViewConsultantProfile extends StatefulWidget {
  final ConsultantProjectModel consultantProjectModel;
  const ViewConsultantProfile({
    super.key,
    required this.consultantProjectModel,
  });

  @override
  State<ViewConsultantProfile> createState() => _ViewConsultantProfileState();
}

class _ViewConsultantProfileState extends State<ViewConsultantProfile> {
  @override
  void initState() {
    super.initState();
    context.read<DetailsConsultantProjectCubit>().fetchDetailsConsultantProject(
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
          AppLocalizations.of(context)!.consultant_profile,
          style: MyTextStyle().textStyleSemiBold20().copyWith(
            color: AppColor.whiteColor,
          ),
        ),
      ),
      bottomNavigationBar:
          BlocBuilder<
            DetailsConsultantProjectCubit,
            DetailsConsultantProjectState
          >(
            builder: (context, state) {
              return Skeletonizer(
                enabled: state.loading ?? false,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.gray1.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: CustomButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssignToAProjectView(
                            consultantProjectModel:
                                widget.consultantProjectModel,
                          ),
                        ),
                      );
                    },
                    color: AppColor.k1primeryColor,
                    text: AppLocalizations.of(context)!.view_assigned_projects,
                  ),
                ),
              );
            },
          ),
      body: BlocBuilder<DetailsConsultantProjectCubit, DetailsConsultantProjectState>(
        builder: (context, state) {
          final bool loading = state.loading ?? false;
          final data = state.data ?? DetailsConsultantProjectModel();

          return Skeletonizer(
            enabled: loading,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
                    // ── Card 1: معلومات الـ consultant ──
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            minTileHeight: 0,
                            minLeadingWidth: 0,
                            minVerticalPadding: 0,
                            leading: Container(
                              width: 60.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                color: AppColor.gray1,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 1,
                                  color: AppColor.borderColor,
                                ),
                              ),
                            ),
                            title: Text(
                              widget.consultantProjectModel.name,
                              style: MyTextStyle().textStyleSemiBold20(),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // ✅ Skills من الـ API بدل hardcoded
                          Wrap(
                            spacing: 8.w,
                            children: (data.skills ?? []).map((skill) {
                              return Chip(
                                label: Text(
                                  skill,
                                  style: MyTextStyle()
                                      .textStyleRegular14()
                                      .copyWith(color: AppColor.blackColor),
                                ),
                                side: BorderSide.none,
                                backgroundColor: AppColor.gray5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                              );
                            }).toList(),
                          ),

                          SizedBox(height: 24.h),
                          _infoRow(
                            AppLocalizations.of(context)!.role,
                            widget.consultantProjectModel.role,
                          ),
                          SizedBox(height: 20.h),
                          _infoRow(
                            AppLocalizations.of(context)!.rate_per_hour,
                            widget.consultantProjectModel.rate.toString(),
                          ),
                          SizedBox(height: 20.h),
                          _infoRow(
                            AppLocalizations.of(context)!.experience,

                            // ✅ من الـ model بدل hardcoded
                            data.consultant?.expertise ?? '',
                          ),
                          SizedBox(height: 20.h),
                          _infoRow(
                            AppLocalizations.of(context)!.location,
                            // ✅ من الـ model بدل hardcoded
                            data.consultant?.location ?? '',
                          ),
                          SizedBox(height: 20.h),
                          // ── Status كـ pill ملوّن ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.status,
                                style: MyTextStyle().textStyleRegular14(),
                              ),
                              _statusPill(widget.consultantProjectModel.status),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButtonBorder(
                                  onTap: () => _startChat(context),
                                  borderColor: AppColor.k1primeryColor,
                                  text: AppLocalizations.of(
                                    context,
                                  )!.start_chat,
                                ),
                              ),
                              // زر تحميل CV يظهر فقط عند توفّر رابط السيرة الذاتية
                              if ((data.consultant?.cvUrl ?? '')
                                  .isNotEmpty) ...[
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: CustomButtonBorder(
                                    onTap: () => _downloadCv(
                                      context,
                                      data.consultant!.cvUrl!,
                                    ),
                                    borderColor: AppColor.blackColor,
                                    text: AppLocalizations.of(
                                      context,
                                    )!.download_cv,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // ── Card 2: Overview + Projects + History ──
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.consultant_overview,
                            style: MyTextStyle().textStyleSemiBold20(),
                          ),
                          DashedLine(),
                          SizedBox(height: 20.h),

                          Text(
                            AppLocalizations.of(context)!.about,
                            style: MyTextStyle().textStyleRegular14(),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            data.about ?? '',
                            style: MyTextStyle().textStyleMedium15().copyWith(
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 24.h),

                          Text(
                            AppLocalizations.of(context)!.skill_tags,
                            style: MyTextStyle().textStyleRegular14(),
                          ),
                          SizedBox(height: 8.h),
                          // ✅ skills من data
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: (data.skills ?? []).map((item) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '• ',
                                      style: MyTextStyle().textStyleMedium15(),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: MyTextStyle()
                                            .textStyleMedium15()
                                            .copyWith(height: 1.5),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),

                          SizedBox(height: 24.h),

                          // ✅ assigned_projects — projects من DetailsConsultantProjectModel
                          if ((data.assignedProjects ?? []).isNotEmpty)
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.assignedProjects?.length ?? 0,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 10.h),
                              itemBuilder: (context, index) {
                                final project = data.assignedProjects![index];
                                return Container(
                                  padding: EdgeInsets.all(16.r),
                                  decoration: BoxDecoration(
                                    color: AppColor.gray5,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            project.title,
                                            style: MyTextStyle()
                                                .textStyleRegular14(),
                                          ),
                                          Text(
                                            project.duration,
                                            style: MyTextStyle()
                                                .textStyleRegular14(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            project.position,
                                            style: MyTextStyle()
                                                .textStyleSemiBold14(),
                                          ),
                                          _statusPill(project.status),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                          SizedBox(height: 20.h),

                          Text(
                            AppLocalizations.of(
                              context,
                            )!.history_with_this_company,
                            style: MyTextStyle().textStyleRegular14(),
                          ),
                          SizedBox(height: 8.h),

                          // ✅ history من ConsultantHistoryModel — totalBilled هو String مش double
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                [
                                  'First Assigned: ${data.history?.firstAssigned ?? 'N/A'}',
                                  'Total Projects: ${data.history?.totalProjects ?? 0}',
                                  'Total Billed: ${data.history?.totalBilled ?? '€0'}', // ✅ String مش double
                                ].map((item) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '• ',
                                          style: MyTextStyle()
                                              .textStyleMedium15(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            item,
                                            style: MyTextStyle()
                                                .textStyleMedium15()
                                                .copyWith(height: 1.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _startChat(BuildContext context) async {
    final name = widget.consultantProjectModel.name;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final conversation = await UseCases.chatRepository
          .createDirectConversation(
            recipientUserId: widget.consultantProjectModel.id,
          );
      if (!context.mounted) return;
      Navigator.pop(context); // close loading
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ChatConversationCubit(
              conversationId: conversation.id,
              title: conversation.title ?? 'Chat with $name',
            )..fetchMessages(),
            child: const ChatMessageView(),
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // close loading
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // تنزيل السيرة الذاتية (PDF محمي بالتوكن) ثم فتحها بعارض الجهاز
  // الرابط هو نفسه رابط التنزيل (/consultants/{id}/download-cv) القادم من الموديل
  Future<void> _downloadCv(BuildContext context, String url) async {
    if (url.isEmpty) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      // تنزيل + فتح بعارض الجهاز — الاسم يُقرأ من ترويسة الخادم تلقائياً
      final status = await UniversalDownloader().downloadAndOpen(url: url);
      if (!context.mounted) return;
      Navigator.pop(context); // إغلاق التحميل
      final loc = AppLocalizations.of(context)!;
      switch (status) {
        case DownloadOpenStatus.downloadFailed:
          showCustomSnackBar(context, loc.download_failed, SnackBarType.error);
          break;
        case DownloadOpenStatus.downloadedNotOpened:
          // نُزّل بنجاح لكن لا يوجد تطبيق لفتح الـ PDF
          showCustomSnackBar(
              context, loc.downloaded_no_viewer, SnackBarType.warning);
          break;
        case DownloadOpenStatus.opened:
          break; // فُتح بنجاح — لا حاجة لرسالة
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

  // لون الحالة حسب قيمتها
  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('active') ||
        s.contains('complete') ||
        s.contains('approv') ||
        s.contains('done')) {
      return const Color(0xff2E7D32);
    }
    if (s.contains('pending') || s.contains('review')) {
      return const Color(0xffE5A000);
    }
    if (s.contains('cancel') || s.contains('reject') || s.contains('closed')) {
      return AppColor.countNotificationBgColor;
    }
    return AppColor.gray2; // in progress / default
  }

  // pill ملوّن للحالة
  Widget _statusPill(String text) {
    final c = _statusColor(text);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Text(
        text,
        style: MyTextStyle().textStyleMedium14().copyWith(color: c),
      ),
    );
  }

  // ✅ Helper widget لتجنب التكرار
  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: MyTextStyle().textStyleRegular14()),
        Text(value, style: MyTextStyle().textStyleMedium16()),
      ],
    );
  }
}
