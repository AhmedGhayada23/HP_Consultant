import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/date_picker_field.dart';
import 'package:hb/l10n/app_localizations.dart';

class FiltterJobsMarketplaceWidget extends StatefulWidget {
  final void Function(Map<String, dynamic> filters) onChanged;

  const FiltterJobsMarketplaceWidget({
    super.key,
    required this.onChanged,
  });

  @override
  State<FiltterJobsMarketplaceWidget> createState() =>
      _FiltterJobsMarketplaceWidgetState();
}

class _FiltterJobsMarketplaceWidgetState
    extends State<FiltterJobsMarketplaceWidget> {
  static const _budgetMap = <String, (int, int?)>{
    '€0 - €3,000': (0, 3000),
    '€3,000 - €7,000': (3000, 7000),
    '€7,000+': (7000, null),
  };

  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  int? _categoryId;
  String? _jobType;
  int? _minBudget;
  int? _maxBudget;
  DateTime? _deadlineFrom;
  DateTime? _deadlineTo;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _notify() {
    widget.onChanged({
      if (_categoryId != null) 'category_id': _categoryId,
      if (_jobType != null) 'job_type': _jobType,
      if (_minBudget != null) 'min_budget': _minBudget,
      if (_maxBudget != null) 'max_budget': _maxBudget,
      if (_deadlineFrom != null) 'deadline_from': _fmt(_deadlineFrom!),
      if (_deadlineTo != null) 'deadline_to': _fmt(_deadlineTo!),
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    // العرض مترجم، والقيمة المُرسَلة للخادم بالإنجليزية/المعرّف فقط
    final categories = <String, int>{
      loc.category_it_development: 1,
      loc.category_design: 2,
      loc.category_accounting: 3,
      loc.finance: 4,
    };
    final jobTypes = <String, String>{
      loc.full_time: 'full_time',
      loc.part_time: 'part_time',
      loc.contract: 'contract',
      loc.freelance: 'freelance',
    };

    return Column(
      children: [
        SizedBox(height: 12.h),
        // Deadline From / To
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DatePickerField(
                controller: _fromController,
                label: loc.deadline_from,
                onDatePicked: (d) {
                  _deadlineFrom = d;
                  _notify();
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: DatePickerField(
                controller: _toController,
                label: loc.deadline_to,
                onDatePicked: (d) {
                  _deadlineTo = d;
                  _notify();
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Job Category / Job Type
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomDropdown(
                hint: loc.job_category,
                items: categories.keys.toList(),
                color: AppColor.whiteColor,
                onChanged: (value) {
                  _categoryId = categories[value];
                  _notify();
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomDropdown(
                hint: loc.job_type,
                items: jobTypes.keys.toList(),
                color: AppColor.whiteColor,
                onChanged: (value) {
                  _jobType = jobTypes[value];
                  _notify();
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Budget Range
        CustomDropdown(
          hint: loc.budget_range,
          items: const ['€0 - €3,000', '€3,000 - €7,000', '€7,000+'],
          color: AppColor.whiteColor,
          onChanged: (value) {
            final range = _budgetMap[value];
            _minBudget = range?.$1;
            _maxBudget = range?.$2;
            _notify();
          },
        ),
      ],
    );
  }
}
