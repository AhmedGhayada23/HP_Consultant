import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/data/models/course_detail_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/featuer/user_home/student_home/widgets/course_overview_section.dart';
import 'package:hb/l10n/app_localizations.dart';

class TrainerProfile extends StatelessWidget {
  final Trainer? trainer;
  const TrainerProfile({required this.trainer, super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (trainer == null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Text(
          loc.no_trainer_info,
          style: MyTextStyle().textStyleRegular16(),
        ),
      );
    }

    final t = trainer!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          minLeadingWidth: 0,
          minTileHeight: 0,
          minVerticalPadding: 0,
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(radius: 35.r, backgroundColor: AppColor.gray5),
          title: Text(t.name, style: MyTextStyle().textStyleSemiBold16()),
        ),
        SizedBox(height: 20.h),
        Text(loc.about_trainer_bio, style: MyTextStyle().textStyleSemiBold16()),
        SizedBox(height: 8.h),
        Text(t.bio, style: MyTextStyle().textStyleMedium16()),
        if (t.experience.isNotEmpty) ...[
          SizedBox(height: 20.h),
          Text(loc.industry_experience, style: MyTextStyle().textStyleSemiBold16()),
          ...t.experience.map((e) => BulletPoint(text: e)),
        ],
        if (t.certifications.isNotEmpty) ...[
          SizedBox(height: 20.h),
          Text(loc.certifications_label, style: MyTextStyle().textStyleSemiBold16()),
          ...t.certifications.map((e) => BulletPoint(text: e)),
        ],
      ],
    );
  }
}
