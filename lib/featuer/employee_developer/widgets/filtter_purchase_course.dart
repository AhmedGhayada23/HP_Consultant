import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/training_courses_cubit/training_courses_cubit.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';

class FiltterPurchaseCourse extends StatelessWidget {
  const FiltterPurchaseCourse({super.key});
  static const List<String> categories = [
    'Programming',
    'Design',
    'Marketing',
    'Business',
    'Photography',
    'Music',
  ];
  static const List<String> priceRanges = [
    'Free',
    '\$0 - \$20',
    '\$20 - \$50',
    '\$50 - \$100',
    '\$100+',
  ];

  static const List<String> durations = [
    '0 - 2 Hours',
    '2 - 5 Hours',
    '5 - 10 Hours',
    '10 - 20 Hours',
    '20+ Hours',
  ];

  static const List<String> levels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'All Levels',
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: CustomDropdown(hint: loc.category, items: categories,color: AppColor.whiteColor,
            onChanged: (value) => context.read<TrainingCoursesCubit>().fetchCourses(category: value),
            )),
            SizedBox(width: 12.w,),
            Expanded(child: CustomDropdown(hint: loc.budget_range, items:priceRanges,color: AppColor.whiteColor,
            onChanged: (value) => context.read<TrainingCoursesCubit>().fetchCourses(range: value),
            )),
          ],
        ),
        SizedBox(height: 12.h),
          Row(
          children: [
            Expanded(child: CustomDropdown(hint: 'Duration', items: durations,color: AppColor.whiteColor,
            onChanged: (value) => context.read<TrainingCoursesCubit>().fetchCourses(duration: value),
            )),
            SizedBox(width: 12.w,),
            Expanded(child: CustomDropdown(hint: loc.experience_level, items:levels,color: AppColor.whiteColor,
            onChanged: (value) => context.read<TrainingCoursesCubit>().fetchCourses(leve: value),
            )),
          ],
        ),
      ],
    );
  }
}
