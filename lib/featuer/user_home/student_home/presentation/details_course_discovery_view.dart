import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/course_detail_cubit/course_detail_cubit.dart';
import 'package:hb/core/cubit/course_detail_cubit/course_detail_state.dart';
import 'package:hb/core/cubit/course_enroll_cubit/course_enroll_cubit.dart';
import 'package:hb/core/cubit/course_enroll_cubit/course_enroll_state.dart';
import 'package:hb/core/data/models/course_detail_model.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/featuer/user_home/student_home/presentation/payment_webview_view.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/featuer/user_home/student_home/widgets/course_overview_section.dart';
import 'package:hb/featuer/user_home/student_home/widgets/entollment_payment.dart';
import 'package:hb/featuer/user_home/student_home/widgets/review.dart';
import 'package:hb/featuer/user_home/student_home/widgets/trainer_profile.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailsCourseDiscoveryView extends StatefulWidget {
  final int courseId;
  const DetailsCourseDiscoveryView({super.key, required this.courseId});

  @override
  State<DetailsCourseDiscoveryView> createState() =>
      _DetailsCourseDiscoveryViewState();
}

class _DetailsCourseDiscoveryViewState
    extends State<DetailsCourseDiscoveryView> {
  int _selectedTab = 0; // 0=Overview 1=Trainer 2=Reviews 3=Enrollment

  // عناوين التبويبات المترجمة بحسب الترتيب أعلاه
  List<String> _tabs(AppLocalizations loc) => [
        loc.course_overview,
        loc.trainer_profile,
        loc.reviews,
        loc.enrollment_and_payment,
      ];

  Widget getSelectedSection(CourseDetailModel? course) {
    switch (_selectedTab) {
      case 1:
        return TrainerProfile(trainer: course?.trainer);
      case 2:
        return Review(
          rating: course?.rating ?? 0,
          reviewsCount: course?.reviewsCount ?? 0,
        );
      case 3:
        return EntollmentPayment(course: course);
      default:
        return CourseOverviewSection(course: course);
    }
  }

  @override
  void initState() {
    super.initState();
    getCourseDetail();
  }

  void getCourseDetail() {
    context.read<CourseDetailCubit>().fetchCourseDetail(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocListener<CourseEnrollCubit, CourseEnrollState>(
      listener: (context, enrollState) {
        if (enrollState.result != null) {
          final result = enrollState.result!;
          context.read<CourseEnrollCubit>().reset();
          if (result.paymentUrl != null && result.paymentUrl!.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    PaymentWebViewView(paymentUrl: result.paymentUrl!),
              ),
            );
          } else {
            // لا يوجد دفع مطلوب: التسجيل مكتمل
            showCustomSnackBar(context, result.message, SnackBarType.success);
          }
        } else if (enrollState.errorMessage != null) {
          showCustomSnackBar(
            context,
            enrollState.errorMessage!,
            SnackBarType.error,
          );
        }
      },
      child: BlocBuilder<CourseDetailCubit, CourseDetailState>(
        builder: (context, state) {
          final course = state.courseDetails;
          return Skeletonizer(
            enabled: state.loading ?? false,
            child: Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(color: AppColor.whiteColor),
                backgroundColor: AppColor.blackColor,
                title: Text(
                  course?.title ?? loc.course_title,
                  style: MyTextStyle().textStyleSemiBold16().copyWith(
                    color: AppColor.whiteColor,
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Center(
                      child: Text(
                        course?.priceDisplay ?? '',
                        style: MyTextStyle().textStyleSemiBold16().copyWith(
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: Container(
                color: AppColor.whiteColor,
                height: 100.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: BlocBuilder<CourseEnrollCubit, CourseEnrollState>(
                  builder: (context, enrollState) {
                    final isEnrolling =
                        enrollState.loadingCourseId == widget.courseId;
                    return CustomButton(
                      onTap: isEnrolling
                          ? () {}
                          : () => context.read<CourseEnrollCubit>().enroll(
                              widget.courseId,
                            ),
                      color: AppColor.k1primeryColor,
                      text: isEnrolling
                          ? '...'
                          : '${loc.enroll_now}${(course?.priceDisplay ?? '').isNotEmpty ? ' - ${course!.priceDisplay}' : ''}',
                    );
                  },
                ),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 292.47.h,
                        decoration: BoxDecoration(
                          color: AppColor.gray5,
                          borderRadius: BorderRadius.circular(16.r),
                          image: course?.thumbnailUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(course!.thumbnailUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      CustomDropdown(
                        onChanged: (value) {
                          final i = _tabs(loc).indexOf(value);
                          if (i >= 0) setState(() => _selectedTab = i);
                        },
                        hint: _tabs(loc)[_selectedTab],
                        items: _tabs(loc),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        _tabs(loc)[_selectedTab],
                        style: MyTextStyle().textStyleSemiBold16(),
                      ),
                      DashedLine(),
                      SizedBox(height: 20.h),
                      getSelectedSection(course),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
