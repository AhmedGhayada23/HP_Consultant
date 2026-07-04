import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/chat_cubit/chat_conversation_cubit.dart';
import 'package:hb/core/cubit/details_consultant_meeting_request_cubit/details_consultant_meeting_request_cubit.dart';
import 'package:hb/core/cubit/details_consultant_meeting_request_cubit/details_consultant_meeting_request_state.dart';
import 'package:hb/core/data/models/consultant_meeting_request_modle.dart';
import 'package:hb/core/data/models/details_consultant_meeting_request_model.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/service_locator/usecases.dart';
import 'package:hb/featuer/chat_support/presentation/chat_message_view.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_popup_widget.dart';
import 'package:hb/featuer/file_web_view/file_web_view.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ConsultantMeetingRequestsDetails extends StatefulWidget {
  final ConsultantMeetingRequestModel consultantMeetingRequestModel;
  const ConsultantMeetingRequestsDetails({super.key, required this.consultantMeetingRequestModel});

  @override
  State<ConsultantMeetingRequestsDetails> createState() => _ConsultantMeetingRequestsDetailsState();
}

class _ConsultantMeetingRequestsDetailsState extends State<ConsultantMeetingRequestsDetails> {
  @override
  void initState() {
    super.initState();
    context.read<DetailsConsultantMeetingRequestCubit>().fetchDetailsConsultantMeetingRequest(
      widget.consultantMeetingRequestModel.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsConsultantMeetingRequestCubit, DetailsConsultantMeetingRequestState>(
      builder: (context, state) {
        final bool loading = state.loading ?? false;
        final data = loading
            ? DetailsConsultantMeetingRequestModel.fake()
            : (state.data ?? DetailsConsultantMeetingRequestModel.fake());

        return Skeletonizer(
          enabled: loading,
          child: Scaffold(
            appBar: _buildAppBar(context, data, widget.consultantMeetingRequestModel.id),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
              child: _ProjectInfoCard(data: data),
            ),
          ),
        );
      },
    );
  }
}

//========================= AppBar =========================//
AppBar _buildAppBar(BuildContext context, DetailsConsultantMeetingRequestModel data, int id) {
  // يظهر خيار الدردشة مع المستشار فقط عند وجود مستشار معيّن
  final bool hasConsultant =
      data.assignedConsultant != null &&
      data.assignedConsultant!.trim().isNotEmpty &&
      data.assignedConsultant!.trim() != '-';

  return AppBar(
    backgroundColor: AppColor.blackColor,
    iconTheme: IconThemeData(color: AppColor.whiteColor),
    title: Text(
      data.title,
      style: MyTextStyle().textStyleSemiBold16().copyWith(color: AppColor.whiteColor),
    ),
    actions: [
      CustomPopupWidget(
        items: [
          PopupMenuItemModel(
            text: AppLocalizations.of(context)!.start_chat_with_admin,
            onTap: () => _startChatWithAdmin(context, data, id),
          ),
          if (hasConsultant)
            PopupMenuItemModel(
              text: AppLocalizations.of(context)!.start_chat_with_consultant,
              onTap: () {},
            ),
          PopupMenuItemModel(
            text: AppLocalizations.of(context)!.cancel_request,
            color: AppColor.countNotificationBgColor,
            onTap: () {
              context.read<DetailsConsultantMeetingRequestCubit>().cancelMeetingRequest(
                context,
                id,
              );
            },
          ),
        ],
        child: Container(
          height: 28.h,
          width: 28.w,
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Center(
            child: Icon(Icons.more_vert, color: AppColor.blackColor, size: 24.r),
          ),
        ),
      ),
      SizedBox(width: 16.w),
    ],
  );
}

// إنشاء محادثة دعم مع الإدارة وفتح شاشة الرسائل
Future<void> _startChatWithAdmin(
  BuildContext context,
  DetailsConsultantMeetingRequestModel data,
  int id,
) async {
  // مؤشر تحميل
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
  try {
    final conversation = await UseCases.chatRepository.createTicket(
      title: data.title.isNotEmpty ? data.title : 'Request ${data.reqId}',
      message: data.description.isNotEmpty ? data.description : data.title,
      priority: 'normal',
    );
    if (!context.mounted) return;
    Navigator.pop(context); // إغلاق مؤشر التحميل

    final title = conversation.displayName.isNotEmpty
        ? conversation.displayName
        : AppLocalizations.of(context)!.start_chat_with_admin;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ChatConversationCubit(
            conversationId: conversation.id,
            title: title,
          )..fetchMessages(),
          child: const ChatMessageView(),
        ),
      ),
    );
  } catch (e) {
    if (!context.mounted) return;
    Navigator.pop(context); // إغلاق مؤشر التحميل
    showCustomSnackBar(
      context,
      e.toString().replaceAll('Exception:', '').trim(),
      SnackBarType.error,
    );
  }
}

//========================= Project Info Card =========================//
class _ProjectInfoCard extends StatelessWidget {
  final DetailsConsultantMeetingRequestModel data;

  const _ProjectInfoCard({required this.data});

  // فتح المستند للعرض/المشاهدة داخل عارض الملفات (بدل التحميل)
  void _viewDocument(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FileWebViewPage(
          fileName: data.document!.split('/').last,
          fileUrl: data.document!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColor.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(AppLocalizations.of(context)!.request_id, data.reqId),
          _infoRow(AppLocalizations.of(context)!.title, data.title),
          _infoRow(AppLocalizations.of(context)!.status, data.statusLabel),
          _infoRow(AppLocalizations.of(context)!.category, data.category),
          _infoRow(AppLocalizations.of(context)!.urgency, data.urgency),
          _infoRow(AppLocalizations.of(context)!.budget, data.budget),
          _infoRow(
            AppLocalizations.of(context)!.assign_consultant,
            data.assignedConsultant ?? '-',
          ),
          _infoRow(
            AppLocalizations.of(context)!.meeting_details,
            data.meetingDetails ?? '-',
          ),

          SizedBox(height: 20.h),
          Text(
            AppLocalizations.of(context)!.consultant_role,
            style: MyTextStyle().textStyleRegular14(),
          ),
          SizedBox(height: 8.h),
          Text(data.role, style: MyTextStyle().textStyleMedium16()),

          SizedBox(height: 20.h),
          Text(
            AppLocalizations.of(context)!.supporting_document,
            style: MyTextStyle().textStyleRegular14(),
          ),
          SizedBox(height: 8.h),

          if (data.document != null)
            GestureDetector(
              onTap: () => _viewDocument(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      data.document!.split('/').last,
                      style: MyTextStyle().textStyleMedium16().copyWith(
                        color: AppColor.k1primeryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColor.k1primeryColor,
                        decorationThickness: 1.5,
                      ),
                    ),
                  ),
                  Icon(Icons.visibility_outlined,
                      color: AppColor.k1primeryColor, size: 22.r),
                ],
              ),
            )
          else
            Text('-', style: MyTextStyle().textStyleMedium16()),

          SizedBox(height: 20.h),
          Text(
            AppLocalizations.of(context)!.description,
            style: MyTextStyle().textStyleRegular14(),
          ),
          SizedBox(height: 8.h),
          Text(data.description, style: MyTextStyle().textStyleMedium16()),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: MyTextStyle().textStyleRegular14()),
          Text(value, style: MyTextStyle().textStyleMedium16()),
        ],
      ),
    );
  }
}
