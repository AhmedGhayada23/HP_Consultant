import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hb/core/cubit/chat_cubit/chat_conversation_cubit.dart';
import 'package:hb/core/data/models/job_application_model.dart';
import 'package:hb/core/service_locator/usecases.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/featuer/chat_support/presentation/chat_message_view.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:vector_graphics/vector_graphics.dart';

// تأكد أنك تستورد AppColor، MyTextStyle، AppSvg، وCustomButtonBorder

class JobApplicantCardWidget extends StatelessWidget {
  final JobApplicationModel jobApplicationModel;
  const JobApplicantCardWidget({super.key, required this.jobApplicationModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.gray1.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            minVerticalPadding: 0,
            minTileHeight: 0,
            minLeadingWidth: 0,
            leading: Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColor.gray1,
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.borderColor, width: 1.w),
              ),
            ),
            title: Text(
              jobApplicationModel.name,
              style: MyTextStyle().textStyleSemiBold20(),
            ),
            trailing: GestureDetector(
              onTap: () => _startChat(context),
              child: Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: AppColor.gray5,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Center(
                  child: VectorGraphic(loader: AssetBytesLoader(AppSvg.chatSvg)),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            children: [
              _buildSkillChip('Vue'),
              _buildSkillChip('Tailwind'),
              _buildSkillChip('React'),
            ],
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(
            AppLocalizations.of(context)!.role,
            jobApplicationModel.profssion,
          ),
          SizedBox(height: 20.h),
          _buildInfoRow(
            AppLocalizations.of(context)!.rate_per_hour,
            jobApplicationModel.rate,
          ),
          SizedBox(height: 20.h),
          _buildInfoRow(
            AppLocalizations.of(context)!.experience,
            jobApplicationModel.experience,
          ),
          SizedBox(height: 20.h),
          _buildInfoRow(
            AppLocalizations.of(context)!.location,
            'Berlin, Germany',
          ),
          SizedBox(height: 20.h),
          _buildInfoRow(
            AppLocalizations.of(context)!.applied_date,
            'Sept 13, 2025',
          ),
          SizedBox(height: 20.h),
          _buildInfoRow(
            AppLocalizations.of(context)!.status,
            jobApplicationModel.status,
          ),
          SizedBox(height: 25.h),
          CustomButtonBorder(
            onTap: () {
              // download CV logic here
            },
            borderColor: AppColor.blackColor,
            text: AppLocalizations.of(context)!.download_cv,
          ),
        ],
      ),
    );
  }

  Future<void> _startChat(BuildContext context) async {
    final name = jobApplicationModel.name;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final conversation = await UseCases.chatRepository.createDirectConversation(
        recipientUserId: jobApplicationModel.id,
      );
      if (!context.mounted) return;
      Navigator.pop(context); // close loading
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
      Navigator.pop(context); // close loading
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget _buildSkillChip(String skill) {
    return Chip(
      label: Text(
        skill,
        style: MyTextStyle().textStyleRegular14().copyWith(
          color: AppColor.blackColor,
        ),
      ),
      backgroundColor: AppColor.gray5,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: MyTextStyle().textStyleRegular14()),
        Text(value, style: MyTextStyle().textStyleMedium16()),
      ],
    );
  }
}
