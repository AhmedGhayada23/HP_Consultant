import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/data/models/job_application_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_popup_widget.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/jobs_and_talent/presentation/details_application_view.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:number_paginator/number_paginator.dart';

class JobApplicantsSectionWidget extends StatelessWidget {
  final List<JobApplicationModel> data;
  final int currentPage;
  final int totalPages;
  final void Function(int page)? onPageChange;
  const JobApplicantsSectionWidget({
    super.key,
    required this.data,
    this.currentPage = 1,
    this.totalPages = 1,
    this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.job_applicants,
            style: MyTextStyle().textStyleSemiBold16(),
          ),
          SizedBox(height: 20.h),
          SearchBoxWidget(
            hintText: AppLocalizations.of(context)!.search_jobs_placeholder,
            fillColor: AppColor.whiteColor,
          ),
          SizedBox(height: 20.h),
          _buildApplicantCard(context, data),
          SizedBox(height: 20.h),
          if (totalPages > 1) ...[
            _buildPaginator(),
            SizedBox(height: 20.h),
          ],
          DashedLine(),
        ],
      ),
    );
  }

  Widget _buildApplicantCard(
    BuildContext context,
    List<JobApplicationModel> data,
  ) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColor.gray5,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data[index].name,
                  style: MyTextStyle().textStyleSemiBold16(),
                ),
                CustomPopupWidget(
                  items: [
                    PopupMenuItemModel(
                      text: AppLocalizations.of(context)!.view,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsApplicationView(
                              jobApplicationModel: data[index],
                            ),
                          ),
                        );
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
            _buildInfoRow(
              '${AppLocalizations.of(context)!.profession}:',
              data[index].profssion,
            ),
            SizedBox(height: 20.h),
            _buildInfoRow(
              '${AppLocalizations.of(context)!.rate_per_hour}:',
              data[index].rate,
            ),
            SizedBox(height: 20.h),
            _buildInfoRow(
              '${AppLocalizations.of(context)!.experience}:',
              data[index].experience,
            ),
            SizedBox(height: 20.h),
            _buildInfoRow(
              '${AppLocalizations.of(context)!.skills}:',
              data[index].skills,
            ),
            SizedBox(height: 20.h),
            _buildInfoRow(
              '${AppLocalizations.of(context)!.status}:',
              data[index].status,
            ),
          ],
        ),
      ),
      separatorBuilder: (context, index) => SizedBox(height: 10.h),
      itemCount: data.length,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: MyTextStyle().textStyleMedium14().copyWith(
            color: AppColor.gray3,
          ),
        ),
        Text(
          value,
          style: MyTextStyle().textStyleMedium14().copyWith(
            color: AppColor.gray3,
          ),
        ),
      ],
    );
  }

  Widget _buildPaginator() {
    return NumberPaginator(
      numberPages: totalPages,
      initialPage: (currentPage - 1).clamp(0, totalPages - 1),
      onPageChange: (int index) {
        onPageChange?.call(index + 1); // الـ API يبدأ من 1
      },
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            PrevButton(
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColor.gray5,
                child: Icon(Icons.arrow_back_ios_new, size: 14.r),
              ),
            ),
            Expanded(
              child: NumberContent(
                buttonBuilder: (context, index, isSelected) => Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: isSelected ? 1 : 0,
                      color: isSelected
                          ? const Color(0xFF542198)
                          : Colors.transparent,
                    ),
                    color: isSelected
                        ? const Color(0xFFE9E1FF)
                        : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: MyTextStyle().textStyleMedium16().copyWith(
                        color: isSelected
                            ? const Color(0xFF542198)
                            : AppColor.blackColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            NextButton(
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColor.gray5,
                child: Icon(Icons.arrow_forward_ios_outlined, size: 14.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
