import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/purchase_course_cubit/purchase_course_cubit.dart';
import 'package:hb/core/cubit/purchase_course_cubit/purchase_course_state.dart';
import 'package:hb/core/cubit/training_courses_cubit/training_courses_cubit.dart';
import 'package:hb/core/cubit/training_courses_cubit/training_courses_state.dart';
import 'package:hb/core/data/models/training_course_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/employee_developer/widgets/card_purchase_new_course_widget.dart';
import 'package:hb/featuer/employee_developer/widgets/filtter_purchase_course.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PurchaseNewCourseView extends StatelessWidget {
  const PurchaseNewCourseView({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ أضف PurchaseCourseCubit هنا فوق كل شي
    return BlocProvider(
      create: (_) => PurchaseCourseCubit(),
      child: const _PurchaseNewCourseBody(),
    );
  }
}

class _PurchaseNewCourseBody extends StatefulWidget {
  const _PurchaseNewCourseBody();

  @override
  State<_PurchaseNewCourseBody> createState() => _PurchaseNewCourseBodyState();
}

class _PurchaseNewCourseBodyState extends State<_PurchaseNewCourseBody> {
  bool isFiltterVisible = false;

  @override
  void initState() {
    super.initState();
    context.read<TrainingCoursesCubit>().fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocListener<PurchaseCourseCubit, PurchaseCourseState>(
      listener: (context, state) {
        if (state.isSuccess == true) {
          showRequestSubmittedDialog(
            context,
            title: 'Course Purchased Successfully',
            subTitle: 'You have successfully purchased.',
            textBtn: 'Done',
            onDone: () {
              Navigator.pop(context);
              // context.read<PurchaseCourseCubit>().resetSuccess();
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColor.whiteColor),
          title: Text(
            loc.purchase_new_course,
            style: MyTextStyle().textStyleSemiBold16().copyWith(color: AppColor.whiteColor),
          ),
          backgroundColor: AppColor.blackColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
            child: Column(
              children: [
                SearchBoxWidget(
                  hintText: loc.search_by_title,
                  fillColor: AppColor.whiteColor,
                  isFilterOpen: isFiltterVisible,
                  onChanged: (value) =>
                      context.read<TrainingCoursesCubit>().fetchCourses(search: value),
                  onTap: () {
                    setState(() {
                      isFiltterVisible = !isFiltterVisible;
                    });
                  },
                ),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(sizeFactor: animation, child: child),
                    );
                  },
                  child: isFiltterVisible
                      ? const FiltterPurchaseCourse(key: ValueKey("filter_open"))
                      : const SizedBox(key: ValueKey("filter_closed")),
                ),

                const DashedLine(),
                SizedBox(height: 20.h),

                BlocBuilder<TrainingCoursesCubit, TrainingCoursesState>(
                  builder: (context, state) {
                    if (state.loading) {
                      final data = TrainingCourseModel.fake();
                      return Skeletonizer(
                        enabled: true,
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 3,
                          separatorBuilder: (_, __) => SizedBox(height: 20.h),
                          itemBuilder: (_, __) => CardPurchaseNewCourseWidget(course: data),
                        ),
                      );
                    }

                    if (state.errorMessage != null) {
                      return Center(child: Text(state.errorMessage!));
                    }

                    if (state.courses == null || state.courses!.isEmpty) {
                      return Center(child: Text(loc.no_courses_available));
                    }

                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.courses!.length,
                      separatorBuilder: (_, __) => SizedBox(height: 20.h),
                      itemBuilder: (_, index) {
                        return CardPurchaseNewCourseWidget(course: state.courses![index]);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
