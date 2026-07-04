import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/data/models/my_application_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/featuer/career_opportunities/presentation/details_my_application_view.dart';
import 'package:hb/l10n/app_localizations.dart';

class MyApplicationCard extends StatelessWidget {
  final MyApplicationModel myApplicationModel;
  const MyApplicationCard({super.key,required this.myApplicationModel});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsMyApplicationView(
            applicationId: int.tryParse(myApplicationModel.id ?? '') ?? 0,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppColor.whiteColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(myApplicationModel.title ?? '', style: MyTextStyle().textStyleSemiBold14()),
            DashedLine(),
            SizedBox(height: 20.h),
            InfoRow(label: '${loc.company}: ', value: myApplicationModel.company ?? ''),
            SizedBox(height: 12.h),

            InfoRow(label: '${loc.date_applied}: ', value: myApplicationModel.dateApplied ??''),
            SizedBox(height: 12.h),

            InfoRow(label: '${loc.type_label}: ', value: myApplicationModel.type ?? ''),
            SizedBox(height: 12.h),

            InfoRow(label: '${loc.status}: ', value: myApplicationModel.status ?? ''),
          ],
        ),
      ),
    );
  }
}
