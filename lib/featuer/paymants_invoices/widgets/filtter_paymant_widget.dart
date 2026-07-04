import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:vector_graphics/vector_graphics.dart';

class FiltterPaymantWidget extends StatelessWidget {
  const FiltterPaymantWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: CustomDropdown(hint: loc.status_all, items: [], color: AppColor.whiteColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomDropdown(hint: 'Type | All', items: [], color: AppColor.whiteColor),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: CustomDropdown(hint: loc.amount, items: [], color: AppColor.whiteColor),
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
      ],
    );
  }
}
