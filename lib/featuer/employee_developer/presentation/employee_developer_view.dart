import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/employee_developer_cubit/purchased_course_cubit.dart';
import 'package:hb/core/cubit/employee_progress_cubit/employee_progress_cubit.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_company.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/consultant_project/widgets/btn_new_project_widget.dart';
import 'package:hb/featuer/employee_developer/widgets/employee_progress_widget.dart';
import 'package:hb/featuer/employee_developer/widgets/filtter_employee_developer.dart';
import 'package:hb/featuer/employee_developer/widgets/purchased_courses_widget.dart';
import 'package:hb/l10n/app_localizations.dart';

class EmployeeDeveloperView extends StatefulWidget {
  const EmployeeDeveloperView({super.key});

  @override
  State<EmployeeDeveloperView> createState() => _EmployeeDeveloperViewState();
}

class EmployeeDeveloperTabs {
  static const purchasedCourses = "purchased_courses";
  static const employeeProgress = "employee_progress";
}

class _EmployeeDeveloperViewState extends State<EmployeeDeveloperView> {
  String dropdownValue = EmployeeDeveloperTabs.purchasedCourses; // ✅ key ثابت
  bool isFillterVisible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getPurchasedCourse();
    getEmployeeDeveloper();
  }

  void getPurchasedCourse() => context.read<PurchasedCourseCubit>().fetchEmployeeDeveloper();

  void getEmployeeDeveloper() => context.read<EmployeeProgressCubit>().fetchEmployeesProgress();

  Future<void> _onRefresh() async {
    switch (dropdownValue) {
      case EmployeeDeveloperTabs.purchasedCourses:
        getPurchasedCourse();
        break;
      case EmployeeDeveloperTabs.employeeProgress:
        getEmployeeDeveloper();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final Map<String, String> tabLabels = {
      EmployeeDeveloperTabs.purchasedCourses: loc.purchase_new_course, // ✅ ترجمة
      EmployeeDeveloperTabs.employeeProgress: loc.employee_development, // ✅ ترجمة
    };

    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawerCompany(),
      appBar: CustomAppBar(
        title: loc.employee_development,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      bottomNavigationBar: _buildBottomBarByDropdown(loc),
      body: RefreshIndicator(
        color: AppColor.blackColor,
        onRefresh: _onRefresh,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                CustomDropdown(
                  hint: tabLabels[dropdownValue] ?? dropdownValue, // ✅ عرض الترجمة
                  onChanged: (value) {
                    final key = tabLabels.entries.firstWhere((e) => e.value == value).key;
                    setState(() => dropdownValue = key);
                  },
                  items: tabLabels.values.toList(), // ✅ keys ثابتة
                ),
                SizedBox(height: 22.h),
                SearchBoxWidget(
                  hintText: loc.search_by_title,
                  fillColor: AppColor.whiteColor,
                  isFilterOpen: isFillterVisible,
                  onChanged: (value) =>
                      context.read<PurchasedCourseCubit>().fetchEmployeeDeveloper(search: value),
                  onTap: () => setState(() => isFillterVisible = !isFillterVisible),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SizeTransition(sizeFactor: animation, child: child),
                  ),
                  child: isFillterVisible
                      ? FiltterEmployeeDeveloper(key: const ValueKey("filter_open"))
                      : const SizedBox(key: ValueKey("filter_closed")),
                ),
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
      case EmployeeDeveloperTabs.employeeProgress:
        return const EmployeeProgressWidget();
      case EmployeeDeveloperTabs.purchasedCourses:
        return const PurchasedCoursesWidget();
      default:
        return const SizedBox();
    }
  }

  Widget? _buildBottomBarByDropdown(AppLocalizations loc) {
    switch (dropdownValue) {
      case EmployeeDeveloperTabs.employeeProgress:
        return null;
      case EmployeeDeveloperTabs.purchasedCourses:
        return BtnNewProjectWidget(
          title: loc.purchase_new_course,
          onTap: () => Navigator.pushNamed(context, MyRoutes().purchaseNewCourseView),
        );
      default:
        return null;
    }
  }
}
