import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/dashboard_campany_cubit/dashboard_campany_cubit.dart';
import 'package:hb/core/cubit/dashboard_campany_cubit/dashboard_campany_state.dart';
import 'package:hb/core/data/models/active_project_model.dart';
import 'package:hb/core/data/models/dashboard_campany_model.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/featuer/consultant_project/presentation/project_details_view.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_company.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/featuer/user_home/company_home/widgets/dashboard_card.dart';
import 'package:hb/featuer/user_home/company_home/widgets/payment_card.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CompanyHomeView extends StatefulWidget {
  const CompanyHomeView({super.key});

  @override
  State<CompanyHomeView> createState() => _CompanyHomeViewState();
}

class _CompanyHomeViewState extends State<CompanyHomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getDashboardCompany();
  }

  Future<void> getDashboardCompany() async {
    await context.read<DashboardCampanyCubit>().fetchDashboardCampany();
  }

  Color _statusColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'purple':
        return const Color(0xFF7C3AED);
      case 'green':
        return const Color(0xFF009F10);
      case 'red':
        return const Color(0xFFFF0000);
      case 'blue':
        return const Color(0xFF2563EB);
      case 'orange':
        return const Color(0xFFF97316);
      case 'yellow':
        return const Color(0xFFEAB308);
      default:
        return AppColor.k1primeryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawerCompany(),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.dashboard,
        onMenuTap: () {
          _scaffoldKey.currentState
              ?.openDrawer(); // ✅ فتح drawer باستخدام المفتاح
        },
      ),
      body: RefreshIndicator(
        color: AppColor.k1primeryColor,
        onRefresh: getDashboardCompany,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<DashboardCampanyCubit, DashboardCampanyState>(
                  builder: (context, state) {
                    if (state.isLoading == true ||
                        state.dashboardCampanyModel == null &&
                            state.errorMessage == null) {
                      final data = KeyMetrics.fack();
                      return Skeletonizer(
                        enabled: true,
                        child: Row(
                          children: [
                            Expanded(
                              child: DashboardCard(
                                count: data.activeProjects.toString(),
                                label: AppLocalizations.of(
                                  context,
                                )!.active_projects,
                                iconPath: AppSvg.projects2Svg,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: DashboardCard(
                                count: data.activeConsultants.toString(),
                                label: AppLocalizations.of(
                                  context,
                                )!.active_consultants,
                                iconPath: AppSvg.pepolsSvg,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state.errorMessage != null &&
                        state.dashboardCampanyModel == null) {
                      return const SizedBox();
                    } else {
                      final data = state.dashboardCampanyModel!.keyMetrics;
                      return Row(
                        children: [
                          Expanded(
                            child: DashboardCard(
                              count: '${data.activeProjects}',
                              label: AppLocalizations.of(
                                context,
                              )!.active_projects,
                              iconPath: AppSvg.projects2Svg,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: DashboardCard(
                              count: '${data.activeConsultants}',
                              label: AppLocalizations.of(
                                context,
                              )!.active_consultants,
                              iconPath: AppSvg.pepolsSvg,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(height: 10.h),
                BlocBuilder<DashboardCampanyCubit, DashboardCampanyState>(
                  builder: (context, state) {
                    if (state.isLoading == true ||
                        state.dashboardCampanyModel == null &&
                            state.errorMessage == null) {
                      final data = KeyMetrics.fack();
                      return Skeletonizer(
                        enabled: true,
                        child: Row(
                          children: [
                            Expanded(
                              child: DashboardCard(
                                count: data.pendingApplications.toString(),
                                label: AppLocalizations.of(
                                  context,
                                )!.pending_applications,
                                iconPath: AppSvg.pendingApplicationsSvg,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: DashboardCard(
                                count: data.upcomingDeadlines.toString(),
                                label: AppLocalizations.of(
                                  context,
                                )!.upcoming_deadlines,
                                iconPath: AppSvg.upcomingDeadlinesSvg,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state.errorMessage != null &&
                        state.dashboardCampanyModel == null) {
                      return const SizedBox();
                    } else {
                      final data = state.dashboardCampanyModel!.keyMetrics;
                      return Row(
                        children: [
                          Expanded(
                            child: DashboardCard(
                              count: '${data.pendingApplications}',
                              label: AppLocalizations.of(
                                context,
                              )!.pending_applications,
                              iconPath: AppSvg.pendingApplicationsSvg,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: DashboardCard(
                              count: '${data.upcomingDeadlines}',
                              label: AppLocalizations.of(
                                context,
                              )!.upcoming_deadlines,
                              iconPath: AppSvg.upcomingDeadlinesSvg,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),

                // Recent Invoices
                // SizedBox(height: 32.h),
                // Text(
                //   AppLocalizations.of(context)!.recent_invoices,
                //   style: MyTextStyle().textStyleSemiBold16(),
                // ),
                // SizedBox(height: 12.h),
                // BlocBuilder<DashboardCampanyCubit, DashboardCampanyState>(
                //   builder: (context, state) {
                //     if (state.isLoading == true) {
                //       final recentInvoicesData = List.generate(3, (index) => RecentInvoices.fack());
                //       return Column(
                //         children: List.generate(
                //           recentInvoicesData.length,
                //           (index) => Padding(
                //             padding: EdgeInsets.only(bottom: 8.h),
                //             child: Skeletonizer(
                //               enabled: true,
                //               child: PaymentCard(
                //                 title: recentInvoicesData[index].title,
                //                 date: recentInvoicesData[index].date,
                //                 amount: recentInvoicesData[index].amount,
                //                 status: recentInvoicesData[index].status,
                //                 statusColor: AppColor.borderColor,
                //               ),
                //             ),
                //           ),
                //         ),
                //       );
                //     } else if (state.dashboardCampanyModel!.recentInvoices.isNotEmpty) {
                //       final recentInvoicesData = state.dashboardCampanyModel!.recentInvoices;
                //       return Column(
                //         children: List.generate(
                //           recentInvoicesData.length,
                //           (index) => Padding(
                //             padding: EdgeInsets.only(bottom: 8.h),
                //             child: PaymentCard(
                //               title: recentInvoicesData[index].title,
                //               date: recentInvoicesData[index].date,
                //               amount: recentInvoicesData[index].amount,
                //               status: recentInvoicesData[index].status,
                //               statusColor: recentInvoicesData[index].statusId == 1
                //                   ? Color(0xff009F10)
                //                   : recentInvoicesData[index].statusId == 2
                //                   ? Color(0xffFF0000)
                //                   : Color(0xff000C21),
                //             ),
                //           ),
                //         ),
                //       );
                //     } else {
                //       return EmptyStateWidget(
                //         title: AppLocalizations.of(context)!.noInvoices,
                //         subtitle: AppLocalizations.of(context)!.startFirstInvoice,
                //         icon: Icons.receipt_long_outlined,
                //       );
                //     }
                //   },
                // ),
                SizedBox(height: 32.h),
                Text(
                  AppLocalizations.of(context)!.latest_projects,
                  style: MyTextStyle().textStyleSemiBold16(),
                ),
                SizedBox(height: 12.h),
                BlocBuilder<DashboardCampanyCubit, DashboardCampanyState>(
                  builder: (context, state) {
                    if (state.isLoading == true ||
                        state.dashboardCampanyModel == null &&
                            state.errorMessage == null) {
                      final latestProjectsData = List.generate(
                        3,
                        (index) => LatestProjects.fack(),
                      );
                      return Column(
                        children: List.generate(
                          latestProjectsData.length,
                          (index) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Skeletonizer(
                              enabled: true,
                              child: PaymentCard(
                                title: latestProjectsData[index].title,
                                date: latestProjectsData[index].date,
                                amount: '',
                                status: '',
                                statusColor: AppColor.borderColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (state.dashboardCampanyModel != null &&
                        state.dashboardCampanyModel!.latestProjects.isNotEmpty) {
                      final latestProjectsData =
                          state.dashboardCampanyModel!.latestProjects;
                      return Column(
                        children: List.generate(
                          latestProjectsData.length,
                          (index) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProjectDetailsView(
                                    activeProjectModel: ActiveProjectModel(
                                      id: latestProjectsData[index].id,
                                    ),
                                  ),
                                ),
                              ),
                              child: PaymentCard(
                                title: latestProjectsData[index].title,
                                date: latestProjectsData[index].date,
                                amount: latestProjectsData[index].assignedPerson,
                                status: latestProjectsData[index].statusLabel,
                                statusColor: _statusColor(
                                  latestProjectsData[index].statusColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return EmptyStateWidget(
                        title: AppLocalizations.of(context)!.noActiveProjects,
                        subtitle: AppLocalizations.of(
                          context,
                        )!.addNewProjectHint,
                        actionButtonText: AppLocalizations.of(
                          context,
                        )!.addProject,
                        icon: Icons.folder_open_outlined,
                        onActionPressed: () {
                          Navigator.pushNamed(
                            context,
                            MyRoutes().newProjectView,
                          );
                        },
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
