import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/data/models/message_item_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/universal_downloader.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// فقاعة رسالة: اسم المُرسِل بالأعلى + النص + المرفقات + الوقت بالأسفل
class MessageBubble extends StatelessWidget {
  final MessageItemModel message;
  const MessageBubble({super.key, required this.message});

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec',
  ];

  String _formatTime(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      int hour = dt.hour % 12;
      if (hour == 0) hour = 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour < 12 ? 'AM' : 'PM';
      return '$hour:$minute $period';
    } catch (_) {
      return '';
    }
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final year = (dt.year % 100).toString().padLeft(2, '0');
      return "${dt.day.toString().padLeft(2, '0')} ${_months[dt.month - 1]} 20$year";
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isMine = message.isFromUser;
    final senderLabel = isMine ? loc.you : (message.senderName ?? '');
    final time = _formatTime(message.createdAt);

    // الاسم فوق على جهة المُرسِل، والوقت تحت على الجهة المقابلة (مطابقة للتصميم)
    final senderAlign =
        isMine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart;
    final timeAlign =
        isMine ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd;
    final senderCross =
        isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (senderLabel.isNotEmpty)
            Align(
              alignment: senderAlign,
              child: Text(
                senderLabel,
                style: MyTextStyle().textStyleSemiBold14(),
              ),
            ),
          SizedBox(height: 8.h),
          Align(
            alignment: senderAlign,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 0.78.sw),
              child: Column(
                crossAxisAlignment: senderCross,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.hasText) _textBubble(isMine),
                  ...message.attachments
                      .map((a) => _attachmentCard(context, a, isMine)),
                ],
              ),
            ),
          ),
          if (time.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Align(
              alignment: timeAlign,
              child: Text(
                time,
                style: MyTextStyle()
                    .textStyleRegular11()
                    .copyWith(color: AppColor.gray2),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // الزاوية السفلية اليسرى مربّعة (tail)، والباقي دائري حسب المرسِل
  BorderRadius _bubbleRadius(bool isMine) {
    final r = Radius.circular((isMine ? 16 : 12).r);
    return BorderRadius.only(
      topLeft: r,
      topRight: r,
      bottomRight: r,
      bottomLeft: Radius.zero,
    );
  }

  // كارتي: أبيض كامل #FFFFFF — كارت المستلم: أبيض بشفافية 50% #FFFFFF80
  Color _bubbleColor(bool isMine) =>
      isMine ? const Color(0xFFFFFFFF) : const Color(0x80FFFFFF);

  Widget _textBubble(bool isMine) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: _bubbleColor(isMine),
        borderRadius: _bubbleRadius(isMine),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(message.body, style: MyTextStyle().textStyleRegular14()),
    );
  }

  Widget _attachmentCard(
      BuildContext context, MessageAttachmentModel att, bool isMine) {
    // صورة: تُعرض داخل المحادثة، وبالضغط تُفتح بملء الشاشة
    if (att.isImage && att.previewUrl.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: GestureDetector(
          onTap: () => _openImage(context, att.previewUrl),
          child: ClipRRect(
            borderRadius: _bubbleRadius(isMine),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 220.h, maxWidth: 0.6.sw),
              child: Image.network(
                att.previewUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    width: 0.6.sw,
                    height: 160.h,
                    color: AppColor.gray5,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColor.k1primeryColor,
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stack) =>
                    _fileCard(context, att, isMine),
              ),
            ),
          ),
        ),
      );
    }
    // ملف عادي
    return _fileCard(context, att, isMine);
  }

  Widget _fileCard(BuildContext context, MessageAttachmentModel att, bool isMine) {
    final subtitle = att.sizeDisplay.isNotEmpty
        ? att.sizeDisplay
        : _formatDate(att.createdAt);
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: _bubbleColor(isMine),
        borderRadius: _bubbleRadius(isMine),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColor.gray5,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: VectorGraphic(
                loader: const AssetBytesLoader(AppSvg.fileSvg),
                width: 20.w,
                height: 20.h,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  att.name,
                  style: MyTextStyle().textStyleSemiBold14(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: MyTextStyle()
                        .textStyleRegular11()
                        .copyWith(color: AppColor.gray2),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // زر تنزيل المرفق
          InkWell(
            onTap: () => _downloadFile(context, att.url),
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.all(6.r),
              child: Icon(
                Icons.download_outlined,
                size: 22.r,
                color: AppColor.k1primeryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // فتح الصورة بملء الشاشة مع إمكانية التكبير
  void _openImage(BuildContext context, String url) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      builder: (dialogContext) => Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: Center(
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stack) => Icon(
                    Icons.broken_image_outlined,
                    color: AppColor.whiteColor,
                    size: 48.r,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40.h,
            right: 16.w,
            child: IconButton(
              onPressed: () => Navigator.pop(dialogContext),
              icon: Icon(Icons.close, color: AppColor.whiteColor, size: 28.r),
            ),
          ),
        ],
      ),
    );
  }

  // تنزيل المرفق
  Future<void> _downloadFile(BuildContext context, String url) async {
    if (url.isEmpty) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Downloading...')),
    );
    final ok = await UniversalDownloader().downloadFile(
      url: url,
      saveToGallery: false,
    );
    messenger.showSnackBar(
      SnackBar(content: Text(ok ? 'File downloaded successfully' : 'Download failed')),
    );
  }
}
