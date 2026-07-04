import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/my_course_details_cubit/my_course_details_cubit.dart';
import 'package:hb/core/cubit/my_course_details_cubit/my_course_details_state.dart';
import 'package:hb/core/data/models/my_course_details_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/custom_progress.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/featuer/my_coureses/widgets/course_overview.dart';
import 'package:hb/featuer/my_coureses/widgets/resources.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/universal_downloader.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailsMyCouresesView extends StatefulWidget {
  final int courseId;
  const DetailsMyCouresesView({super.key, required this.courseId});

  @override
  State<DetailsMyCouresesView> createState() => _DetailsMyCouresesViewState();
}

class _DetailsMyCouresesViewState extends State<DetailsMyCouresesView> {
  int _selectedTab = 0; // 0 = Course Overview, 1 = Resources

  @override
  void initState() {
    super.initState();
    context.read<MyCourseDetailsCubit>().fetchMyCourseDetails(widget.courseId);
  }

  Widget getSelectedSection(MyCourseDetailsModel? data) {
    if (_selectedTab == 1) {
      final materials = (data?.modules ?? [])
          .expand((m) => m.lessons)
          .expand((l) => l.materials)
          .toList();
      return Resources(materials: materials);
    }
    return CourseOverview(
      course: data?.course,
      modules: data?.modules ?? const [],
    );
  }

  // زر تنزيل الشهادة — يظهر فقط عند توفّر شهادة (certificate != null)
  Widget? getBottomNavigationBar(
      AppLocalizations loc, MyCourseDetailsModel? data) {
    if (data == null || !data.hasCertificate) return null;
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        boxShadow: [
          BoxShadow(color: AppColor.borderColor, offset: Offset(0, -3)),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      child: CustomButton(
        onTap: () => _downloadCertificate(context, data.certificateUrl!),
        color: AppColor.k1primeryColor,
        text: loc.download_certificates,
        icons: Icon(Icons.download_rounded,
            size: 18.r, color: AppColor.whiteColor),
      ),
    );
  }

  // تنزيل الشهادة (PDF محمي بالتوكن) ثم فتحها بعارض الجهاز — مثل تحميل السيرة الذاتية
  Future<void> _downloadCertificate(BuildContext context, String url) async {
    if (url.isEmpty) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final status = await UniversalDownloader().downloadAndOpen(url: url);
      if (!context.mounted) return;
      Navigator.pop(context); // إغلاق مؤشّر التحميل
      final loc = AppLocalizations.of(context)!;
      switch (status) {
        case DownloadOpenStatus.downloadFailed:
          showCustomSnackBar(context, loc.download_failed, SnackBarType.error);
          break;
        case DownloadOpenStatus.downloadedNotOpened:
          showCustomSnackBar(
              context, loc.downloaded_no_viewer, SnackBarType.warning);
          break;
        case DownloadOpenStatus.opened:
          break;
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      showCustomSnackBar(
        context,
        e.toString().replaceFirst('Exception: ', ''),
        SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocBuilder<MyCourseDetailsCubit, MyCourseDetailsState>(
      builder: (context, state) {
        final loading = state.loading;
        final data = state.data;
        final progress = data?.enrollment?.progress ?? 0;

        return Skeletonizer(
          enabled: loading,
          child: Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: AppColor.whiteColor),
              backgroundColor: AppColor.blackColor,
              title: Text(
                data?.course?.title ?? loc.course_details,
                style: MyTextStyle()
                    .textStyleSemiBold20()
                    .copyWith(color: AppColor.whiteColor),
              ),
            ),
            bottomNavigationBar: getBottomNavigationBar(loc, data),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 250.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: AppColor.gray5,
                        image: (data?.course?.thumbnailUrl != null &&
                                data!.course!.thumbnailUrl!.isNotEmpty)
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(data.course!.thumbnailUrl!),
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}% Complete',
                      style: MyTextStyle().textStyleMedium16(),
                    ),
                    SizedBox(height: 16.h),
                    CustomProgress(progress: progress),
                    SizedBox(height: 24.h),
                    CustomDropdown(
                      onChanged: (value) {
                        setState(() {
                          _selectedTab = value == loc.resources ? 1 : 0;
                        });
                      },
                      hint: _selectedTab == 1 ? loc.resources : loc.course_overview,
                      items: [loc.course_overview, loc.resources],
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      _selectedTab == 1 ? loc.resources : loc.course_overview,
                      style: MyTextStyle().textStyleSemiBold20(),
                    ),
                    DashedLine(),
                    SizedBox(height: 20.h),
                    getSelectedSection(data),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
