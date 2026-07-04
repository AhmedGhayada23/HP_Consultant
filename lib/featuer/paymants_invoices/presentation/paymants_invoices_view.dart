import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/paymant_invoice_cubit/paymant_invoice_cubit.dart';
import 'package:hb/core/cubit/paymant_invoice_cubit/paymant_invoice_state.dart';
import 'package:hb/core/cubit/user_cubit/user_cubit.dart';
import 'package:hb/core/data/models/paymant_invoice_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_company.dart';
import 'package:hb/core/widgets/custom_drawer_consultant.dart';
import 'package:hb/core/widgets/custom_drawer_student.dart';
import 'package:hb/core/widgets/custom_popup_widget.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/invoices_finance/presentation/details_invoices_finance_view.dart';
import 'package:hb/featuer/paymants_invoices/widgets/filtter_paymant_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PaymantsInvoicesView extends StatefulWidget {
  const PaymantsInvoicesView({super.key});

  @override
  State<PaymantsInvoicesView> createState() => _PaymantsInvoicesViewState();
}

class _PaymantsInvoicesViewState extends State<PaymantsInvoicesView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFiltterVisible = false;

  @override
  void initState() {
    super.initState();
    getPaymantInvoice();
  }

  void getPaymantInvoice() {
    context.read<PaymantInvoiceCubit>().fetchPaymantInvoice();
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
        selectedDrawer = const Drawer();
        break;
      case UserType.VisitorUser:
      default:
        selectedDrawer = const Drawer();
    }
    return Scaffold(
      key: _scaffoldKey,
      drawer: selectedDrawer,
      appBar: CustomAppBar(
        title: loc.invoices_finance,
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer(); // ✅ فتح drawer باستخدام المفتاح
        },
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w, vertical: 32.h),

          child: Column(
            children: [
              // box saesh
              SearchBoxWidget(
                hintText: loc.search_by_title,
                fillColor: AppColor.whiteColor,
                isFilterOpen: isFiltterVisible,
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
                    ? FiltterPaymantWidget(key: ValueKey("filter_open"))
                    : SizedBox(key: ValueKey("filter_closed")),
              ),

              DashedLine(),
              SizedBox(height: 20.h),
              BlocBuilder<PaymantInvoiceCubit, PaymantInvoiceState>(
                builder: (context, state) {
                  final data = state.data ?? List.generate(3, (index) => PaymantInvoiceModel());
                  return Skeletonizer(
                    enabled: state.loading ?? false,
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ERP Rollout – Req. Phase',
                                    style: MyTextStyle().textStyleSemiBold16(),
                                  ),
                                  CustomPopupWidget(
                                    items: [
                                      PopupMenuItemModel(
                                        text: 'view',
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailsInvoicesFinanceView(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                    child: Container(
                                      width: 28.w,
                                      padding: EdgeInsets.symmetric(vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: AppColor.gray5,
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                      child: Center(child: Icon(Icons.more_vert_outlined)),
                                    ),
                                  ),
                                ],
                              ),
                              DashedLine(),
                              SizedBox(height: 20),
                              InfoRow(label: 'Invoice #: ', value: 'INV-2025-01'),
                              SizedBox(height: 16),
                              InfoRow(label: 'Date : ', value: '15 Sept 2025'),
                              SizedBox(height: 16),
                              InfoRow(label: 'Amount :', value: '\$3,000'),
                              SizedBox(height: 16),
                              InfoRow(label: 'Paid On :', value: '15 Sept 25'),
                              SizedBox(height: 16),
                              InfoRow(label: 'Status : ', value: 'Paid'),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 10.h),
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
