import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/job_and_talent_cubit/job_and_talent_cubit.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/date_picker_field.dart';
import 'package:hb/l10n/app_localizations.dart';

class FilterJobTalentWidget extends StatelessWidget {
  const FilterJobTalentWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SizedBox(height: 12.h),
        Row(
          children: [
                 Expanded(
              child: DatePickerField(
                controller:  context.watch<JobAndTalentCubit>().createdOnController,
                label:    AppLocalizations.of(context)!.created_on,

                onDatePicked: (pickedDate) {
                  context.read<JobAndTalentCubit>().fetchJobsAndTalent(
                    createdOn: pickedDate.toString(),
                  );
                },
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: DatePickerField(
                controller:  context.watch<JobAndTalentCubit>().deadlineController,
                label: AppLocalizations.of(context)!.deadline,

                onDatePicked: (pickedDate) {
                  context.read<JobAndTalentCubit>().fetchJobsAndTalent(
                    deadline: pickedDate.toString(),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Builder(
          builder: (context) {
            final loc = AppLocalizations.of(context)!;
            // العرض مترجم، والقيمة المُرسَلة للخادم بالإنجليزية فقط
            final statuses = {
              loc.all: 'all',
              loc.active: 'active',
              loc.closed: 'closed',
              loc.filled: 'filled',
            };
            return CustomDropdown(
              hint: loc.status_all,
              items: statuses.keys.toList(),
              color: AppColor.whiteColor,
              onChanged: (value) {
                context
                    .read<JobAndTalentCubit>()
                    .fetchJobsAndTalent(status: statuses[value]);
              },
            );
          },
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
