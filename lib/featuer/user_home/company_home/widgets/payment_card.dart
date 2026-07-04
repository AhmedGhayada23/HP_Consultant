import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';

class PaymentCard extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final String status;
  final Color statusColor;

  const PaymentCard({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
    this.statusColor = AppColor.k1primeryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // العنوان والتاريخ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: MyTextStyle().textStyleRegular14()),
              Text(date, style: MyTextStyle().textStyleRegular14()),
            ],
          ),
          SizedBox(height: 20.h),

          // السعر والحالة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(amount, style: MyTextStyle().textStyleSemiBold14()),
              Container(
                height: 28.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.3), // لون الخلفية بنغمة خفيفة
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    status,
                    style: MyTextStyle()
                        .textStyleRegular11()
                        .copyWith(color: statusColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
