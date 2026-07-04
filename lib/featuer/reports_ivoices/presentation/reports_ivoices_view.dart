import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/report_invoice_cubit/report_invoice_cubit.dart';
import 'package:hb/core/cubit/report_invoice_cubit/report_invoice_state.dart';
import 'package:hb/core/data/models/report_invoice_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_accounting_clint.dart';
import 'package:hb/core/widgets/custom_popup_widget.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/reports_ivoices/widgets/filtter_report_invoives_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReportsIvoicesView extends StatelessWidget {
  const ReportsIvoicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportInvoiceCubit()..fetchReports(), // ✅ fetch هون مش في initState
      child: const _ReportsIvoicesBody(),
    );
  }
}

class _ReportsIvoicesBody extends StatefulWidget {
  const _ReportsIvoicesBody();

  @override
  State<_ReportsIvoicesBody> createState() => _ReportsIvoicesBodyState();
}

class _ReportsIvoicesBodyState extends State<_ReportsIvoicesBody> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFiltterVisible = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawerAccountingClint(),
      appBar: CustomAppBar(
        title: loc.reports,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
        child: Column(
          children: [
            SearchBoxWidget(
              hintText: loc.search_by_title,
              fillColor: AppColor.whiteColor,
              isFilterOpen: isFiltterVisible,
              onTap: () {
                setState(() {
                  isFiltterVisible = !isFiltterVisible;
                });
              },
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SizeTransition(sizeFactor: animation, child: child),
              ),
              child: isFiltterVisible
                  ? FiltterReportInvoivesWidget(key: const ValueKey("filter_open"))
                  : const SizedBox(key: ValueKey("filter_closed")),
            ),
            const DashedLine(),
            SizedBox(height: 20.h),
            BlocBuilder<ReportInvoiceCubit, ReportInvoiceState>(
              builder: (context, state) {
                final loading = state.loading ?? false;

                // لا توجد بيانات بعد انتهاء التحميل
                if (!loading && state.data != null && state.data!.isEmpty) {
                  return EmptyStateWidget(
                    title: loc.no_data_available,
                    icon: Icons.inbox_outlined,
                  );
                }

                final data =
                    state.data ?? List.generate(3, (_) => ReportInvoiceModel());
                return Skeletonizer(
                  enabled: loading,
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (_, __) => SizedBox(height: 16.h),
                    itemCount: data.length,
                    itemBuilder: (context, index) => _ReportCard(data: data[index]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final ReportInvoiceModel data;
  const _ReportCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data.title ?? '', style: MyTextStyle().textStyleSemiBold16()),
              CustomPopupWidget(
                items: [PopupMenuItemModel(text: loc.view, onTap: () {})],
                child: Container(
                  width: 28.w,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColor.gray5,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: const Center(child: Icon(Icons.more_vert_outlined)),
                ),
              ),
            ],
          ),
          const DashedLine(),
          SizedBox(height: 20.h),
          InfoRow(label: 'Invoice #: ', value: data.invoiceNumber ?? ''),
          InfoRow(label: '${loc.date}: ', value: data.dateDisplay ?? data.date ?? ''),
          InfoRow(
            // ✅ amount هو double الحين
            label: '${loc.amount}: ',
            value: data.amountDisplay ?? '${data.amount ?? ''}',
          ),
          InfoRow(label: 'Due Date: ', value: data.dateDisplay ?? ''),
          InfoRow(label: '${loc.status}: ', value: data.statusLabel ?? data.status ?? ''),
        ],
      ),
    );
  }
}
