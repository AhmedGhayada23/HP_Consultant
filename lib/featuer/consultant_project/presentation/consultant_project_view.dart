import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/active_project_cubit/active_project_cubit.dart';
import 'package:hb/core/cubit/consultant_meeting_request_cubit/consultant_meeting_request_cubit.dart';
import 'package:hb/core/cubit/consultant_project_cubit/consultant_project_cubit.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_company.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/consultant_project/widgets/Consultant_meeting_requests_widget.dart';
import 'package:hb/featuer/consultant_project/widgets/active_consultants_widget.dart';
import 'package:hb/featuer/consultant_project/widgets/active_projects_widget.dart';
import 'package:hb/featuer/consultant_project/widgets/btn_new_project_widget.dart';
import 'package:hb/featuer/consultant_project/widgets/filtter_active_project.dart';
import 'package:hb/featuer/consultant_project/widgets/filtter_consultant_project.dart';
import 'package:hb/featuer/consultant_project/widgets/filtter_meeting_request.dart';
import 'package:hb/l10n/app_localizations.dart';

class ConsultantProjectTabs {
  static const activeConsultants = "active_consultants";
  static const activeProjects = "active_projects";
  static const consultantMeetingRequests = "consultant_meeting_requests";
}

class ConsultantProjectView extends StatefulWidget {
  const ConsultantProjectView({super.key});
  @override
  State<ConsultantProjectView> createState() => _ConsultantProjectViewState();
}

class _ConsultantProjectViewState extends State<ConsultantProjectView> {
  String dropdownValue = ConsultantProjectTabs.activeConsultants;
  bool isFillterOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getConsultantProject();
    getActiveProject();
    getConsultantMeetingRequest();
  }

  void getConsultantProject() => context.read<ConsultantProjectCubit>().fetchConsultantProject();

  void getActiveProject() => context.read<ActiveProjectCubit>().fetchActiveProject();

  void getConsultantMeetingRequest() =>
      context.read<ConsultantMeetingRequestCubit>().fetchConsultantMeetingRequest();

  // ✅ refresh بناءً على التاب الحالي
  Future<void> _onRefresh() async {
    switch (dropdownValue) {
      case ConsultantProjectTabs.activeConsultants:
        getConsultantProject();
        break;
      case ConsultantProjectTabs.activeProjects:
        getActiveProject();
        break;
      case ConsultantProjectTabs.consultantMeetingRequests:
        getConsultantMeetingRequest();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final Map<String, String> tabLabels = {
      ConsultantProjectTabs.activeConsultants: loc.active_consultants,
      ConsultantProjectTabs.activeProjects: loc.active_projects,
      ConsultantProjectTabs.consultantMeetingRequests: loc.consultant_meeting_requests,
    };

    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawerCompany(),
      appBar: CustomAppBar(
        title: loc.consultants_projects,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      bottomNavigationBar: _buildBottomBarByDropdown(loc),
      body: RefreshIndicator(
        color: AppColor.blackColor,
        onRefresh: _onRefresh, // ✅
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
          child: SingleChildScrollView(
            // ✅ مهم عشان RefreshIndicator يشتغل مع SingleChildScrollView
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                CustomDropdown(
                  onChanged: (value) {
                    final key = tabLabels.entries.firstWhere((e) => e.value == value).key;
                    setState(() {
                      dropdownValue = key;
                      isFillterOpen = false;
                    });
                  },
                  hint: tabLabels[dropdownValue] ?? dropdownValue,
                  items: tabLabels.values.toList(),
                ),
                SizedBox(height: 22.h),
                _buildSelectedFilterContent(loc),
                const DashedLine(),
                SizedBox(height: 20.h),
                _buildSelectedContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedContent() {
    switch (dropdownValue) {
      case ConsultantProjectTabs.activeConsultants:
        return const ActiveConsultantsWidget();
      case ConsultantProjectTabs.activeProjects:
        return const ActiveProjectsWidget();
      case ConsultantProjectTabs.consultantMeetingRequests:
        return const ConsultantMeetingRequestsWidget();
      default:
        return const SizedBox();
    }
  }

  Widget? _buildBottomBarByDropdown(AppLocalizations loc) {
    switch (dropdownValue) {
      case ConsultantProjectTabs.activeConsultants:
        return null;
      case ConsultantProjectTabs.activeProjects:
        return BtnNewProjectWidget(
          title: loc.new_project,
          onTap: () => Navigator.pushNamed(context, MyRoutes().newProjectView),
        );
      case ConsultantProjectTabs.consultantMeetingRequests:
        return BtnNewProjectWidget(
          title: loc.new_request,
          onTap: () => Navigator.pushNamed(context, MyRoutes().consultantMeetingRequestsView),
        );
      default:
        return null;
    }
  }

  Widget _buildSelectedFilterContent(AppLocalizations loc) {
    switch (dropdownValue) {
      case ConsultantProjectTabs.activeConsultants:
        return Column(
          children: [
            SearchBoxWidget(
              hintText: loc.search_by_title,
              fillColor: AppColor.whiteColor,
              isFilterOpen: isFillterOpen,
              onChanged: (value) =>
                  context.read<ConsultantProjectCubit>().fetchConsultantProject(search: value),
              onTap: () => setState(() => isFillterOpen = !isFillterOpen),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(sizeFactor: animation, child: child),
                );
              },
              child: isFillterOpen
                  ? FiltterConsultantProject(key: const ValueKey("filter_open"))
                  : const SizedBox(key: ValueKey("filter_closed")),
            ),
          ],
        );

      case ConsultantProjectTabs.activeProjects:
        return Column(
          children: [
            // مثلاً search بدون filter button
            SearchBoxWidget(
              hintText: loc.search_by_title,
              fillColor: AppColor.whiteColor,
              onChanged: (value) {
                context.read<ActiveProjectCubit>().fetchActiveProject(name: value);
              },
              onTap: () => setState(() => isFillterOpen = !isFillterOpen),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(sizeFactor: animation, child: child),
                );
              },
              child: isFillterOpen
                  ? FiltterActiveProject(key: const ValueKey("filter_open"))
                  : const SizedBox(key: ValueKey("filter_closed")),
            ),
            //     const ActiveProjectsWidget(),
          ],
        );

      case ConsultantProjectTabs.consultantMeetingRequests:
        return Column(
          children: [
            SearchBoxWidget(
              hintText: loc.search_by_title,
              fillColor: AppColor.whiteColor,
              onChanged: (value) {
                context.read<ConsultantMeetingRequestCubit>().fetchConsultantMeetingRequest(
                  name: value,
                );
              },
              onTap: () => setState(() => isFillterOpen = !isFillterOpen),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(sizeFactor: animation, child: child),
                );
              },
              child: isFillterOpen
                  ? FiltterMeetingRequest(key: const ValueKey("filter_open"))
                  : const SizedBox(key: ValueKey("filter_closed")),
            ),
          ],
        );

      default:
        return const SizedBox();
    }
  }
}
