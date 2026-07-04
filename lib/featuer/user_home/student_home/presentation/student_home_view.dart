import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/course_discovery_cubit/course_discovery_cubit.dart';
import 'package:hb/core/cubit/course_discovery_cubit/course_discovery_state.dart';
import 'package:hb/core/cubit/course_enroll_cubit/course_enroll_cubit.dart';
import 'package:hb/core/cubit/course_enroll_cubit/course_enroll_state.dart';
import 'package:hb/core/data/models/course_model.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/featuer/user_home/student_home/presentation/payment_webview_view.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/custom_drawer_student.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/user_home/student_home/presentation/details_course_discovery_view.dart';
import 'package:hb/featuer/user_home/student_home/widgets/filtter_course_discovery_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StudentHomeView extends StatefulWidget {
  const StudentHomeView({super.key});

  @override
  State<StudentHomeView> createState() => _StudentHomeViewState();
}

class _StudentHomeViewState extends State<StudentHomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFiltterVisible = false;

  @override
  void initState() {
    super.initState();
    context.read<CourseDiscoveryCubit>().fetchCourseDiscovery();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawerStudent(),
      appBar: CustomAppBar(
        title: loc.course_discovery,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: BlocListener<CourseEnrollCubit, CourseEnrollState>(
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
            child: Column(
              children: [
                SearchBoxWidget(
                  hintText: loc.search_by_title,
                  fillColor: AppColor.whiteColor,
                  isFilterOpen: isFiltterVisible,
                  onChanged: (value) =>
                      context.read<CourseDiscoveryCubit>().applySearch(value),
                  onTap: () =>
                      setState(() => isFiltterVisible = !isFiltterVisible),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SizeTransition(sizeFactor: animation, child: child),
                  ),
                  child: isFiltterVisible
                      ? FiltterCourseDiscoveryWidget(
                          key: const ValueKey('filter_open'),
                        )
                      : const SizedBox(key: ValueKey('filter_closed')),
                ),
                DashedLine(),
                SizedBox(height: 20.h),
                BlocBuilder<CourseDiscoveryCubit, CourseDiscoveryState>(
                  builder: (context, state) {
                    final isLoading = state.loading;
                    final courses =
                        state.courses ?? List.generate(3, (_) => CourseModel());

                    if (!isLoading && (state.courses?.isEmpty ?? false)) {
                      return EmptyStateWidget(
                        title: loc.no_data_available,
                        icon: Icons.school_outlined,
                      );
                    }

                    return Column(
                      children: [
                        Skeletonizer(
                          enabled: isLoading,
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: courses.length,
                            separatorBuilder: (_, __) => SizedBox(height: 10.h),
                            itemBuilder: (context, index) =>
                                _CourseCard(course: courses[index]),
                          ),
                        ),
                        if (state.hasMore) ...[
                          SizedBox(height: 16.h),
                          state.isLoadingMore
                              ? const CircularProgressIndicator()
                              : CustomButtonBorder(
                                  borderColor: AppColor.k1primeryColor,
                                  text: loc.load_more,
                                  onTap: () => context
                                      .read<CourseDiscoveryCubit>()
                                      .loadMore(),
                                ),
                        ],
                      ],
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

class _CourseCard extends StatelessWidget {
  final CourseModel course;
  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColor.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail — صورة الشبكة مع بديل عند فشل التحميل (404 مثلاً)
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: SizedBox(
              height: 192.h,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child:
                        (course.imageUrl != null && course.imageUrl!.isNotEmpty)
                            ? CachedNetworkImage(
                                imageUrl: course.imageUrl!,
                                fit: BoxFit.cover,
                                placeholder: (_, __) =>
                                    Container(color: AppColor.gray5),
                                errorWidget: (_, __, ___) => _thumbFallback(),
                              )
                            : _thumbFallback(),
                  ),
                  // شارة المستوى أعلى البداية
                  if (course.levelLabel != null)
                    Padding(
                      padding: EdgeInsets.all(12.r),
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Text(
                            course.levelLabel!,
                            style: MyTextStyle().textStyleRegular11().copyWith(
                              color: AppColor.k1primeryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Title + Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  course.title ?? '',
                  style: MyTextStyle().textStyleMedium16(),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                course.priceDisplay ?? course.price ?? '',
                style: MyTextStyle().textStyleSemiBold14().copyWith(
                  color: AppColor.k1primeryColor,
                ),
              ),
            ],
          ),
          // Category
          if (course.category != null) ...[
            SizedBox(height: 4.h),
            Text(
              course.category!.name,
              style: MyTextStyle().textStyleRegular11().copyWith(
                color: AppColor.gray2,
              ),
            ),
          ],
          DashedLine(),
          SizedBox(height: 8.h),
          Text(
            course.description ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: MyTextStyle().textStyleRegular14(),
          ),
          // Stats row
          SizedBox(height: 8.h),
          Row(
            children: [
              if (course.rating != null)
                _stat(
                  Icons.star_rounded,
                  course.rating!.toStringAsFixed(1),
                  Colors.amber,
                ),
              SizedBox(width: 12.w),
              if (course.lessonsCount != null)
                _stat(
                  Icons.play_circle_outline,
                  loc.lessons_count(course.lessonsCount!),
                ),
              SizedBox(width: 12.w),
              if (course.durationHours != null)
                _stat(Icons.access_time, loc.hours_count(course.durationHours!)),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: BlocBuilder<CourseEnrollCubit, CourseEnrollState>(
                  builder: (context, enrollState) {
                    final isEnrolling =
                        enrollState.loadingCourseId == course.id;
                    return CustomButton(
                      onTap: isEnrolling
                          ? () {}
                          : () => context.read<CourseEnrollCubit>().enroll(
                              course.id ?? 0,
                            ),
                      color: AppColor.k1primeryColor,
                      text: isEnrolling ? '...' : loc.buy_now,
                    );
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomButtonBorder(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DetailsCourseDiscoveryView(courseId: course.id ?? 0),
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
  }

  // بديل الصورة عند غيابها أو فشل تحميلها
  Widget _thumbFallback() {
    return Container(
      color: AppColor.gray5,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: AppColor.gray2,
        ),
      ),
    );
  }

  Widget _stat(IconData icon, String label, [Color? color]) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color ?? AppColor.gray2),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: color ?? AppColor.gray2),
        ),
      ],
    );
  }
}
