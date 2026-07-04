import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/chat_cubit/chat_conversation_cubit.dart';
import 'package:hb/core/cubit/chat_cubit/chat_conversation_state.dart';
import 'package:hb/core/data/models/chat_message_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/featuer/chat_support/widgets/chat_input_bar_widget.dart';
import 'package:hb/featuer/chat_support/widgets/chat_message_bubble.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatMessageView extends StatefulWidget {
  const ChatMessageView({super.key});

  @override
  State<ChatMessageView> createState() => _ChatMessageViewState();
}

class _ChatMessageViewState extends State<ChatMessageView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onSend(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    context.read<ChatConversationCubit>().sendMessage(text);
  }

  // اختيار صورة/ملف ثم عرض شاشة معاينة قبل الإرسال (بدون صوت)
  Future<void> _onAttach(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );
    if (result == null || result.files.isEmpty) return;
    if (!context.mounted) return;
    _showAttachmentPreview(context, result.files);
  }

  bool _isImage(PlatformFile f) =>
      const ['jpg', 'jpeg', 'png', 'gif', 'webp']
          .contains((f.extension ?? '').toLowerCase());

  // شاشة معاينة المرفقات مع تأكيد الإرسال
  void _showAttachmentPreview(BuildContext context, List<PlatformFile> files) {
    final cubit = context.read<ChatConversationCubit>();
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: files.map((f) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _isImage(f) && f.path != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Image.file(
                                    File(f.path!),
                                    width: double.infinity,
                                    height: 220.h,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.all(14.r),
                                  decoration: BoxDecoration(
                                    color: AppColor.gray5,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.insert_drive_file_outlined,
                                          color: AppColor.k1primeryColor,
                                          size: 32.r),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Text(
                                          f.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              MyTextStyle().textStyleRegular14(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomButtonBorder(
                        onTap: () => Navigator.pop(dialogContext),
                        borderColor: AppColor.k1primeryColor,
                        text: loc.cancel,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          Navigator.pop(dialogContext);
                          // مرفق واحد لكل رسالة
                          for (final f in files) {
                            cubit.sendMessage('', files: [f]);
                          }
                        },
                        color: AppColor.k1primeryColor,
                        text: loc.submit,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.gray5,
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: const IconThemeData(color: AppColor.whiteColor),
        title: BlocBuilder<ChatConversationCubit, ChatConversationState>(
          buildWhen: (prev, curr) => prev.conversationTitle != curr.conversationTitle,
          builder: (context, state) => Text(
            state.conversationTitle,
            style: MyTextStyle().textStyleMedium16().copyWith(color: AppColor.whiteColor),
          ),
        ),
      ),
      body: BlocConsumer<ChatConversationCubit, ChatConversationState>(
        listener: (context, state) {
          if (!state.isLoading && !state.isSending) _scrollToBottom();
        },
        builder: (context, state) {
          final isLoading = state.isLoading;

          if (!isLoading && state.messages.isEmpty) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.no_messages_yet),
                  ),
                ),
                ChatInputBarWidget(
                  controller: _controller,
                  isSending: state.isSending,
                  onSend: () => _onSend(context),
                  onAttach: () => _onAttach(context),
                ),
              ],
            );
          }

          final messages = isLoading
              ? List.generate(
                  7,
                  (i) => ChatMessageModel(
                    body: 'Loading message placeholder text',
                    isMine: i.isEven,
                  ),
                )
              : state.messages;

          return Column(
            children: [
              Expanded(
                child: Skeletonizer(
                  enabled: isLoading,
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[messages.length - 1 - index];
                      return ChatMessageBubble(message: msg);
                    },
                  ),
                ),
              ),
              ChatInputBarWidget(
                controller: _controller,
                isSending: state.isSending,
                onSend: () => _onSend(context),
                onAttach: () => _onAttach(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
