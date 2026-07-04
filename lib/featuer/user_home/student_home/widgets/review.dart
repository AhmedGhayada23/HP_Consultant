import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/l10n/app_localizations.dart';

class Review extends StatelessWidget {
  final double rating;
  final int reviewsCount;
  const Review({required this.rating, required this.reviewsCount, super.key});

  @override
  Widget build(BuildContext context) {
    final fullStars = rating.round().clamp(0, 5);
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.gray5,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rating.toStringAsFixed(2),
                style: MyTextStyle().textStyleSemiBold16(),
              ),
              Text(
                AppLocalizations.of(context)!.reviews_count(reviewsCount),
                style: MyTextStyle().textStyleMedium14(),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < fullStars ? Icons.star : Icons.star_border,
                color: const Color(0xffE5C511),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
