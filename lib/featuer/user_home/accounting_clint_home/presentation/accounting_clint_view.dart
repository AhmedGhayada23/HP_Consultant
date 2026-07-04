import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/core/cubit/service_requests_list_cubit/service_requests_list_cubit.dart';
import 'package:hb/core/cubit/service_requests_list_cubit/service_requests_list_state.dart';
import 'package:hb/core/cubit/service_request_details_cubit/service_request_details_cubit.dart';
import 'package:hb/core/data/models/service_request_item_model.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/featuer/user_home/accounting_clint_home/presentation/request_details_view.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_accounting_clint.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/consultant_project/widgets/btn_new_project_widget.dart';
import 'package:hb/featuer/user_home/accounting_clint_home/widgets/filtter_service_request_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AccountingClintView extends StatefulWidget {
  const AccountingClintView({super.key});

  @override
  State<AccountingClintView> createState() => _AccountingClintViewState();
}

class _AccountingClintViewState extends State<AccountingClintView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFiltterVisible = false;

  @override
  void initState() {
    super.initState();
    context.read<ServiceRequestsListCubit>().fetchServiceRequests();
  }

  // لون الحالة حسب قيمتها
  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('submit')) return const Color(0xffE5A000);
    if (s.contains('progress')) return AppColor.k1primeryColor;
    if (s.contains('complete') || s.contains('approv')) {
      return const Color(0xff2E7D32);
    }
    if (s.contains('cancel') || s.contains('reject')) {
      return AppColor.countNotificationBgColor;
    }
    if (s.contains('pending')) return const Color(0xffE5A000);
    return AppColor.blackColor;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawerAccountingClint(),
      appBar: CustomAppBar(
        title: loc.service_request,
        onMenuTap: () {
          _scaffoldKey.currentState
              ?.openDrawer(); // ✅ فتح drawer باستخدام المفتاح
        },
      ),
      bottomNavigationBar: BtnNewProjectWidget(
        onTap: () =>
            Navigator.pushNamed(context, MyRoutes().requestNewServiceView),
        title: loc.new_service_request,
      ),
      body: RefreshIndicator(
        color: AppColor.k1primeryColor,
        onRefresh: () =>
            context.read<ServiceRequestsListCubit>().fetchServiceRequests(),
        child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
        child: Column(
          children: [
            // box saesh
            SearchBoxWidget(
              hintText: loc.search_by_title,
              fillColor: AppColor.whiteColor,
              isFilterOpen: isFiltterVisible,
              onChanged: (value) =>
                  context.read<ServiceRequestsListCubit>().search(value),
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
                  ? FiltterServiceRequestWidget(key: ValueKey("filter_open"))
                  : SizedBox(key: ValueKey("filter_closed")),
            ),

            DashedLine(),
            SizedBox(height: 20.h),
            BlocBuilder<ServiceRequestsListCubit, ServiceRequestsListState>(
              builder: (context, state) {
                final loading = state.loading;

                // لا توجد بيانات بعد انتهاء التحميل
                if (!loading &&
                    state.data != null &&
                    state.data!.isEmpty) {
                  return EmptyStateWidget(
                    title: loc.no_data_available,
                    icon: Icons.inbox_outlined,
                  );
                }

                final data = state.data ??
                    List.generate(
                      3,
                      (index) => ServiceRequestItemModel(
                        requestId: 'SR-0000',
                        serviceType: 'Service type',
                        submittedOn: '01 Jan 2026',
                        proposedBudget: '€000',
                        status: 'Submitted',
                        description: 'Request description placeholder text',
                      ),
                    );
                return Skeletonizer(
                  enabled: loading,
                  child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final req = data[index];
                      return InkWell(
                        onTap: () {
                          if (loading || req.id == 0) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => ServiceRequestDetailsCubit(
                                  requestId: req.id,
                                ),
                                child: const RequestDetailsView(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              req.serviceType,
                              style: MyTextStyle().textStyleSemiBold16(),
                            ),
                            DashedLine(),
                            SizedBox(height: 20.h),
                            InfoRow(
                                label: '${loc.request_id}: ',
                                value: req.requestId),
                            SizedBox(height: 10.h),
                            InfoRow(
                                label: 'Date Submitted: ',
                                value: req.submittedOn),
                            SizedBox(height: 10.h),
                            InfoRow(
                                label: '${loc.budget}: ',
                                value: req.proposedBudget),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${loc.status} : ',
                                    style: MyTextStyle().textStyleMedium14()),
                                Flexible(
                                  child: Text(
                                    req.status,
                                    textAlign: TextAlign.end,
                                    style: MyTextStyle()
                                        .textStyleMedium15()
                                        .copyWith(
                                            color: _statusColor(req.status)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10.h),
                    itemCount: data.length,
                  ),
                );
              },
            ),
          ],
        ),
        ),
      ),
    );
  }
}
