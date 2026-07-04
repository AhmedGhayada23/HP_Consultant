import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/core/cubit/jobs_internship_cubit/jobs_internship_cubit.dart';
import 'package:hb/core/cubit/jobs_internship_cubit/jobs_internship_state.dart';
import 'package:hb/core/cubit/my_application_cubit/my_application_cubit.dart';
import 'package:hb/core/cubit/my_application_cubit/my_application_state.dart';
import 'package:hb/core/data/models/jobs_internship_model.dart';
import 'package:hb/core/data/models/my_application_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_student.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/career_opportunities/widgets/filtter_career_opportunities_widget.dart';
import 'package:hb/featuer/career_opportunities/widgets/jobs_internaship_card.dart';
import 'package:hb/featuer/career_opportunities/widgets/my_application_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CareerOpportunitiesView extends StatefulWidget {
  const CareerOpportunitiesView({super.key});

  @override
  State<CareerOpportunitiesView> createState() =>
      _CareerOpportunitiesViewState();
}

class _CareerOpportunitiesViewState extends State<CareerOpportunitiesView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int indexValue = 0;
  bool isFiltterVisible = false;

  // فلترة My Applications (client-side)
  String _appSearch = '';
  String? _appStatus;

  List<MyApplicationModel> _applyAppFilters(List<MyApplicationModel> all) {
    return all.where((a) {
      final matchSearch = _appSearch.isEmpty ||
          (a.title ?? '').toLowerCase().contains(_appSearch.toLowerCase());
      final matchStatus = _appStatus == null || a.status == _appStatus;
      return matchSearch && matchStatus;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    getJobsInternship();
    getMyApplication();
  }

  void getJobsInternship() async {
    context.read<JobsInternshipCubit>().fetchJobsInternship();
  }

  void getMyApplication() {
    context.read<MyApplicationCubit>().fetchMyApplications();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawerStudent(),
      appBar: CustomAppBar(
        title: loc.career_opportunities,
        onMenuTap: () {
          _scaffoldKey.currentState
              ?.openDrawer(); // ✅ فتح drawer باستخدام المفتاح
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
          child: Column(
            children: [
              SizedBox(
                height: 65.h,
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      setState(() {
                        indexValue = index;
                      });
                    },
                    child: Container(
                      width:
                          (MediaQuery.of(context).size.width -
                              16.w * 2 -
                              10.w) /
                          2, // 👈 give it a fixed width instead
                      height: 40.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        border: Border.all(
                          width: indexValue == index ? 0 : 1,
                          color: AppColor.blackColor,
                        ),
                        color: indexValue == index
                            ? AppColor.blackColor
                            : AppColor.whiteColor,
                      ),
                      child: Center(
                        child: Text(
                          index == 0
                              ? loc.jobs_and_internships
                              : loc.my_applications,
                          style: MyTextStyle().textStyleRegular14().copyWith(
                            color: indexValue == index
                                ? AppColor.whiteColor
                                : AppColor.blackColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) => SizedBox(width: 10.w),
                  itemCount: 2,
                ),
              ),
              DashedLine(),
              SizedBox(height: 20.h),
              // box saesh
              SearchBoxWidget(
                hintText: loc.search_by_title,
                fillColor: AppColor.whiteColor,
                isFilterOpen: isFiltterVisible,
                onChanged: (value) {
                  if (indexValue == 0) {
                    context.read<JobsInternshipCubit>().applySearch(value);
                  } else {
                    setState(() => _appSearch = value);
                  }
                },
                onTap: () {
                  setState(() {
                    isFiltterVisible = !isFiltterVisible;
                  });
                },
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(sizeFactor: animation, child: child),
                  );
                },
                child: !isFiltterVisible
                    ? SizedBox(key: ValueKey("filter_closed"))
                    : indexValue == 1
                        ? BlocBuilder<MyApplicationCubit, MyApplicationState>(
                            key: const ValueKey("filter_open"),
                            builder: (context, state) {
                              final statuses = (state.data ?? [])
                                  .map((a) => a.status)
                                  .whereType<String>()
                                  .where((s) => s.isNotEmpty)
                                  .toSet()
                                  .toList();
                              return FiltterCareerOpportunitiesWidget(
                                index: 1,
                                statuses: statuses,
                                selectedStatus: _appStatus,
                                onStatusChanged: (v) =>
                                    setState(() => _appStatus = v),
                              );
                            },
                          )
                        : FiltterCareerOpportunitiesWidget(
                            key: const ValueKey("filter_open"),
                            index: indexValue,
                          ),
              ),
              SizedBox(height: 20.h),
              _buildSelectedContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedContent() {
    switch (indexValue) {
      case 0:
        return BlocBuilder<JobsInternshipCubit, JobsInternshipState>(
          builder: (context, state) {
            final loading = state.loading ?? false;
            final data =
                state.data ??
                List.generate(3, (index) => JobsInternshipModel());

            if (!loading && (state.data?.isEmpty ?? false)) {
              return EmptyStateWidget(
                title: AppLocalizations.of(context)!.no_data_available,
                icon: Icons.work_off_outlined,
              );
            }

            return Skeletonizer(
              enabled: loading,
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return JobsInternashipCard(jobsInternshipModel: data[index]);
                },
                separatorBuilder: (context, index) => SizedBox(height: 10.h),
                itemCount: data.length,
              ),
            );
          },
        );

      case 1:
        return BlocBuilder<MyApplicationCubit, MyApplicationState>(
          builder: (context, state) {
            final loading = state.loading ?? false;
            final filtered = _applyAppFilters(state.data ?? []);
            final data = loading
                ? List.generate(3, (index) => MyApplicationModel())
                : filtered;

            if (!loading && filtered.isEmpty) {
              return EmptyStateWidget(
                title: AppLocalizations.of(context)!.no_data_available,
                icon: Icons.assignment_outlined,
              );
            }

            return ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Skeletonizer(
                  enabled: loading,
                  child: MyApplicationCard(myApplicationModel: data[index]),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 10.h),
              itemCount: data.length,
            );
          },
        );

      default:
        return SizedBox();
    }
  }
}
