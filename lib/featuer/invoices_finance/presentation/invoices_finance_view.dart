import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/invoices_finance_cubit/invoices_finance_cubit.dart';
import 'package:hb/core/cubit/invoices_finance_cubit/invoices_finance_state.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_company.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/invoices_finance/widgets/card_ivoices_finance_widget.dart';
import 'package:hb/featuer/invoices_finance/widgets/filtter_invoices_finance_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class InvoicesFinanceView extends StatefulWidget {
  const InvoicesFinanceView({super.key});

  @override
  State<InvoicesFinanceView> createState() => _InvoicesFinanceViewState();
}

class _InvoicesFinanceViewState extends State<InvoicesFinanceView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFiltterVisible = false;

  @override
  void initState() {
    super.initState();
    getInvoicesFinance();
  }

  void getInvoicesFinance() {
    context.read<InvoicesFinanceCubit>().fetchInvoicesFinanceData();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawerCompany(),
      appBar: CustomAppBar(
        title: loc.invoices_finance,
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer(); // ✅ فتح drawer باستخدام المفتاح
        },
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),

        child: SingleChildScrollView(
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
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(sizeFactor: animation, child: child),
                  );
                },
                child: isFiltterVisible
                    ? FiltterInvoicesFinanceWidget(key: ValueKey("filter_open"))
                    : SizedBox(key: ValueKey("filter_closed")),
              ),

              DashedLine(),
              SizedBox(height: 20.h),

              // items
              BlocBuilder<InvoicesFinanceCubit, InvoicesFinanceState>(
                builder: (context, state) {
                  final bool loading = state.isLoading;
                  final data = state.invoicesFinanceList ?? [];

                  final itemCount = loading ? 3 : data.length;

                  return Skeletonizer(
                    enabled: loading,
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (loading) {
                          return const CardIvoicesFinanceWidget(); // بدون بيانات
                        } else {
                          return CardIvoicesFinanceWidget(model: data[index]); // مع بيانات حقيقية
                        }
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 8.h),
                      itemCount: itemCount,
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
