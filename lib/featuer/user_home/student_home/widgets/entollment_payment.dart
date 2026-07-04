import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/data/models/course_detail_model.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/featuer/user_home/student_home/widgets/course_overview_section.dart';
import 'package:hb/l10n/app_localizations.dart';

class EntollmentPayment extends StatelessWidget {
  final CourseDetailModel? course;
  const EntollmentPayment({required this.course, super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final stats = course?.stats;
    final included = <String>[
      if ((stats?.durationHours ?? 0) > 0)
        '✅ ${loc.video_lessons_hrs(stats!.durationHours)}',
      if ((stats?.format ?? '').isNotEmpty) '✅ ${stats!.format}',
      if (stats?.certificate ?? false) '✅ ${loc.certificate_of_completion}',
      '✅ ${loc.lifetime_access}',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.whats_included, style: MyTextStyle().textStyleSemiBold16()),
        SizedBox(height: 16.h),
        ...included.map((e) => BulletPoint(text: e)),
        SizedBox(height: 20.h),
        Text(loc.price, style: MyTextStyle().textStyleSemiBold16()),
        SizedBox(height: 8.h),
        Text(
          course?.priceDisplay ?? '',
          style: MyTextStyle().textStyleMedium16(),
        ),
        SizedBox(height: 20.h),
        Text(loc.guarantee_trust, style: MyTextStyle().textStyleSemiBold16()),
        SizedBox(height: 16.h),
        BulletPoint(text: '🔒 ${loc.secure_payment}'),
        BulletPoint(text: '💸 ${loc.refund_policy}'),
        BulletPoint(text: '🏅 ${loc.accredited_certificate}'),
      ],
    );
  }
}
