import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/data/models/consultant_project_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_popup_widget.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/featuer/consultant_project/presentation/assign_a_project_view.dart';
import 'package:hb/featuer/consultant_project/presentation/view_consultant_profile.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/dialogs_utils.dart';

class CardConsultantProjectWidget extends StatelessWidget {
  final ConsultantProjectModel? consultantProjectModel;
  const CardConsultantProjectWidget({super.key, this.consultantProjectModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(consultantProjectModel?.name ?? '', style: MyTextStyle().textStyleSemiBold16()),

              CustomPopupWidget(
                items: [
                  PopupMenuItemModel(
                    text: AppLocalizations.of(context)!.view_consultant_profile,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewConsultantProfile(
                            consultantProjectModel: consultantProjectModel!,
                          ),
                        ),
                      );
                    },
                  ),
                  PopupMenuItemModel(
                    text: AppLocalizations.of(context)!.assign_to_project,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AssignToAProjectView(consultantProjectModel: consultantProjectModel!),
                        ),
                      );
                    },
                  ),
                  // PopupMenuItemModel(
                  //   text: AppLocalizations.of(context)!.contact,
                  //   onTap: () {
                  //     showContact(context : context,consultantProjectModel: consultantProjectModel!);
                  //   },
                  // ),
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
                '${AppLocalizations.of(context)!.role_expertise}:',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
              Text(
                consultantProjectModel?.role ?? '',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context)!.assigned_projects}: ',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
              Text(
                consultantProjectModel!.assignedProjects.isNotEmpty
                    ? consultantProjectModel?.assignedProjects[0] ?? ''
                    : '-',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context)!.rate}: ',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
              Text(
                '${consultantProjectModel?.rate ?? ''}',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context)!.status}: ',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
              Text(
                consultantProjectModel?.status ?? '',
                style: MyTextStyle().textStyleMedium14().copyWith(
                  color:
                      consultantProjectModel?.status == 'available' ||
                          consultantProjectModel?.status == 'active'
                      ? AppColor.k1primeryColor
                      : consultantProjectModel?.status == 'close' ||
                            consultantProjectModel?.status == 'closed'
                      ? AppColor.countNotificationBgColor
                      : AppColor.orangColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
