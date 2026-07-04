import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/message_cubit/message_conversation_cubit.dart';
import 'package:hb/core/cubit/message_cubit/message_cubit.dart';
import 'package:hb/core/data/models/message_conversation_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/featuer/message/presentation/message_chat_view.dart';

class CardMessageWidget extends StatelessWidget {
  final MessageConversationModel? conversationModel;
  const CardMessageWidget({super.key, this.conversationModel});

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
    if ((conversationModel?.unreadCount ?? 0) > 0) return AppColor.countNotificationBgColor;
    return conversationModel?.status == 'open'
        ? const Color(0xffE5C511)
        : AppColor.gray4;
  }

  @override
  Widget build(BuildContext context) {
    final bool isUnread = (conversationModel?.unreadCount ?? 0) > 0;
    return InkWell(
      onTap: () async {
        if (conversationModel == null) return;
        final messageCubit = context.read<MessageCubit>();
        // تصفير العدّاد فوراً (فتح المحادثة يعلّمها مقروءة بالسيرفر)
        messageCubit.markConversationRead(conversationModel!.id);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => MessageConversationCubit(
                conversationId: conversationModel!.id,
                title: conversationModel!.displayName,
              )..fetchMessages(),
              child: const MessageChatView(),
            ),
          ),
        );
        // مزامنة مع السيرفر بعد الرجوع
        messageCubit.syncList();
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
                    conversationModel?.displayName ?? '',
                    style: MyTextStyle().textStyleSemiBold14(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // شارة عدد الرسائل غير المقروءة
                if ((conversationModel?.unreadCount ?? 0) > 0) ...[
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
                        '${conversationModel!.unreadCount}',
                        style: MyTextStyle()
                            .textStyleMedium12()
                            .copyWith(color: AppColor.whiteColor),
                      ),
                    ),
                  ),
                ],
                SizedBox(width: 8.w),
                Text(
                  _formatTime(conversationModel?.time),
                  style: MyTextStyle()
                      .textStyleRegular11()
                      .copyWith(color: AppColor.gray4),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              conversationModel?.message ?? '',
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
