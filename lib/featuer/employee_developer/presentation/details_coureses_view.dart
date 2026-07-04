import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/training_details_courses/training_details_courses_cubit.dart';
import 'package:hb/core/cubit/training_details_courses/training_details_state.dart';
import 'package:hb/core/data/models/course_details_model.dart';
import 'package:hb/core/data/models/training_course_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/featuer/employee_developer/widgets/details_course_overview_widget.dart';
import 'package:hb/featuer/employee_developer/widgets/details_reviews_widget.dart';
import 'package:hb/featuer/employee_developer/widgets/details_trainer_profile_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailsCouresesView extends StatefulWidget {
  final TrainingCourseModel courseModel;
  const DetailsCouresesView({super.key, required this.courseModel});

  @override
  State<DetailsCouresesView> createState() => _DetailsCouresesViewState();
}

class _DetailsCouresesViewState extends State<DetailsCouresesView> {
  String? vlaueDropdown; // يُهيّأ من loc.course_overview عند أول بناء

  @override
  void initState() {
    super.initState();
    context.read<TrainingDetailsCoursesCubit>().getCourseDetails(widget.courseModel.id);
  }

  Widget getSelectedSection(CourseDetailsModel details, AppLocalizations loc) {
    if (vlaueDropdown == loc.course_overview) {
      return DetailsCourseOverviewWidget(courseDetails: details);
    } else if (vlaueDropdown == loc.reviews) {
      return DetailsReviewsWidget(courseDetails: details);
    } else if (vlaueDropdown == loc.trainer_profile) {
      return DetailsTrainerProfileWidget(courseDetails: details);
    } else {
      return DetailsCourseOverviewWidget(courseDetails: details);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    vlaueDropdown ??= loc.course_overview;
    return BlocProvider(
      create: (_) => TrainingDetailsCoursesCubit()..getCourseDetails(widget.courseModel.id),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColor.whiteColor),
          backgroundColor: AppColor.blackColor,
          title: Text(
            widget.courseModel.title,
            style: MyTextStyle().textStyleSemiBold20().copyWith(color: AppColor.whiteColor),
          ),
        ),
        body: BlocBuilder<TrainingDetailsCoursesCubit, TrainingDetailsState>(
          builder: (context, state) {

            if (state.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48.sp, color: AppColor.k1primeryColor),
                    SizedBox(height: 12.h),
                    Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: MyTextStyle().textStyleSemiBold16(),
                    ),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: () => context.read<TrainingDetailsCoursesCubit>().getCourseDetails(
                        widget.courseModel.id,
                      ),
                      child: Text(loc.retry),
                    ),
                  ],
                ),
              );
            }

            final details = state.courseDetails ?? CourseDetailsModel.fake();

            return Skeletonizer(
              enabled: state.isLoading,
              child: Scaffold(
                bottomNavigationBar: _BottomEnrollBar(
                  courseId: details.id,
                  priceDisplay: details.priceDisplay,
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnail
                        Container(
                          height: 250.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: AppColor.gray5,
                            image: details.thumbnail != null
                                ? DecorationImage(
                                    image: NetworkImage(details.thumbnail!),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(image: AssetImage(AppImage.logoAuthImage)),
                          ),
                          child: details.thumbnail != null
                              ? Center(
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    size: 64.sp,
                                    color: AppColor.borderColor,
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(height: 20.h),

                        // Quick info chips
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: [
                            _InfoChip(icon: Icons.signal_cellular_alt, label: details.levelDisplay),
                            _InfoChip(
                                icon: Icons.access_time,
                                label: loc.hours_count(details.durationHours)),
                            _InfoChip(
                              icon: Icons.people_outline,
                              label: loc.enrolled_count(details.totalEnrollments),
                            ),
                            _InfoChip(
                              icon: Icons.star_outline,
                              label: details.rating.toStringAsFixed(1),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        // Dropdown selector
                        CustomDropdown(
                          onChanged: (value) {
                            setState(() => vlaueDropdown = value);
                          },
                          hint: vlaueDropdown!,
                          items: [loc.course_overview, loc.trainer_profile, loc.reviews],
                        ),
                        SizedBox(height: 24.h),
                        Text(vlaueDropdown!, style: MyTextStyle().textStyleSemiBold20()),
                        DashedLine(),
                        SizedBox(height: 20.h),
                        getSelectedSection(details, loc),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Bottom bar ──────────────────────────────────────────────────────────────

class _BottomEnrollBar extends StatelessWidget {
  final int courseId;
  final String priceDisplay;

  const _BottomEnrollBar({required this.courseId, required this.priceDisplay});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        boxShadow: [BoxShadow(color: AppColor.borderColor, offset: const Offset(0, -3))],
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      child: CustomButton(
        onTap: () {
          // TODO: handle enrollment
        },
        color: AppColor.k1primeryColor,
        text: '${loc.buy_now} - $priceDisplay',
      ),
    );
  }
}

// ─── Info chip ───────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColor.gray5,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColor.k1primeryColor),
          SizedBox(width: 4.w),
          Text(label, style: MyTextStyle().textStyleRegular14()),
        ],
      ),
    );
  }
}
