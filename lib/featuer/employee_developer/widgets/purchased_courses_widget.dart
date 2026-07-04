import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/employee_developer_cubit/purchased_course_cubit.dart';
import 'package:hb/core/cubit/employee_developer_cubit/purchased_course_state.dart';
import 'package:hb/core/data/models/employee_developer_model.dart';
import 'package:hb/core/data/models/purchased_course_model.dart';
import 'package:hb/featuer/employee_developer/widgets/card_purchased_courses_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PurchasedCoursesWidget extends StatelessWidget {
  const PurchasedCoursesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchasedCourseCubit, PurchasedCourseSate>(
      builder: (context, state) {
        final bool loading = state.loading;
        final data =
            state.purchasedCourseModle ?? List.generate(3, (index) => PurchasedCourseModle.fake());

        return Skeletonizer(
          enabled: loading,
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) =>
                CardPurchasedCoursesWidget(purchasedCourseModle: data[index]),
            separatorBuilder: (context, index) => SizedBox(height: 10.h),
            itemCount: data.length,
          ),
        );
      },
    );
  }
}
