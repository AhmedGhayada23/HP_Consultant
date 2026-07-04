import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/data/models/my_course_details_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/expandable_box_widget.dart';
import 'package:hb/featuer/my_coureses/presentation/lesson_video_view.dart';
import 'package:hb/l10n/app_localizations.dart';

class CourseOverview extends StatelessWidget {
  final MyCourseInfo? course;
  final List<MyCourseModule> modules;
  const CourseOverview({super.key, this.course, this.modules = const []});

  // فتح صفحة مشاهدة الدرس مع قائمة دروس الوحدة
  void _openVideo(
      BuildContext context, List<MyCourseLesson> lessons, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonVideoView(
          courseId: course?.id ?? 0,
          courseTitle: course?.title ?? '',
          thumbnailUrl: course?.thumbnailUrl,
          lessons: lessons,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course?.description ?? '',
          style: MyTextStyle().textStyleRegular14(),
        ),
        SizedBox(height: 20.h),
        Text(loc.key_stats, style: MyTextStyle().textStyleSemiBold16()),
        SizedBox(height: 8.h),
        Text(
          '${loc.level}: ${course?.levelLabel ?? course?.level ?? ''}',
          style: MyTextStyle().textStyleRegular14(),
        ),
        SizedBox(height: 20.h),
        Text(loc.curriculum, style: MyTextStyle().textStyleSemiBold16()),
        SizedBox(height: 12.h),
        ...modules.map(
          (module) => Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: ExpandableBoxWidget(
              title: module.title ?? '',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < module.lessons.length; i++) ...[
                    if (i > 0) ...[
                      SizedBox(height: 8.h),
                      DashedLine(),
                      SizedBox(height: 8.h),
                    ],
                    _lessonItem(context, module.lessons, i, loc),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // عنصر درس: أيقونة تشغيل + العنوان (Video – X Min) + زر Watched/Start Watching
  Widget _lessonItem(BuildContext context, List<MyCourseLesson> lessons,
      int index, AppLocalizations loc) {
    final lesson = lessons[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: AppColor.gray5,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.play_circle_outline,
                  size: 20.r, color: AppColor.gray2),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                '${lesson.title ?? ''} (${loc.video} – ${lesson.durationMinutes} ${loc.min})',
                style: MyTextStyle().textStyleRegular14(),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        // مُشاهد: زر أخضر ممتلئ — غير مُشاهد: زر بحد أخضر
        lesson.isCompleted
            ? CustomButton(
                onTap: () => _openVideo(context, lessons, index),
                color: const Color(0xff84BD47),
                text: loc.watched,
              )
            : CustomButtonBorder(
                onTap: () => _openVideo(context, lessons, index),
                borderColor: AppColor.k1primeryColor,
                text: loc.start_watching,
              ),
      ],
    );
  }
}
