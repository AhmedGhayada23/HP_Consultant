import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/data/models/course_detail_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/l10n/app_localizations.dart';

class CourseOverviewSection extends StatefulWidget {
  final CourseDetailModel? course;
  const CourseOverviewSection({required this.course, super.key});

  @override
  State<CourseOverviewSection> createState() => _CourseOverviewSectionState();
}

class _CourseOverviewSectionState extends State<CourseOverviewSection> {
  bool _curriculumExpanded = true;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final course = widget.course;
    final stats = course?.stats;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course?.description ?? '',
          style: MyTextStyle().textStyleRegular16(),
        ),
        SizedBox(height: 20.h),
        Text(loc.learning_outcomes_title, style: MyTextStyle().textStyleSemiBold16()),
        SizedBox(height: 20.h),
        Text(loc.after_course_able,
            style: MyTextStyle().textStyleRegular16()),
        const SizedBox(height: 12),
        ...?course?.learningOutcomes.map((e) => BulletPoint(text: e)),

        SizedBox(height: 20.h),
        Text(loc.key_stats, style: MyTextStyle().textStyleSemiBold16()),
        SizedBox(height: 20.h),
        BulletPoint(text: '${loc.duration}: ${stats?.durationHours ?? 0} ${loc.hrs}'),
        BulletPoint(text: '${loc.level}: ${stats?.level ?? ''}'),
        BulletPoint(text: '${loc.format}: ${stats?.format ?? ''}'),
        BulletPoint(
          text:
              '${loc.certificate}: ${(stats?.certificate ?? false) ? loc.certificate_yes : loc.no_word}',
        ),

        SizedBox(height: 20.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: AppColor.whiteColor,
            boxShadow: [BoxShadow(color: AppColor.borderColor)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _curriculumExpanded = !_curriculumExpanded),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(loc.curriculum, style: MyTextStyle().textStyleMedium16()),
                    Icon(
                      _curriculumExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                    ),
                  ],
                ),
              ),
              if (_curriculumExpanded) ...[
                SizedBox(height: 12.h),
                ...?course?.modules.map((module) {
                  final totalMin = module.lessons
                      .fold<int>(0, (s, l) => s + l.durationMinutes);
                  final h = (totalMin / 60).round();
                  final unit = h == 1 ? loc.hr : loc.hrs;
                  final lessonsSub =
                      module.lessons.map((l) => l.title).join(', ');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: AppColor.borderColor),
                      SizedBox(height: 4.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(module.title,
                                style: MyTextStyle().textStyleSemiBold14()),
                          ),
                          if (totalMin > 0)
                            Text('  ($h $unit)',
                                style: MyTextStyle()
                                    .textStyleSemiBold14()
                                    .copyWith(color: AppColor.gray2)),
                        ],
                      ),
                      if (lessonsSub.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(lessonsSub,
                            style: MyTextStyle()
                                .textStyleRegular14()
                                .copyWith(color: AppColor.gray2)),
                      ],
                      SizedBox(height: 10.h),
                    ],
                  );
                }),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18, height: 1.5)),
          Expanded(child: Text(text, style: MyTextStyle().textStyleRegular16())),
        ],
      ),
    );
  }
}
