import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/job_project_cubit/job_project_cubit.dart';
import 'package:hb/core/cubit/job_project_cubit/job_project_state.dart';
import 'package:hb/core/data/models/job_project_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_consultant.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/jobs_projects/presentation/details_job_project_view.dart';
import 'package:hb/featuer/jobs_projects/widgets/filtter_job_project_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class JobsProjectsView extends StatefulWidget {
  const JobsProjectsView({super.key});

  @override
  State<JobsProjectsView> createState() => _JobsProjectsViewState();
}

class _JobsProjectsViewState extends State<JobsProjectsView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFiltterVisible = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<JobProjectCubit>().fetchJobProject();
  }

  void _onSearch(String value) {
    _searchQuery = value;
    context.read<JobProjectCubit>().fetchJobProject(search: value);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawerConsultant(),
      appBar: CustomAppBar(
        title: loc.jobs_projects,
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<JobProjectCubit>().fetchJobProject(
          search: _searchQuery,
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
            child: Column(
              children: [
                // box search
                SearchBoxWidget(
                  hintText: loc.search_by_title,
                  fillColor: AppColor.whiteColor,
                  isFilterOpen: isFiltterVisible,
                  onChanged: _onSearch,
                  onTap: () => setState(() {
                    isFiltterVisible = !isFiltterVisible;
                  }),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        child: child,
                      ),
                    );
                  },
                  child: isFiltterVisible
                      ? const FiltterJobProjectWidget(
                          key: ValueKey("filter_open"),
                        )
                      : const SizedBox(key: ValueKey("filter_closed")),
                ),

                DashedLine(),
                SizedBox(height: 20.h),

                BlocBuilder<JobProjectCubit, JobProjectState>(
                  builder: (context, state) {
                    final isLoading = state.loading ?? false;

                    // ── Error state ──────────────────────────────────────
                    if (state.errorMessage != null && !isLoading) {
                      return EmptyStateWidget(
                        title: loc.failed_to_load_jobs,
                        subtitle: state.errorMessage,
                        icon: Icons.cloud_off_outlined,
                        actionButtonText: loc.retry,
                        onActionPressed: () => context
                            .read<JobProjectCubit>()
                            .fetchJobProject(search: _searchQuery),
                      );
                    }

                    final data = isLoading
                        ? List.generate(3, (_) => JobProjectModel())
                        : (state.data ?? []);

                    // ── Empty state ──────────────────────────────────────
                    if (data.isEmpty && !isLoading) {
                      return EmptyStateWidget(
                        title: loc.no_data_available,
                        subtitle: _searchQuery.isNotEmpty
                            ? loc.no_results_for(_searchQuery)
                            : loc.no_available_jobs,
                        icon: Icons.work_off_outlined,
                      );
                    }

                    return Skeletonizer(
                      enabled: isLoading,
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        separatorBuilder: (_, __) => SizedBox(height: 10.h),
                        itemBuilder: (context, index) {
                          final job = data[index];
                          return InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailsJobProjectView(jobProjectModel: job),
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadiusDirectional.circular(
                                  16.r,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    job.title ?? '',
                                    style: MyTextStyle().textStyleSemiBold16(),
                                  ),
                                  DashedLine(),
                                  SizedBox(height: 20.h),
                                  InfoRow(
                                    label: '${loc.company}: ',
                                    value: job.company ?? '',
                                  ),
                                  SizedBox(height: 20.h),
                                  InfoRow(
                                    label: '${loc.deadline}:',
                                    value: job.deadline ?? '',
                                  ),
                                  SizedBox(height: 20.h),
                                  InfoRow(
                                    label: '${loc.status}: ',
                                    value: job.status ?? '',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
