import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/course_discovery_cubit/course_discovery_cubit.dart';
import 'package:hb/core/cubit/course_discovery_cubit/course_discovery_state.dart';
import 'package:hb/core/data/models/course_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/custom_drawer_visitor.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/user_home/student_home/presentation/details_course_discovery_view.dart';
import 'package:hb/featuer/user_home/student_home/widgets/filtter_course_discovery_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VisitorCourseDiscoveryView extends StatefulWidget {
  const VisitorCourseDiscoveryView({super.key});

  @override
  State<VisitorCourseDiscoveryView> createState() => _VisitorCourseDiscoveryViewState();
}

class _VisitorCourseDiscoveryViewState extends State<VisitorCourseDiscoveryView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFiltterVisible = false;

  @override
  void initState() {
    super.initState();
    getCourses();
  }

  void getCourses() {
    context.read<CourseDiscoveryCubit>().fetchCourseDiscovery();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawerVisitor(),
      appBar: CustomAppBar(
        title: 'Course Discovery',
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer(); // ✅ فتح drawer باستخدام المفتاح
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w, vertical: 32.h),
          child: Column(
            children: [
              // box saesh
              SearchBoxWidget(hintText: loc.search_by_title, fillColor: AppColor.whiteColor,
              isFilterOpen: isFiltterVisible,
              onTap: () {
                setState(() {
                  isFiltterVisible = !isFiltterVisible;
                });
              }
              ),
                   AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(sizeFactor: animation, child: child),
                  );
                },
                child: isFiltterVisible
                    ? FiltterCourseDiscoveryWidget(key: ValueKey("filter_open"))
                    : SizedBox(key: ValueKey("filter_closed")),
              ),
              DashedLine(),
              SizedBox(height: 20.h),

              BlocBuilder<CourseDiscoveryCubit, CourseDiscoveryState>(
                builder: (context, state) {
                  final courses = state.courses ?? List.generate(3, (index) => CourseModel());
                  return Skeletonizer(
                    enabled: state.loading ?? false,
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: AppColor.whiteColor,
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 192.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(courses[index].imageUrl ?? ''),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 10.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColor.whiteColor,
                                            borderRadius: BorderRadius.circular(50.r),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Level: ${courses[index].level ?? ''}',
                                              style: MyTextStyle().textStyleRegular14().copyWith(
                                                color: AppColor.k1primeryColor,
                                              ),
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
                                  Text(
                                    courses[index].title ?? '',
                                    style: MyTextStyle().textStyleMedium16(),
                                  ),
                                  Text(
                                    '${courses[index].price ?? ''}',
                                    style: MyTextStyle().textStyleMedium16(),
                                  ),
                                ],
                              ),
                              DashedLine(),
                              SizedBox(height: 16.h),
                              Text(
                                courses[index].description ?? '',
                                style: MyTextStyle().textStyleMedium16(),
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      onTap: () {},
                                      color: AppColor.k1primeryColor,
                                      text: loc.buy_now,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: CustomButtonBorder(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailsCourseDiscoveryView(courseId: courses[index].id ?? 0),
                                        ),
                                      ),
                                      borderColor: AppColor.k1primeryColor,
                                      text: loc.view_details,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 10.h),
                      itemCount: courses.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
