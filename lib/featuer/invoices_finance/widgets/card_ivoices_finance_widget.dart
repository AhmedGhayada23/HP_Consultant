import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/data/models/report_invoice_model.dart'; // ✅ استبدل InvoicesFinanceModel
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_popup_widget.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/featuer/invoices_finance/presentation/details_invoices_finance_view.dart';

class CardIvoicesFinanceWidget extends StatelessWidget {
  final ReportInvoiceModel? model; // ✅
  const CardIvoicesFinanceWidget({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColor.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(model?.title ?? '', style: MyTextStyle().textStyleSemiBold16()),
              CustomPopupWidget(
                items: [
                  PopupMenuItemModel(
                    text: 'view',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailsInvoicesFinanceView()),
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
                  child: const Center(child: Icon(Icons.more_vert_outlined)),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          const DashedLine(),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Invoice #: ',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
              Text(
                model?.invoiceNumber ?? '', // ✅ كان invoiceId
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date: ',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
              Text(
                model?.dateDisplay ?? model?.date ?? '', // ✅
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount: ',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
              Text(
                model?.amountDisplay ?? '${model?.amount ?? ''}', // ✅ كان String هلق double
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Due Date: ',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
              Text(
                model?.dueDate ?? '',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status: ',
                style: MyTextStyle().textStyleMedium14().copyWith(color: AppColor.gray3),
              ),
              Text(
                model?.statusLabel ?? model?.status ?? '',
                style: MyTextStyle().textStyleMedium14().copyWith(
                  color: model?.status == 'sent'
                      ? AppColor.k1primeryColor
                      // ✅ بناءً على status string
                      : AppColor.countNotificationBgColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
