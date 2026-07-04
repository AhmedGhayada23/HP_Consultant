import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hb/core/cubit/job_and_talent_cubit/job_and_talent_cubit.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:vector_graphics/vector_graphics.dart';

class SearchBoxWidget extends StatelessWidget {
  final String hintText;
  final Color? fillColor;
  final VoidCallback? onTap;
  final bool isFilterOpen;
  final Function(String)? onChanged;
  const SearchBoxWidget({
    super.key,
    required this.hintText,
    this.fillColor = AppColor.gray1,
    this.onTap,
    this.isFilterOpen = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 55.h,
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: MyTextFieldWidget(
              fillColor: fillColor,
              hintText: hintText,
              showPrefixIcon: true,
              assetsPrefixIcon: AppSvg.searchSvg,
           onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        InkWell(
          onTap: onTap,
          child: Container(
            width: 56.w,
            height: 55.h,
            decoration: BoxDecoration(
              color: isFilterOpen ? AppColor.k1primeryColor : AppColor.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: VectorGraphic(
                loader: AssetBytesLoader(AppSvg.filterSvg),
                colorFilter: ColorFilter.mode(
                  isFilterOpen ? Colors.white : AppColor.blackColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
