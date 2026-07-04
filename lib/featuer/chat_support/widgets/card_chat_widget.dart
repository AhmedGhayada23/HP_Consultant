import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/chat_cubit/chat_conversation_cubit.dart';
import 'package:hb/core/cubit/chat_cubit/chat_cubit.dart';
import 'package:hb/core/data/models/chat_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/featuer/chat_support/presentation/chat_message_view.dart';

class CardChatWidget extends StatelessWidget {
  final ChatModel? chatModel;
  const CardChatWidget({super.key, this.chatModel});

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec',
  ];

  // التنسيق المطابق للتصميم: 21 Sept 25
  String _formatTime(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final year = (dt.year % 100).toString().padLeft(2, '0');
      return "${dt.day} ${_months[dt.month - 1]} $year";
    } catch (_) {
      return raw;
    }
  }

  // لون النقطة: أحمر للرسائل غير المقروءة، وإلا حسب حالة المحادثة
  Color _dotColor() {
    if ((chatModel?.unreadCount ?? 0) > 0) return AppColor.countNotificationBgColor;
    return chatModel?.status == 'open'
        ? const Color(0xffE5C511)
        : AppColor.gray4;
  }

  @override
  Widget build(BuildContext context) {
    final bool isUnread = (chatModel?.unreadCount ?? 0) > 0;
    return InkWell(
      onTap: () async {
        if (chatModel == null) return;
        final chatCubit = context.read<ChatCubit>();
        // تصفير العدّاد فوراً (فتح المحادثة يعلّمها مقروءة بالسيرفر)
        chatCubit.markConversationRead(chatModel!.id);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => ChatConversationCubit(
                conversationId: chatModel!.id,
                title: chatModel!.displayName,
              )..fetchMessages(),
              child: const ChatMessageView(),
            ),
          ),
        );
        // مزامنة مع السيرفر بعد الرجوع
        chatCubit.syncList();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: BoxDecoration(
                    color: _dotColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    chatModel?.displayName ?? '',
                    style: MyTextStyle().textStyleSemiBold14(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // شارة عدد الرسائل غير المقروءة
                if ((chatModel?.unreadCount ?? 0) > 0) ...[
                  SizedBox(width: 8.w),
                  Container(
                    constraints: BoxConstraints(minWidth: 20.r),
                    height: 20.r,
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    decoration: BoxDecoration(
                      color: AppColor.k1primeryColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(
                      child: Text(
                        '${chatModel!.unreadCount}',
                        style: MyTextStyle()
                            .textStyleMedium12()
                            .copyWith(color: AppColor.whiteColor),
                      ),
                    ),
                  ),
                ],
                SizedBox(width: 8.w),
                Text(
                  _formatTime(chatModel?.time),
                  style: MyTextStyle()
                      .textStyleRegular11()
                      .copyWith(color: AppColor.gray4),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              chatModel?.message ?? '',
              // غير المقروء: نص أغمق وأبرز؛ المقروء: رمادي
              style: isUnread
                  ? MyTextStyle()
                      .textStyleSemiBold14()
                      .copyWith(color: AppColor.blackColor)
                  : MyTextStyle()
                      .textStyleRegular14()
                      .copyWith(color: AppColor.gray2),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
