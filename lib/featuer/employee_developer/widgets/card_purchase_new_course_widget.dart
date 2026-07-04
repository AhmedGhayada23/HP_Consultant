import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/purchase_course_cubit/purchase_course_cubit.dart';
import 'package:hb/core/cubit/purchase_course_cubit/purchase_course_state.dart';
import 'package:hb/core/data/models/training_course_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/featuer/employee_developer/presentation/details_coureses_view.dart';

class CardPurchaseNewCourseWidget extends StatelessWidget {
  final TrainingCourseModel course;

  const CardPurchaseNewCourseWidget({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColor.whiteColor,
      ),
      child: Column(
        children: [
          // Thumbnail
          Container(
            height: 192.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(AppImage.logoAuthImage),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Text(
                        'Level: ${course.level}',
                        style: MyTextStyle().textStyleRegular14().copyWith(
                          color: AppColor.k1primeryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(course.title, style: MyTextStyle().textStyleMedium16()),
              Text(course.priceDisplay, style: MyTextStyle().textStyleMedium16()),
            ],
          ),
          DashedLine(),
          SizedBox(height: 16.h),
          Text(course.description, style: MyTextStyle().textStyleMedium16()),
          SizedBox(height: 16.h),

          // ✅ BlocBuilder بس على زر الشراء
          BlocBuilder<PurchaseCourseCubit, PurchaseCourseState>(
            builder: (context, state) {
              final isLoading = state.isLoadingFor(course.id); // ✅ بيتحقق بس من هاد العنصر

              return Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: isLoading
                          ? () {}
                          : () => context.read<PurchaseCourseCubit>().purchaseCourse(context,course.id),
                      color: AppColor.k1primeryColor,
                      text: isLoading ? 'Loading ...' : 'Purchase',

                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomButtonBorder(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsCouresesView(courseModel: course),
                          ),
                        );
                      },
                      borderColor: AppColor.k1primeryColor,
                      text: 'View Details',
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
