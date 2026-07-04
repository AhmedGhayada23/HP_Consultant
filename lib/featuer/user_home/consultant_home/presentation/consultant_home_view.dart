import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/consultant_dashboard_cubit/consultant_dashboard_cubit.dart';
import 'package:hb/core/cubit/consultant_dashboard_cubit/consultant_dashboard_state.dart';
import 'package:hb/core/data/models/consultant_dashboard_model.dart';
import 'package:hb/core/data/models/recommended_jos_model.dart';
import 'package:hb/core/data/models/job_project_model.dart';
import 'package:hb/featuer/jobs_marketplace/presentation/details_jobs_marketplace_view.dart';
import 'package:hb/featuer/jobs_projects/presentation/details_job_project_view.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_consultant.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/featuer/user_home/consultant_home/widgets/dashboard_card_consultant.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ConsultantHomeView extends StatefulWidget {
  const ConsultantHomeView({super.key});

  @override
  State<ConsultantHomeView> createState() => _ConsultantHomeViewState();
}

class _ConsultantHomeViewState extends State<ConsultantHomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<ConsultantDashboardCubit>().fetchDashboard();
  }

  // لون الحالة حسب قيمتها
  Color _statusColor(String? status) {
    final s = (status ?? '').toLowerCase();
    if (s.contains('progress')) return AppColor.k1primeryColor;
    if (s.contains('open') || s.contains('complete') || s.contains('active')) {
      return const Color(0xff2E7D32);
    }
    if (s.contains('pending') || s.contains('review')) {
      return const Color(0xffE5A000);
    }
    if (s.contains('cancel') || s.contains('reject') || s.contains('closed')) {
      return AppColor.countNotificationBgColor;
    }
    return AppColor.uploadImageColor;
  }

  // شارة ملوّنة (status / label)
  Widget _badge(String text, {Color? color}) {
    final c = color ?? AppColor.uploadImageColor;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        text,
        style: MyTextStyle().textStyleMedium12().copyWith(color: c),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawerConsultant(),
      appBar: CustomAppBar(
        title: loc.dashboard,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: BlocBuilder<ConsultantDashboardCubit, ConsultantDashboardState>(
        builder: (context, state) {
          final isLoading = state.loading;
          final stats = state.data?.stats ?? ConsultantDashboardStats.fake();
          final List<DashboardRecommendedJob> jobs =
              state.data?.recommendedJobs ??
                  (isLoading
                      ? List.generate(3, (_) => DashboardRecommendedJob.fake())
                      : <DashboardRecommendedJob>[]);
          final List<DashboardActiveProject> projects =
              state.data?.activeProjects ??
                  (isLoading
                      ? List.generate(2, (_) => DashboardActiveProject.fake())
                      : <DashboardActiveProject>[]);

          if (state.errorMessage != null && !isLoading) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: EmptyStateWidget(
                  title: loc.failed_to_load_dashboard,
                  subtitle: state.errorMessage,
                  icon: Icons.cloud_off_outlined,
                  actionButtonText: loc.retry,
                  onActionPressed: () =>
                      context.read<ConsultantDashboardCubit>().fetchDashboard(),
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: AppColor.k1primeryColor,
            onRefresh: () =>
                context.read<ConsultantDashboardCubit>().fetchDashboard(),
            child: Skeletonizer(
              enabled: isLoading,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Stats cards ──────────────────────────────────────
                    _statsGrid(loc, stats),

                    // ── Recommended Jobs ─────────────────────────────────
                    SizedBox(height: 32.h),
                    Text(loc.recommended_jobs_for_you,
                        style: MyTextStyle().textStyleSemiBold16()),
                    SizedBox(height: 10.h),
                    if (jobs.isEmpty && !isLoading)
                      EmptyStateWidget(
                        title: loc.no_recommended_jobs,
                        subtitle: loc.no_recommended_jobs_subtitle,
                        icon: Icons.work_outline,
                      )
                    else
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: jobs.length,
                        separatorBuilder: (_, __) => SizedBox(height: 10.h),
                        itemBuilder: (context, index) =>
                            _jobCard(loc, jobs[index], isLoading),
                      ),

                    // ── Active Projects ──────────────────────────────────
                    SizedBox(height: 32.h),
                    Text(loc.active_projects,
                        style: MyTextStyle().textStyleSemiBold16()),
                    SizedBox(height: 10.h),
                    if (projects.isEmpty && !isLoading)
                      EmptyStateWidget(
                        title: loc.no_active_projects,
                        subtitle: loc.no_active_projects_subtitle,
                        icon: Icons.folder_open_outlined,
                      )
                    else
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: projects.length,
                        separatorBuilder: (_, __) => SizedBox(height: 10.h),
                        itemBuilder: (context, index) =>
                            _projectCard(loc, projects[index], isLoading),
                      ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Stats (4 بطاقات) ───────────────────────────────────────────────────
  Widget _statsGrid(AppLocalizations loc, ConsultantDashboardStats stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DashboardCardConsultant(
                count: '${stats.activeProjectsCount} ${loc.projects}',
                label: loc.active_projects,
                iconPath: AppSvg.pepolsSvg,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: DashboardCardConsultant(
                count: '${stats.pendingApplicationsCount}',
                label: loc.pending_applications,
                iconPath: AppSvg.projects2Svg,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: DashboardCardConsultant(
                count: stats.monthlyEarningsFormatted,
                label: loc.earnings_this_month,
                iconPath: AppSvg.menySvg,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: DashboardCardConsultant(
                count: '${stats.ideasSubmittedCount} ${loc.ideas}',
                label: loc.hb_lab_activity,
                iconPath: AppSvg.infoSvg,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── بطاقة وظيفة موصى بها ────────────────────────────────────────────────
  Widget _jobCard(
      AppLocalizations loc, DashboardRecommendedJob job, bool isLoading) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: (isLoading || job.id == 0)
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailsJobsMarketplaceView(
                    recommendedJobModel: RecommendedJobModel(
                      id: job.id,
                      title: job.title,
                      category: job.category,
                      company: job.companyName,
                      deadline: job.deadlineDisplay,
                      budget: job.budgetDisplay,
                      jobTypeLabel: job.jobTypeLabel,
                      statusLabel: job.statusLabel,
                      descriptionExcerpt: job.descriptionExcerpt,
                    ),
                  ),
                ),
              ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // النوع + الحالة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (job.jobTypeLabel.isNotEmpty)
                  _badge(job.jobTypeLabel)
                else
                  const SizedBox.shrink(),
                if (job.statusLabel.isNotEmpty)
                  _badge(job.statusLabel, color: _statusColor(job.statusLabel)),
              ],
            ),
            SizedBox(height: 12.h),
            Text(job.title, style: MyTextStyle().textStyleSemiBold14()),
            SizedBox(height: 6.h),
            // الشركة + التصنيف
            Text(
              [job.companyName, job.category]
                  .where((e) => e != null && e.isNotEmpty)
                  .join(' • '),
              style: MyTextStyle()
                  .textStyleMedium14()
                  .copyWith(color: AppColor.gray2),
            ),
            if (job.descriptionExcerpt.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                job.descriptionExcerpt,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: MyTextStyle()
                    .textStyleRegular14()
                    .copyWith(color: AppColor.gray2),
              ),
            ],
            if (job.skills.isNotEmpty) ...[
              SizedBox(height: 10.h),
              Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: job.skills
                    .map((s) => Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColor.gray5,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(s,
                              style: MyTextStyle().textStyleRegular11()),
                        ))
                    .toList(),
              ),
            ],
            DashedLine(),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                    child: _labeled(loc.deadline, job.deadlineDisplay)),
                Expanded(child: _labeled(loc.budget, job.budgetDisplay)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── بطاقة مشروع نشط ─────────────────────────────────────────────────────
  Widget _projectCard(
      AppLocalizations loc, DashboardActiveProject project, bool isLoading) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: (isLoading || project.id == 0)
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailsJobProjectView(
                    jobProjectModel: JobProjectModel(
                      id: project.id,
                      title: project.title,
                      deadline: project.deadlineDisplay,
                      status: project.statusLabel,
                      budget: project.budgetDisplay,
                      category: project.category,
                    ),
                  ),
                ),
              ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان + الحالة
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(project.title,
                      style: MyTextStyle().textStyleSemiBold14()),
                ),
                if (project.statusLabel != null)
                  _badge(project.statusLabel!,
                      color: _statusColor(project.statusLabel)),
              ],
            ),
            SizedBox(height: 6.h),
            // المرجع + التصنيف
            Text(
              [project.requestReference, project.category]
                  .where((e) => e != null && e.isNotEmpty)
                  .join(' • '),
              style: MyTextStyle()
                  .textStyleRegular11()
                  .copyWith(color: AppColor.gray2),
            ),
            DashedLine(),
            SizedBox(height: 12.h),
            // الميزانية + المعلم القادم
            Row(
              children: [
                Expanded(child: _labeled(loc.budget, project.budgetDisplay)),
                Expanded(
                  child: _labeled(
                    loc.next_milestone,
                    project.nextMilestoneTitle,
                    sub: project.nextMilestoneDueDisplay,
                  ),
                ),
              ],
            ),
            // تقدّم المعالم
            if (project.totalMilestones > 0) ...[
              SizedBox(height: 14.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(loc.milestones,
                      style: MyTextStyle().textStyleMedium14()),
                  Text(
                    '${project.completedMilestones} ${loc.of_count} ${project.totalMilestones}',
                    style: MyTextStyle()
                        .textStyleMedium14()
                        .copyWith(color: AppColor.gray2),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: LinearProgressIndicator(
                  value: project.progress,
                  minHeight: 8.h,
                  backgroundColor: AppColor.gray5,
                  valueColor:
                      AlwaysStoppedAnimation(AppColor.k1primeryColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // عنصر "عنوان فوق + قيمة تحت" مع سطر فرعي اختياري
  Widget _labeled(String label, String? value, {String? sub}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: MyTextStyle().textStyleMedium14()),
        SizedBox(height: 4.h),
        Text(value == null || value.isEmpty ? '—' : value,
            style: MyTextStyle().textStyleMedium15()),
        if (sub != null && sub.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Text(sub,
                style: MyTextStyle()
                    .textStyleRegular11()
                    .copyWith(color: AppColor.gray2)),
          ),
      ],
    );
  }
}
