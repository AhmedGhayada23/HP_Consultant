import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/jobs_internship_cubit/jobs_internship_cubit.dart';
import 'package:hb/core/cubit/jobs_internship_cubit/jobs_internship_state.dart';
import 'package:hb/core/data/models/jobs_internship_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_visitor.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/career_opportunities/widgets/filtter_career_opportunities_widget.dart';
import 'package:hb/featuer/career_opportunities/widgets/jobs_internaship_card.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VisitorCareerOpportunities extends StatefulWidget {
  const VisitorCareerOpportunities({super.key});

  @override
  State<VisitorCareerOpportunities> createState() => _VisitorCareerOpportunitiesState();
}

class _VisitorCareerOpportunitiesState extends State<VisitorCareerOpportunities> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFiltterVisible = false;

  @override
  void initState() {
    super.initState();
    getJobsInternship();
  }

  void getJobsInternship() async {
    context.read<JobsInternshipCubit>().fetchJobsInternship();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocBuilder<JobsInternshipCubit, JobsInternshipState>(
      builder: (context, state) {
        final data = state.data ?? List.generate(3, (index) => JobsInternshipModel());
        return Skeletonizer(
          enabled: state.loading ?? false,
          child: Scaffold(
            key: _scaffoldKey,
            drawer: const CustomDrawerVisitor(),
            appBar: CustomAppBar(
              title: loc.career_opportunities,
              onMenuTap: () {
                _scaffoldKey.currentState?.openDrawer(); // ✅ فتح drawer باستخدام المفتاح
              },
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
                child: Column(
                  children: [
                    // box saesh
                    SearchBoxWidget(
                      hintText: loc.search_by_title,
                      fillColor: AppColor.whiteColor,
                      isFilterOpen: isFiltterVisible,
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
                          ? FiltterCareerOpportunitiesWidget(key: ValueKey("filter_open"),index: 0,)
                          : SizedBox(key: ValueKey("filter_closed")),
                    ),
                    SizedBox(height: 20.h),
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return JobsInternashipCard(jobsInternshipModel: data[index]);
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 10.h),
                      itemCount: data.length,
                    ),
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
