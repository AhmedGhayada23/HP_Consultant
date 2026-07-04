import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/recommended_jos_cubit/recommended_jos_cubit.dart';
import 'package:hb/core/cubit/recommended_jos_cubit/recommended_jos_state.dart';
import 'package:hb/core/data/models/recommended_jos_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_consultant.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/jobs_marketplace/presentation/apple_now_job_view.dart';
import 'package:hb/featuer/jobs_marketplace/presentation/details_jobs_marketplace_view.dart';
import 'package:hb/featuer/jobs_marketplace/widgets/filtter_jobs_marketplace_widget.dart';
import 'package:hb/featuer/jobs_marketplace/widgets/job_marketplace_card_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class JobsMarketplaceView extends StatefulWidget {
  const JobsMarketplaceView({super.key});

  @override
  State<JobsMarketplaceView> createState() => _JobsMarketplaceViewState();
}

class _JobsMarketplaceViewState extends State<JobsMarketplaceView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  bool isFiltterVisible = false;
  String _searchQuery = '';
  Map<String, dynamic> _filters = {};

  @override
  void initState() {
    super.initState();
    context.read<RecommendedJosCubit>().fetchRecommendedJos();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<RecommendedJosCubit>().loadMore();
    }
  }

  void _onSearch(String value) {
    _searchQuery = value;
    context.read<RecommendedJosCubit>().fetchRecommendedJos(
          search: value,
          filters: _filters,
        );
  }

  void _onFilterChanged(Map<String, dynamic> filters) {
    _filters = filters;
    context.read<RecommendedJosCubit>().fetchRecommendedJos(
          search: _searchQuery,
          filters: filters,
        );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawerConsultant(),
      appBar: CustomAppBar(
        title: loc.jobs_marketplace,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: RefreshIndicator(
        onRefresh: () => context
            .read<RecommendedJosCubit>()
            .fetchRecommendedJos(search: _searchQuery, filters: _filters),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
            child: Column(
              children: [
                SearchBoxWidget(
                  hintText: loc.search_jobs_placeholder,
                  fillColor: AppColor.whiteColor,
                  isFilterOpen: isFiltterVisible,
                  onChanged: _onSearch,
                  onTap: () {
                    setState(() => isFiltterVisible = !isFiltterVisible);
                  },
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SizeTransition(sizeFactor: animation, child: child),
                  ),
                  child: isFiltterVisible
                      ? FiltterJobsMarketplaceWidget(
                          key: const ValueKey('filter_open'),
                          onChanged: _onFilterChanged,
                        )
                      : const SizedBox(key: ValueKey('filter_closed')),
                ),
                DashedLine(),
                SizedBox(height: 20.h),

                BlocBuilder<RecommendedJosCubit, RecommendedJosState>(
                  builder: (context, state) {
                    // ── Error state ─────────────────────────────────────────
                    if (state.errorMessage != null && !state.loading) {
                      return EmptyStateWidget(
                        title: loc.failed_to_load_jobs,
                        subtitle: state.errorMessage,
                        icon: Icons.cloud_off_outlined,
                        actionButtonText: loc.retry,
                        onActionPressed: () => context
                            .read<RecommendedJosCubit>()
                            .fetchRecommendedJos(
                              search: _searchQuery,
                              filters: _filters,
                            ),
                      );
                    }

                    final fakeData =
                        List.generate(3, (_) => RecommendedJobModel.fake());
                    final jobs =
                        state.loading ? fakeData : state.data;

                    // ── Empty state ──────────────────────────────────────────
                    if (jobs.isEmpty && !state.loading) {
                      return EmptyStateWidget(
                        title: loc.no_jobs_found,
                        subtitle: _searchQuery.isNotEmpty
                            ? 'No results for "$_searchQuery". Try a different keyword.'
                            : 'There are no available jobs at the moment.',
                        icon: Icons.work_off_outlined,
                      );
                    }

                    // ── List ─────────────────────────────────────────────────
                    return Skeletonizer(
                      enabled: state.loading,
                      child: Column(
                        children: [
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: jobs.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: 10.h),
                            itemBuilder: (context, index) {
                              final job = jobs[index];
                              return JobMarketplaceCardWidget(
                                category: job.category ?? job.jobTypeLabel ?? '',
                                title: job.title ?? '',
                                company: job.company ?? '',
                                budget: job.budget ?? '',
                                deadline: job.deadline ?? '',
                                onApply: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AppleNowJobView(recommendedJobModel: job),
                                  ),
                                ),
                                onViewDetails: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailsJobsMarketplaceView(
                                        recommendedJobModel: job),
                                  ),
                                ),
                              );
                            },
                          ),

                          // ── Load more indicator ──────────────────────────
                          if (state.loadingMore)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: const CircularProgressIndicator(),
                            ),

                          if (!state.hasMore && jobs.isNotEmpty && !state.loading)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: Text(
                                '${loc.all} ${state.total} ${loc.jobs_talent}',
                                style: TextStyle(
                                  color: AppColor.gray4,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                        ],
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
