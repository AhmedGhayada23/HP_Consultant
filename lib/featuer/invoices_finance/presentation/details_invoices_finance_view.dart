import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:vector_graphics/vector_graphics.dart';

class DetailsInvoicesFinanceView extends StatefulWidget {
  const DetailsInvoicesFinanceView({super.key});

  @override
  State<DetailsInvoicesFinanceView> createState() => _DetailsInvoicesFinanceViewState();
}

class _DetailsInvoicesFinanceViewState extends State<DetailsInvoicesFinanceView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        title: Text(
          'Invoice INV-2025-01',
          style: MyTextStyle().textStyleSemiBold20().copyWith(color: AppColor.whiteColor),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          boxShadow: [BoxShadow(color: AppColor.blackColor, offset: Offset(0, 3))],
        ),
        child: Center(
          child: CustomButton(
            onTap: () {},
            color: AppColor.k1primeryColor,
            text: 'Download',
            icons: VectorGraphic(
              loader: AssetBytesLoader(AppSvg.fileDownloadSvg),

              colorFilter: ColorFilter.mode(AppColor.whiteColor, BlendMode.srcIn),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 32.h),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
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
                      Text('Invoice Number', style: MyTextStyle().textStyleRegular16()),
                      Text('INV-2025-01', style: MyTextStyle().textStyleMedium18()),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date Issued', style: MyTextStyle().textStyleRegular16()),
                      Text('15 Sept 2025', style: MyTextStyle().textStyleMedium18()),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Due Date', style: MyTextStyle().textStyleRegular16()),
                      Text('30 Sept 2025', style: MyTextStyle().textStyleMedium18()),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Status', style: MyTextStyle().textStyleRegular16()),
                      Text(
                        'Paid',
                        style: MyTextStyle().textStyleMedium18().copyWith(
                          color: AppColor.k1primeryColor,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 32.h),

                  // to
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: AppColor.gray5,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Billed To', style: MyTextStyle().textStyleSemiBold16()),
                        DashedLine(),
                        SizedBox(height: 20.h),
                        Text('Company Name', style: MyTextStyle().textStyleRegular14()),
                        SizedBox(height: 8.h),
                        Text('TechSolutions SARL', style: MyTextStyle().textStyleMedium15()),
                        SizedBox(height: 24.h),
                        Text('Registration Number', style: MyTextStyle().textStyleRegular14()),
                        SizedBox(height: 8.h),
                        Text('LU12345678', style: MyTextStyle().textStyleMedium15()),
                        SizedBox(height: 24.h),
                        Text('Contact Person', style: MyTextStyle().textStyleRegular14()),
                        SizedBox(height: 8.h),
                        Text(
                          'Sarah Ahmed (Sales engineer)',
                          style: MyTextStyle().textStyleMedium15(),
                        ),
                        SizedBox(height: 24.h),
                        Text('Address', style: MyTextStyle().textStyleRegular14()),
                        SizedBox(height: 8.h),
                        Text(
                          '12 Avenue de la Gare, 1611 Luxembourg',
                          style: MyTextStyle().textStyleMedium15(),
                        ),
                        SizedBox(height: 24.h),
                        Text('Email', style: MyTextStyle().textStyleRegular14()),
                        SizedBox(height: 8.h),
                        Text('mail@gmail.com', style: MyTextStyle().textStyleMedium15()),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // form
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: AppColor.gray5,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Billed From', style: MyTextStyle().textStyleSemiBold16()),
                        DashedLine(),
                        SizedBox(height: 20.h),
                        Text('Company Name', style: MyTextStyle().textStyleRegular14()),
                        SizedBox(height: 8.h),
                        Text('HB Consulting & Services', style: MyTextStyle().textStyleMedium15()),
                        SizedBox(height: 24.h),
                        Text('Registration Number', style: MyTextStyle().textStyleRegular14()),
                        SizedBox(height: 8.h),
                        Text('931848121', style: MyTextStyle().textStyleMedium15()),
                        SizedBox(height: 24.h),
                        Text('Phone', style: MyTextStyle().textStyleRegular14()),
                        SizedBox(height: 8.h),
                        Text('+33 (0)1 23 45 67 89', style: MyTextStyle().textStyleMedium15()),
                        SizedBox(height: 24.h),
                        Text('Address', style: MyTextStyle().textStyleRegular14()),
                        SizedBox(height: 8.h),
                        Text(
                          '10 Rue de la Paix, 75002 Paris, France)',
                          style: MyTextStyle().textStyleMedium15(),
                        ),
                        SizedBox(height: 24.h),
                        Text('Email', style: MyTextStyle().textStyleRegular14()),
                        SizedBox(height: 8.h),
                        Text('billing@hbconsulting.com', style: MyTextStyle().textStyleMedium15()),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                  // details
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: AppColor.gray5,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Agile Training (HR Dept)',
                          style: MyTextStyle().textStyleSemiBold16(),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Consultant / Trainer:',
                              style: MyTextStyle().textStyleRegular14(),
                            ),
                            Text('CHB Trainer', style: MyTextStyle().textStyleRegular14()),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Hours / Qty: ', style: MyTextStyle().textStyleRegular14()),
                            Text('1 session', style: MyTextStyle().textStyleRegular14()),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Rate: ', style: MyTextStyle().textStyleRegular14()),
                            Text('\$1,200', style: MyTextStyle().textStyleRegular14()),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Amount: ', style: MyTextStyle().textStyleRegular14()),
                            Text('\$1,200', style: MyTextStyle().textStyleMedium15()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('Subtotal', style: MyTextStyle().textStyleRegular16())),
                      Expanded(child: Text('Tax (10%)', style: MyTextStyle().textStyleRegular16())),
                      Expanded(child: SizedBox()),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('\$5,000', style: MyTextStyle().textStyleMedium16())),
                      Expanded(child: Text('\$5,000', style: MyTextStyle().textStyleMedium16())),
                      Expanded(child: SizedBox()),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Row(children: [Text('Total Due', style: MyTextStyle().textStyleRegular16())]),
                  SizedBox(height: 10.h),
                  Row(children: [Text('\$5,500', style: MyTextStyle().textStyleMedium16())]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
