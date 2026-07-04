import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/job_and_talent_cubit/job_and_talent_cubit.dart';
import 'package:hb/core/cubit/job_and_talent_cubit/job_and_talent_state.dart';
import 'package:hb/core/data/models/jobs_model.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_company.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/featuer/jobs_and_talent/widgets/btn_new_post_widget.dart';
import 'package:hb/featuer/jobs_and_talent/widgets/card_job_widget.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/jobs_and_talent/widgets/filter_job_talent_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class JobAndTalentView extends StatefulWidget {
  const JobAndTalentView({super.key});

  @override
  State<JobAndTalentView> createState() => _JobAndTalentViewState();
}

class _JobAndTalentViewState extends State<JobAndTalentView> {
  bool isFilterOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getJobs();
  }

  Future<void> getJobs() {
    return context.read<JobAndTalentCubit>().fetchJobsAndTalent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawerCompany(),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.jobs_talent,
        onMenuTap: () {
          _scaffoldKey.currentState
              ?.openDrawer(); // ✅ فتح drawer باستخدام المفتاح
        },
      ),

      bottomNavigationBar: BtnNewPostWidget(
        onTap: () => Navigator.pushNamed(context, MyRoutes().newJobView),
      ),
      body: RefreshIndicator(
        color: AppColor.blackColor,
        onRefresh: getJobs,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),

          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // box saesh
                SearchBoxWidget(
                  hintText: AppLocalizations.of(
                    context,
                  )!.search_jobs_placeholder,
                  fillColor: AppColor.whiteColor,
                  isFilterOpen: isFilterOpen,
                  onChanged: (value) => context
                      .read<JobAndTalentCubit>()
                      .fetchJobsAndTalent(name: value),
                  onTap: () {
                    setState(() {
                      isFilterOpen = !isFilterOpen;
                    });
                  },
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        child: child,
                      ),
                    );
                  },
                  child: isFilterOpen
                      ? FilterJobTalentWidget(key: ValueKey("filter_open"))
                      : SizedBox(key: ValueKey("filter_closed")),
                ),

                DashedLine(),
                SizedBox(height: 20.h),

                // jobs card
                BlocBuilder<JobAndTalentCubit, JobAndTalentState>(
                  builder: (context, state) {
                    if (state.loading == true) {
                      final data = List.generate(
                        3,
                        (index) => JobsModel.fack(),
                      );
                      return Skeletonizer(
                        enabled: true,
                        child: ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) =>
                              CardJobWidget(jobModel: data[index]),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10.h),
                          itemCount: data.length,
                        ),
                      );
                    } else if (state.jobData!.isNotEmpty) {
                      return ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final data = state.jobData![index];
                          return CardJobWidget(jobModel: data);
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10.h),
                        itemCount: state.jobData!.length,
                      );
                    } else {
                      return EmptyStateWidget(
                        title: AppLocalizations.of(context)!.no_jobs_available,
                        subtitle: AppLocalizations.of(
                          context,
                        )!.start_posting_jobs,
                        icon: Icons.work_outline,
                        actionButtonText: AppLocalizations.of(
                          context,
                        )!.post_new_job,
                      );
                    }
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
