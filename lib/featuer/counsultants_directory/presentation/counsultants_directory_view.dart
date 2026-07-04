import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/consultant_cubit/consultant_cubit.dart';
import 'package:hb/core/cubit/consultant_requests_cubit/consultant_requests_cubit.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_accounting_clint.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/counsultants_directory/widgets/counsultants_card.dart';
import 'package:hb/featuer/counsultants_directory/widgets/filtter_consultant_directory_widget.dart';
import 'package:hb/featuer/counsultants_directory/widgets/requested_counsultant_card.dart';
import 'package:hb/l10n/app_localizations.dart';

class CounsultantsDirectoryView extends StatefulWidget {
  const CounsultantsDirectoryView({super.key});

  @override
  State<CounsultantsDirectoryView> createState() =>
      _CounsultantsDirectoryViewState();
}

class _CounsultantsDirectoryViewState extends State<CounsultantsDirectoryView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int indexValue = 0;
  bool isFiltterVisible = false;

  @override
  void initState() {
    super.initState();
    getConsultant();
    context.read<ConsultantCubit>().fetchCategories();
    context.read<ConsultantRequestsCubit>().fetchConsultantRequests();
  }

  void getConsultant() {
    context.read<ConsultantCubit>().fetchConsultants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawerAccountingClint(),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.consultants_directory,
        onMenuTap: () {
          _scaffoldKey.currentState
              ?.openDrawer(); // ✅ فتح drawer باستخدام المفتاح
        },
      ),
      body: RefreshIndicator(
        color: AppColor.k1primeryColor,
        onRefresh: () => _refreshCurrentSection(),
        child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                      color: indexValue == index
                          ? AppColor.blackColor
                          : AppColor.whiteColor,
                    ),
                    child: Center(
                      child: Text(
                        index == 0
                            ? AppLocalizations.of(context)!.consultants
                            : AppLocalizations.of(context)!.requested_consultants,
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
              hintText: AppLocalizations.of(context)!.search_by_title,
              fillColor: AppColor.whiteColor,
              isFilterOpen: isFiltterVisible,
              onChanged: indexValue == 0
                  ? (value) => context.read<ConsultantCubit>().search(value)
                  : (value) =>
                      context.read<ConsultantRequestsCubit>().search(value),
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
                  ? FiltterConsultantDirectoryWidget(
                      key: ValueKey("filter_open"),
                      index: indexValue,
                    )
                  : SizedBox(key: ValueKey("filter_closed")),
            ),

            SizedBox(height: 20.h),
            _buildSelectedContent(),
          ],
        ),
        ),
      ),
    );
  }

  // تحديث القسم الحالي حسب التبويب المختار
  Future<void> _refreshCurrentSection() {
    if (indexValue == 0) {
      return context.read<ConsultantCubit>().fetchConsultants();
    }
    return context.read<ConsultantRequestsCubit>().fetchConsultantRequests();
  }

  Widget _buildSelectedContent() {
    switch (indexValue) {
      case 0:
        return CounsultantsCard();
      case 1:
        return RequestedCounsultantCard();
      default:
        return SizedBox();
    }
  }
}
