import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/hb_lab_ideas_box_cubit/hb_lab_ideas_box_cubit.dart';
import 'package:hb/core/cubit/hb_lab_project_cubit/hb_lab_project_cubit.dart';
import 'package:hb/core/cubit/user_cubit/user_cubit.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_accounting_clint.dart';
import 'package:hb/core/widgets/custom_drawer_company.dart';
import 'package:hb/core/widgets/custom_drawer_consultant.dart';
import 'package:hb/core/widgets/custom_drawer_student.dart';
import 'package:hb/core/widgets/custom_drawer_visitor.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/consultant_project/widgets/btn_new_project_widget.dart';
import 'package:hb/featuer/hb_lab/widgets/filtter_hb_lab_widget.dart';
import 'package:hb/featuer/hb_lab/widgets/hb_lab_project.dart';
import 'package:hb/featuer/hb_lab/widgets/ideas_box.dart';
import 'package:hb/l10n/app_localizations.dart';

class HbLabView extends StatefulWidget {
  const HbLabView({super.key});

  @override
  State<HbLabView> createState() => _HbLabViewState();
}

class _HbLabViewState extends State<HbLabView> {
  int indexValue = 0;
  bool isFiltterVisible = false;
  Map<String, dynamic> _filters = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<HbLabProjectCubit>().fetchHbLabProject();
    context.read<HbLabIdeasBoxCubit>().fetchHbLabIdeasBox();
  }

  Future<void> _onRefresh() {
    if (indexValue == 0) {
      return context.read<HbLabProjectCubit>().fetchHbLabProject();
    } else {
      return context.read<HbLabIdeasBoxCubit>().fetchHbLabIdeasBox();
    }
  }

  void _onSearchChanged(String value) {
    if (indexValue == 0) {
      context.read<HbLabProjectCubit>().fetchHbLabProject(
            search: value,
            filters: _filters,
          );
    } else {
      context.read<HbLabIdeasBoxCubit>().fetchHbLabIdeasBox(search: value);
    }
  }

  void _onFilterChanged(Map<String, dynamic> filters) {
    _filters = filters;
    if (indexValue == 0) {
      context.read<HbLabProjectCubit>().fetchHbLabProject(filters: filters);
    } else {
      context.read<HbLabIdeasBoxCubit>().fetchHbLabIdeasBox(filters: filters);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final userCubit = context.watch<UserCubit>();
    // تحديد الـ Drawer المناسب حسب نوع المستخدم
    Widget? selectedDrawer;

    switch (userCubit.userType) {
      case UserType.CompanyUser:
        selectedDrawer = const CustomDrawerCompany();
        break;
      case UserType.ConsultantUser:
        selectedDrawer = const CustomDrawerConsultant();
        break;
      case UserType.StudentUser:
        selectedDrawer = const CustomDrawerStudent();
        break;
      case UserType.AccountingClintUser:
        selectedDrawer = const CustomDrawerAccountingClint();
        break;
      case UserType.VisitorUser:
      default:
        selectedDrawer = const CustomDrawerVisitor();
    }
    return Scaffold(
      key: _scaffoldKey,
      drawer: selectedDrawer,
      appBar: CustomAppBar(
        title: loc.hb_lab,
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      bottomNavigationBar: _buildBottomBarByDropdown(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                          (MediaQuery.of(context).size.width - 16.w * 2 - 10.w) /
                          2, // 👈 give it a fixed width instead
                      height: 40.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        border: Border.all(
                          width: indexValue == index ? 0 : 1,
                          color: AppColor.blackColor,
                        ),
                        color: indexValue == index ? AppColor.blackColor : AppColor.whiteColor,
                      ),
                      child: Center(
                        child: Text(
                          index == 0 ? loc.hb_lab_projects_tab : loc.ideas_box,
                          style: MyTextStyle().textStyleRegular14().copyWith(
                            color: indexValue == index ? AppColor.whiteColor : AppColor.blackColor,
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
                onChanged: _onSearchChanged,
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
                child: isFiltterVisible
                    ? FiltterHbLabWidget(
                        key: ValueKey("filter_open_$indexValue"),
                        indexValue: indexValue,
                        onChanged: _onFilterChanged,
                      )
                    : SizedBox(key: ValueKey("filter_closed")),
              ),

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
    switch (indexValue) {
      case 0:
        return const HbLabProject();
      case 1:
        return const IdeasBox();
      default:
        return SizedBox();
    }
  }

  Widget? _buildBottomBarByDropdown() {
    final loc = AppLocalizations.of(context)!;
    final userCubit = context.read<UserCubit>();

    // ✅ الزر يظهر فقط إذا كان المستخدم ConsultantUser والـ index = 0
    if (indexValue == 0 && userCubit.userType == UserType.ConsultantUser) {
      return BtnNewProjectWidget(
        title: loc.boost_your_project,
        onTap: () => Navigator.pushNamed(context, MyRoutes().boostProjectView),
      );
    }

    // ✅ الزر الثاني يظهر فقط إذا كان index = 1 (مهما كان نوع المستخدم)
    if (indexValue == 1) {
      return BtnNewProjectWidget(
        title: loc.submit_a_new_idea,
        onTap: () => Navigator.pushNamed(context, MyRoutes().submitANewIdeaView),
      );
    }

    // ✅ في غير ذلك، لا يظهر أي bottom bar
    return null;
  }
}
