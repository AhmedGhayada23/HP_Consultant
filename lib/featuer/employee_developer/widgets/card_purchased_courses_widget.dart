import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/data/models/purchased_course_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_popup_widget.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/dialogs_utils.dart';

class CardPurchasedCoursesWidget extends StatelessWidget {
  final PurchasedCourseModle purchasedCourseModle;
  const CardPurchasedCoursesWidget({super.key, required this.purchasedCourseModle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColor.whiteColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(purchasedCourseModle.courseTitle ?? '', style: MyTextStyle().textStyleSemiBold16()),
              CustomPopupWidget(
                items: [
                  PopupMenuItemModel(
                    text: AppLocalizations.of(context)!.assign,
                    onTap: () {
                      showAssignDialog(context);
                    },
                  ),
                  PopupMenuItemModel(
                    text:  AppLocalizations.of(context)!.report,
                    onTap: () {
                      print('report');
                    },
                  ),
                ],
                child: Container(
                  width: 28.w,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColor.gray5,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Center(child: Icon(Icons.more_vert_outlined)),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          DashedLine(),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${ AppLocalizations.of(context)!.purchase_date}: ',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
              Text(
                purchasedCourseModle.purchaseDate ?? '',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${ AppLocalizations.of(context)!.assigned_employees}: ',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
              Text(
                purchasedCourseModle.assignedEmployees ?? '',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${ AppLocalizations.of(context)!.progress_avg}: ',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
              Text(
                purchasedCourseModle.progressAvg ??'',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${ AppLocalizations.of(context)!.completion_rate}: ',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
              Text(
                purchasedCourseModle.completionRate ?? '',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
