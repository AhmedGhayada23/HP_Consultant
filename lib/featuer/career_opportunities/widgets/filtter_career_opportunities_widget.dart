import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/jobs_internship_cubit/jobs_internship_cubit.dart';
import 'package:hb/core/cubit/jobs_internship_cubit/jobs_internship_state.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/date_picker_field.dart';
import 'package:hb/l10n/app_localizations.dart';

class FiltterCareerOpportunitiesWidget extends StatelessWidget {
  final int index;
  final List<String> statuses;
  final String? selectedStatus;
  final ValueChanged<String?>? onStatusChanged;

  const FiltterCareerOpportunitiesWidget({
    super.key,
    required this.index,
    this.statuses = const [],
    this.selectedStatus,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    switch (index) {
      case 0:
        return const _JobInternshipFilter();
      case 1:
        return myApplicationFilterWidget(loc);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget myApplicationFilterWidget(AppLocalizations loc) {
    final all = loc.all;
    return Column(
      children: [
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomDropdown(
                hint: loc.status,
                items: [all, ...statuses],
                selectedValue: selectedStatus,
                color: AppColor.whiteColor,
                onChanged: (value) =>
                    onStatusChanged?.call(value == all ? null : value),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// خيارات الميزانية (label -> [min, max])
const _budgetRanges = <String, List<String?>>{
  '€0 - €3,000': ['0', '3000'],
  '€3,000 - €7,000': ['3000', '7000'],
  '€7,000+': ['7000', null],
};

class _JobInternshipFilter extends StatefulWidget {
  const _JobInternshipFilter();

  @override
  State<_JobInternshipFilter> createState() => _JobInternshipFilterState();
}

class _JobInternshipFilterState extends State<_JobInternshipFilter> {
  final _deadlineController = TextEditingController();

  @override
  void dispose() {
    _deadlineController.dispose();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final all = loc.all;
    final cubit = context.read<JobsInternshipCubit>();

    return Column(
      children: [
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Type (data-driven من السيرفر)
            Expanded(
              child: BlocBuilder<JobsInternshipCubit, JobsInternshipState>(
                builder: (context, state) {
                  final jobTypes = state.jobTypes; // value -> label
                  return CustomDropdown(
                    hint: loc.job_type,
                    items: [all, ...jobTypes.values],
                    color: AppColor.whiteColor,
                    onChanged: (value) {
                      if (value == all) {
                        cubit.setJobType(null);
                        return;
                      }
                      final entry =
                          jobTypes.entries.firstWhere((e) => e.value == value);
                      cubit.setJobType(entry.key);
                    },
                  );
                },
              ),
            ),
            SizedBox(width: 12.w),
            // Budget range
            Expanded(
              child: CustomDropdown(
                hint: loc.budget,
                items: [all, ..._budgetRanges.keys],
                color: AppColor.whiteColor,
                onChanged: (value) {
                  if (value == all) {
                    cubit.setBudgetRange(null, null);
                    return;
                  }
                  final range = _budgetRanges[value]!;
                  cubit.setBudgetRange(range[0], range[1]);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Deadline To
        DatePickerField(
          controller: _deadlineController,
          label: loc.deadline,
          onDatePicked: (picked) {
            final formatted =
                '${picked.year}-${_two(picked.month)}-${_two(picked.day)}';
            cubit.setDeadlineTo(formatted);
          },
        ),
      ],
    );
  }
}
