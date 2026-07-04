import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/job_project_cubit/job_project_cubit.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:vector_graphics/vector_graphics.dart';

class FiltterJobProjectWidget extends StatelessWidget {
  const FiltterJobProjectWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    // العرض مترجم، والقيمة المُرسَلة للخادم بالإنجليزية فقط
    final statuses = <String, String?>{
      loc.all: null, // الكل → بدون فلتر
      loc.pending_request: 'pending_request',
      loc.in_progress: 'in_progress',
      loc.pending_payment: 'pending_payment',
      loc.completed: 'completed',
      loc.closed: 'closed',
    };

    return Column(
      children: [
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 55.h,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColor.borderColor, width: 0.5),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.date,
                      style: MyTextStyle().textStyleMedium15().copyWith(
                        color: AppColor.hintTextColor,
                      ),
                    ),
                    VectorGraphic(loader: AssetBytesLoader(AppSvg.deadlineSvg)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Container(
                height: 55.h,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColor.borderColor, width: 0.5),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.deadline,
                      style: MyTextStyle().textStyleMedium15().copyWith(
                        color: AppColor.hintTextColor,
                      ),
                    ),
                    VectorGraphic(loader: AssetBytesLoader(AppSvg.deadlineSvg)),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        CustomDropdown(
          hint: loc.status_all,
          items: statuses.keys.toList(),
          color: AppColor.whiteColor,
          onChanged: (value) => context
              .read<JobProjectCubit>()
              .fetchJobProject(status: statuses[value]),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
