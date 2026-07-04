import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/my_course_details_cubit/my_course_details_cubit.dart';
import 'package:hb/core/data/models/my_course_details_model.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// صفحة مشاهدة دروس الكورس: اختيار الدرس + معاينة + تشغيل الفيديو
class LessonVideoView extends StatefulWidget {
  final int courseId;
  final String courseTitle;
  final String? thumbnailUrl;
  final List<MyCourseLesson> lessons;
  final int initialIndex;

  const LessonVideoView({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.lessons,
    this.initialIndex = 0,
    this.thumbnailUrl,
  });

  @override
  State<LessonVideoView> createState() => _LessonVideoViewState();
}

class _LessonVideoViewState extends State<LessonVideoView> {
  late int _index;
  bool _playing = false;
  WebViewController? _controller;
  final Set<int> _completedIds = {}; // دروس أُكملت خلال الجلسة
  bool _completing = false;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.lessons.length - 1);
  }

  MyCourseLesson get _lesson => widget.lessons[_index];

  bool get _isCompleted =>
      _lesson.isCompleted || _completedIds.contains(_lesson.id);

  // تسجيل إكمال الدرس ثم تحديث تفاصيل الدورة
  Future<void> _markComplete() async {
    if (_completing || _isCompleted) return;
    setState(() => _completing = true);
    final ok = await context
        .read<MyCourseDetailsCubit>()
        .completeLesson(_lesson.id, widget.courseId);
    if (!mounted) return;
    final loc = AppLocalizations.of(context)!;
    setState(() {
      _completing = false;
      if (ok) _completedIds.add(_lesson.id);
    });
    showCustomSnackBar(
      context,
      ok
          ? loc.lesson_marked_completed
          : (context.read<MyCourseDetailsCubit>().state.errorMessage ?? '')
              .replaceAll('Exception:', '')
              .trim(),
      ok ? SnackBarType.success : SnackBarType.error,
    );
  }

  void _selectLesson(int i) {
    setState(() {
      _index = i;
      _playing = false;
      _controller = null;
    });
  }

  void _play() {
    final url = _lesson.videoUrl ?? '';
    if (url.isEmpty) {
      showCustomSnackBar(
        context,
        AppLocalizations.of(context)!.no_video_available,
        SnackBarType.error,
      );
      return;
    }
    setState(() {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(url));
      _playing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColor.gray5,
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: const IconThemeData(color: AppColor.whiteColor),
        title: Text(
          widget.courseTitle,
          style: MyTextStyle().textStyleSemiBold20().copyWith(
            color: AppColor.whiteColor,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: AppColor.whiteColor,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: SafeArea(
          top: false,
          child: CustomButton(
            onTap: _play,
            color: AppColor.k1primeryColor,
            text: loc.start_watching,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // اختيار الدرس
            CustomDropdown(
              hint: _lesson.title ?? '',
              selectedValue: _lesson.title,
              items: widget.lessons.map((l) => l.title ?? '').toList(),
              onChanged: (value) {
                final i = widget.lessons.indexWhere((l) => l.title == value);
                if (i >= 0) _selectLesson(i);
              },
            ),
            SizedBox(height: 24.h),
            // بطاقة الفيديو / المعاينة
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: _playing && _controller != null
                    ? WebViewWidget(controller: _controller!)
                    : _preview(),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    _lesson.title ?? '',
                    style: MyTextStyle().textStyleSemiBold20(),
                  ),
                ),
                SizedBox(width: 12.w),
                _completeButton(loc),
              ],
            ),
            const DashedLine(),
            SizedBox(height: 16.h),
            Text(
              (_lesson.content ?? '').isNotEmpty
                  ? _lesson.content!
                  : '${loc.video} – ${_lesson.durationMinutes} ${loc.min}',
              style: MyTextStyle().textStyleRegular16(),
            ),
          ],
        ),
      ),
    );
  }

  // زر "Mark as Complete" — يتحوّل إلى "Completed" مع علامة صح عند الإكمال
  Widget _completeButton(AppLocalizations loc) {
    final completed = _isCompleted;
    final color = completed ? const Color(0xff84BD47) : AppColor.k1primeryColor;
    return GestureDetector(
      onTap: (_completing || completed) ? null : _markComplete,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: _completing
            ? SizedBox(
                width: 18.r,
                height: 18.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColor.whiteColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (completed) ...[
                    Icon(Icons.check_rounded,
                        size: 18.r, color: AppColor.whiteColor),
                    SizedBox(width: 6.w),
                  ],
                  Text(
                    completed ? loc.completed : loc.mark_as_complete,
                    style: MyTextStyle()
                        .textStyleMedium14()
                        .copyWith(color: AppColor.whiteColor),
                  ),
                ],
              ),
      ),
    );
  }

  // معاينة الفيديو: صورة الكورس + زر تشغيل بالمنتصف
  Widget _preview() {
    final hasImage = (widget.thumbnailUrl ?? '').isNotEmpty;
    return GestureDetector(
      onTap: _play,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.gray5,
          image: hasImage
              ? DecorationImage(
                  image: NetworkImage(widget.thumbnailUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Center(
          child: Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.whiteColor, width: 2),
              color: Colors.black.withValues(alpha: 0.25),
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: AppColor.whiteColor,
              size: 36.r,
            ),
          ),
        ),
      ),
    );
  }
}
