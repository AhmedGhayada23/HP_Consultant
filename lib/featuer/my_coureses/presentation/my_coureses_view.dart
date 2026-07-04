import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/my_courses_cubit/my_courses_cubit.dart';
import 'package:hb/core/cubit/my_courses_cubit/my_courses_state.dart';
import 'package:hb/core/data/models/my_coureses_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/custom_drawer_student.dart';
import 'package:hb/core/widgets/custom_progress.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/my_coureses/presentation/details_my_coureses_view.dart';
import 'package:hb/featuer/my_coureses/widgets/filtter_my_coureses_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/universal_downloader.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyCouresesView extends StatefulWidget {
  const MyCouresesView({super.key});

  @override
  State<MyCouresesView> createState() => _MyCouresesViewState();
}

class _MyCouresesViewState extends State<MyCouresesView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFiltterVisible = false;
  String _search = '';
  String? _selectedLevel;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    getMyCourses();
  }

  void getMyCourses() async {
    context.read<MyCoursesCubit>().fetchMyCourses();
  }

  // خيارات ثابتة: التسمية المعروضة (مترجمة) → القيمة الإنجليزية للفلترة
  Map<String, String> _levelOptions(AppLocalizations loc) => {
        loc.beginner: 'beginner',
        loc.intermediate: 'intermediate',
        loc.advanced: 'advanced',
      };
  Map<String, String> _statusOptions(AppLocalizations loc) => {
        loc.status_not_started: 'not_started',
        loc.status_in_progress: 'in_progress',
        loc.status_complete: 'completed',
      };

  List<MyCouresesModel> _applyFilters(List<MyCouresesModel> all) {
    return all.where((c) {
      final matchSearch = _search.isEmpty ||
          (c.title ?? '').toLowerCase().contains(_search.toLowerCase());
      // الفلترة بالقيمة الإنجليزية (levelRaw / status)
      final matchLevel = _selectedLevel == null || c.levelRaw == _selectedLevel;
      final matchStatus = _selectedStatus == null || c.status == _selectedStatus;
      return matchSearch && matchLevel && matchStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawerStudent(),
      appBar: CustomAppBar(
        title: loc.my_courses,
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
              SearchBoxWidget(
                hintText: loc.search_by_title,
                fillColor: AppColor.whiteColor,
                isFilterOpen: isFiltterVisible,
                onChanged: (value) => setState(() => _search = value),
                onTap: () => setState(() {
                  isFiltterVisible = !isFiltterVisible;
                }),
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
                    ? Builder(
                        key: const ValueKey("filter_open"),
                        builder: (context) {
                          final levelMap = _levelOptions(loc);
                          final statusMap = _statusOptions(loc);
                          // تسمية العرض للقيمة المختارة حالياً
                          String? selLevelLabel;
                          levelMap.forEach((label, value) {
                            if (value == _selectedLevel) selLevelLabel = label;
                          });
                          String? selStatusLabel;
                          statusMap.forEach((label, value) {
                            if (value == _selectedStatus) selStatusLabel = label;
                          });
                          return FiltterMyCouresesWidget(
                            levels: levelMap.keys.toList(),
                            statuses: statusMap.keys.toList(),
                            selectedLevel: selLevelLabel,
                            selectedStatus: selStatusLabel,
                            onLevelChanged: (label) => setState(() =>
                                _selectedLevel =
                                    label == null ? null : levelMap[label]),
                            onStatusChanged: (label) => setState(() =>
                                _selectedStatus =
                                    label == null ? null : statusMap[label]),
                          );
                        },
                      )
                    : SizedBox(key: ValueKey("filter_closed")),
              ),

              DashedLine(),
              SizedBox(height: 20.h),
              BlocBuilder<MyCoursesCubit, MyCoursesState>(
                builder: (context, state) {
                  final loading = state.loading ?? false;
                  final filtered = _applyFilters(state.data ?? []);
                  final data = loading
                      ? List.generate(3, (index) => MyCouresesModel())
                      : filtered;

                  if (!loading && filtered.isEmpty) {
                    return EmptyStateWidget(
                      title: loc.no_data_available,
                      icon: Icons.school_outlined,
                    );
                  }

                  return Skeletonizer(
                    enabled: state.loading ?? false,
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          _courseCard(context, data[index], loc),
                      separatorBuilder: (context, index) => SizedBox(height: 10.h),
                      itemCount: data.length,
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

  // فتح تفاصيل الدورة عند الضغط على الكارد
  void _openDetails(BuildContext context, MyCouresesModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailsMyCouresesView(
          courseId: int.tryParse(model.id ?? '') ?? 0,
        ),
      ),
    );
  }

  // تنزيل الشهادة (PDF محمي بالتوكن) ثم فتحها بعارض الجهاز — مثل تحميل السيرة الذاتية
  Future<void> _downloadCertificate(
      BuildContext context, MyCouresesModel model) async {
    final url = model.certificateUrl ?? '';
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

  // شارة حالة الدورة (In Progress / Complete / Not Started)
  String _statusLabel(AppLocalizations loc, String? status) {
    switch (status) {
      case 'completed':
        return loc.status_complete;
      case 'not_started':
        return loc.status_not_started;
      default:
        return loc.status_in_progress;
    }
  }

  // كارد الدورة — مطابق للتصميم: صورة بها شارة الحالة + العنوان + التقدّم + زر
  Widget _courseCard(
      BuildContext context, MyCouresesModel model, AppLocalizations loc) {
    final hasImage = model.imageUrl != null && model.imageUrl!.isNotEmpty;
    return InkWell(
      onTap: () => _openDetails(context, model),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppColor.whiteColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصورة + شارة الحالة أعلى البداية (مع بديل عند فشل التحميل/الغياب)
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: SizedBox(
                height: 192.h,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: hasImage
                          ? CachedNetworkImage(
                              imageUrl: model.imageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (_, __) =>
                                  Container(color: AppColor.gray5),
                              errorWidget: (_, __, ___) => _thumbFallback(),
                            )
                          : _thumbFallback(),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Text(
                            _statusLabel(loc, model.status),
                            style: MyTextStyle().textStyleMedium14().copyWith(
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
            SizedBox(height: 16.h),
            Text(
              model.title ?? '',
              style: MyTextStyle().textStyleSemiBold20(),
            ),
            SizedBox(height: 12.h),
            DashedLine(),
            SizedBox(height: 16.h),
            Text(
              loc.percent_complete(
                  ((model.progress ?? 0) * 100).toStringAsFixed(0)),
              style: MyTextStyle().textStyleMedium16(),
            ),
            SizedBox(height: 16.h),
            CustomProgress(progress: model.progress ?? 0),
            SizedBox(height: 20.h),
            // شهادة متوفرة → تنزيل الشهادة (زر ممتلئ) — غير ذلك → متابعة الدورة
            model.hasCertificate
                ? CustomButton(
                    onTap: () => _downloadCertificate(context, model),
                    color: AppColor.k1primeryColor,
                    text: loc.download_certificates,
                  )
                : CustomButtonBorder(
                    onTap: () => _openDetails(context, model),
                    borderColor: AppColor.k1primeryColor,
                    text: loc.continue_course,
                  ),
          ],
        ),
      ),
    );
  }
}
