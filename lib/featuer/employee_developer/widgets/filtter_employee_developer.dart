import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/employee_developer_cubit/purchased_course_cubit.dart';
import 'package:hb/core/cubit/training_courses_cubit/training_courses_cubit.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/date_picker_field.dart';
import 'package:hb/l10n/app_localizations.dart';

class FiltterEmployeeDeveloper extends StatelessWidget {
  const FiltterEmployeeDeveloper({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomDropdown(
                hint: loc.status_all,
                items: ['active', 'closed', 'completed'],
                color: AppColor.whiteColor,
                onChanged: (value) =>
                    context.read<PurchasedCourseCubit>().fetchEmployeeDeveloper(search: value),
              ),
            ),
            SizedBox(width: 12.w),

            Expanded(
              child: DatePickerField(
                controller: context.watch<PurchasedCourseCubit>().timelineTextEditingController,
                label: 'timeline',

                onDatePicked: (pickedDate) {
                  context.read<PurchasedCourseCubit>().fetchEmployeeDeveloper(
                    timeline: pickedDate.toString(),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
