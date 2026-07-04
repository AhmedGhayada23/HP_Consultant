import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/chat_cubit/chat_conversation_cubit.dart';
import 'package:hb/core/cubit/consultant_profile_cubit/consultant_profile_cubit.dart';
import 'package:hb/core/cubit/consultant_profile_cubit/consultant_profile_state.dart';
import 'package:hb/core/data/models/consultant_profile_details_model.dart';
import 'package:hb/core/service_locator/usecases.dart';
import 'package:hb/featuer/chat_support/presentation/chat_message_view.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/featuer/counsultants_directory/presentation/request_consultant_view.dart';
import 'package:hb/utils/universal_downloader.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vector_graphics/vector_graphics.dart';

class ConsultantDirectoryProfileView extends StatefulWidget {
  const ConsultantDirectoryProfileView({super.key});

  @override
  State<ConsultantDirectoryProfileView> createState() =>
      _ConsultantDirectoryProfileViewState();
}

class _ConsultantDirectoryProfileViewState
    extends State<ConsultantDirectoryProfileView> {
  @override
  void initState() {
    super.initState();
    context.read<ConsultantProfileCubit>().fetchProfile();
  }

  // فتح محادثة مباشرة مع المستشار
  Future<void> _startChat(
    BuildContext context, {
    required int recipientUserId,
    required String name,
  }) async {
    if (recipientUserId == 0) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final conversation = await UseCases.chatRepository.createDirectConversation(
        recipientUserId: recipientUserId,
      );
      if (!context.mounted) return;
      Navigator.pop(context); // إغلاق التحميل
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ChatConversationCubit(
              conversationId: conversation.id,
              title: conversation.title ?? name,
            )..fetchMessages(),
            child: const ChatMessageView(),
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // تحميل السيرة الذاتية للمستشار
  Future<void> _downloadCv(BuildContext context) async {
    final id = context.read<ConsultantProfileCubit>().consultantId;
    if (id == 0) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final url = await UseCases.getConsultantCvUsecase(id);
      final ok = await UniversalDownloader()
          .downloadFile(url: url, saveToGallery: false);
      if (!context.mounted) return;
      Navigator.pop(context); // إغلاق التحميل
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok ? loc.cv_downloaded_successfully : loc.download_failed,
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        backgroundColor: AppColor.blackColor,
        title: Text(
          loc.consultant_profile,
          style: MyTextStyle().textStyleSemiBold20().copyWith(
                color: AppColor.whiteColor,
              ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          boxShadow: [
            BoxShadow(offset: Offset(0, -3), color: AppColor.borderColor),
          ],
        ),
        child: CustomButton(
          onTap: () {
            // قراءة الـ id من السياق الحالي (تحت الـ provider) قبل التنقّل
            final consultantId =
                context.read<ConsultantProfileCubit>().consultantId;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    RequestConsultantView(consultantId: consultantId),
              ),
            );
          },
          color: AppColor.k1primeryColor,
          text: loc.request_consultant,
        ),
      ),
      body: BlocBuilder<ConsultantProfileCubit, ConsultantProfileState>(
        builder: (context, state) {
          final loading = state.loading;
          final c = state.data ??
              ConsultantProfileDetailsModel(
                name: 'Consultant name',
                role: 'Role',
                availabilityStatus: 'Available',
                summaryHourlyRate: '€00/hr',
                experienceYearsSummary: '0 Years',
                aboutText: 'About text placeholder for the consultant profile.',
                skills: const ['Skill', 'Skill', 'Skill'],
              );
          return Skeletonizer(
            enabled: loading,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
              child: Column(
                children: [
                  _headerCard(c),
                  SizedBox(height: 24.h),
                  _detailsCard(c),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _headerCard(ConsultantProfileDetailsModel c) {
    final loc = AppLocalizations.of(context)!;
    final hasImage = (c.profileImageUrl ?? '').isNotEmpty;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            minLeadingWidth: 0,
            minTileHeight: 0,
            minVerticalPadding: 0,
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 32.r,
              backgroundColor: AppColor.gray5,
              foregroundImage:
                  hasImage ? NetworkImage(c.profileImageUrl!) : null,
              onForegroundImageError: hasImage ? (_, __) {} : null,
              child: Icon(Icons.person, color: AppColor.gray4, size: 28.r),
            ),
            title: Text(c.name, style: MyTextStyle().textStyleSemiBold16()),
            subtitle: Text(c.role, style: MyTextStyle().textStyleRegular14()),
            trailing: InkWell(
              onTap: () => _startChat(
                context,
                recipientUserId: c.id,
                name: c.name,
              ),
              child: Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: AppColor.gray5,
                ),
                child: Center(
                  child:
                      VectorGraphic(loader: AssetBytesLoader(AppSvg.chatSvg)),
                ),
              ),
            ),
          ),
          if (c.skills.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Wrap(
              spacing: 8.r,
              runSpacing: 8.r,
              children: c.skills
                  .map((skill) => Chip(
                        backgroundColor: AppColor.gray5,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        label: Text(skill,
                            style: MyTextStyle().textStyleRegular14()),
                      ))
                  .toList(),
            ),
          ],
          DashedLine(),
          SizedBox(height: 20.h),
          InfoRow(
            label: loc.availability,
            value: c.availabilityStatus,
            valueColor: c.availabilityStatus.toLowerCase().contains('avail')
                ? const Color(0xff2E7D32)
                : null,
          ),
          SizedBox(height: 12.h),
          InfoRow(label: loc.role, value: c.role),
          SizedBox(height: 12.h),
          InfoRow(label: loc.rate_hr, value: c.summaryHourlyRate),
          SizedBox(height: 12.h),
          InfoRow(label: loc.experience, value: c.experienceYearsSummary),
          if ((c.location ?? '').isNotEmpty) ...[
            SizedBox(height: 12.h),
            InfoRow(label: loc.location, value: c.location!),
          ],
          SizedBox(height: 20.h),
          CustomButtonBorder(
            onTap: () => _downloadCv(context),
            borderColor: AppColor.blackColor,
            text: loc.download_cv,
          ),
        ],
      ),
    );
  }

  Widget _detailsCard(ConsultantProfileDetailsModel c) {
    final loc = AppLocalizations.of(context)!;
    final rate = c.rateAndServices;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (c.aboutText.isNotEmpty) ...[
            Text(loc.about, style: MyTextStyle().textStyleSemiBold16()),
            SizedBox(height: 8.h),
            Text(c.aboutText, style: MyTextStyle().textStyleMedium15()),
            DashedLine(),
            SizedBox(height: 12.h),
          ],
          if (c.skills.isNotEmpty) ...[
            Text(loc.skills_expertise,
                style: MyTextStyle().textStyleSemiBold16()),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.r,
              runSpacing: 8.r,
              children: c.skills
                  .map((skill) => Chip(
                        backgroundColor: AppColor.gray5,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        label: Text(skill,
                            style: MyTextStyle().textStyleRegular14()),
                      ))
                  .toList(),
            ),
            DashedLine(),
            SizedBox(height: 12.h),
          ],
          if (c.experienceTimeline.isNotEmpty) ...[
            Text(loc.experience_timeline,
                style: MyTextStyle().textStyleSemiBold16()),
            SizedBox(height: 8.h),
            Text(c.experienceTimeline.join('\n'),
                style: MyTextStyle().textStyleMedium15()),
            SizedBox(height: 16.h),
          ],
          if (c.certifications.isNotEmpty) ...[
            Text(loc.certifications, style: MyTextStyle().textStyleSemiBold16()),
            SizedBox(height: 8.h),
            Text(c.certifications.join('\n'),
                style: MyTextStyle().textStyleMedium15()),
            SizedBox(height: 16.h),
          ],
          if (rate != null) ...[
            Text(loc.rate_services,
                style: MyTextStyle().textStyleSemiBold16()),
            SizedBox(height: 8.h),
            if (rate.hourlyRate.isNotEmpty)
              InfoRow(label: '${loc.hourly_rate}: ', value: rate.hourlyRate),
            SizedBox(height: 8.h),
            if (rate.projectRateStart.isNotEmpty)
              InfoRow(label: '${loc.project_rate}: ', value: rate.projectRateStart),
            SizedBox(height: 8.h),
            if (rate.paymentTerms.isNotEmpty)
              InfoRow(label: '${loc.payment_terms}: ', value: rate.paymentTerms),
          ],
        ],
      ),
    );
  }
}
