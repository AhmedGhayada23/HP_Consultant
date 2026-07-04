import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/date_picker_field.dart';
import 'package:hb/l10n/app_localizations.dart';

class FiltterHbLabAccountingWidget extends StatefulWidget {
  final int indexValue;
  final void Function(Map<String, dynamic> filters) onChanged;

  const FiltterHbLabAccountingWidget({
    super.key,
    required this.indexValue,
    required this.onChanged,
  });

  @override
  State<FiltterHbLabAccountingWidget> createState() =>
      _FiltterHbLabAccountingWidgetState();
}

class _FiltterHbLabAccountingWidgetState
    extends State<FiltterHbLabAccountingWidget> {
  static const _budgetMap = <String, (int, int?)>{
    '€0 - €3,000': (0, 3000),
    '€3,000 - €7,000': (3000, 7000),
    '€7,000+': (7000, null),
  };

  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  String? _category;
  int? _minBudget;
  int? _maxBudget;
  DateTime? _deadlineFrom;
  DateTime? _deadlineTo;
  String? _status;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _notify() {
    if (widget.indexValue == 1) {
      widget.onChanged({
        if (_status != null) 'status': _status,
      });
    } else {
      widget.onChanged({
        if (_category != null) 'category': _category,
        if (_minBudget != null) 'min_budget': _minBudget,
        if (_maxBudget != null) 'max_budget': _maxBudget,
        if (_deadlineFrom != null) 'deadline_from': _fmt(_deadlineFrom!),
        if (_deadlineTo != null) 'deadline_to': _fmt(_deadlineTo!),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    // العرض مترجم، والقيمة المُرسَلة للخادم بالإنجليزية
    final statuses = <String, String?>{
      loc.all: null, // الكل → بدون فلتر
      loc.under_review: 'Under Review',
      loc.rejected: 'Rejected',
    };
    final categories = <String, String>{
      loc.category_ai_nlp: 'AI / NLP',
      loc.category_data_science: 'Data Science',
      loc.category_rpa_it: 'RPA / IT',
    };

    if (widget.indexValue == 1) {
      return Column(
        children: [
          SizedBox(height: 12.h),
          CustomDropdown(
            hint: loc.status_all,
            items: statuses.keys.toList(),
            color: AppColor.whiteColor,
            onChanged: (value) {
              _status = statuses[value];
              _notify();
            },
          ),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(height: 12.h),
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomDropdown(
                hint: loc.category,
                items: categories.keys.toList(),
                color: AppColor.whiteColor,
                onChanged: (value) {
                  _category = categories[value];
                  _notify();
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomDropdown(
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
            ),
          ],
        ),
      ],
    );
  }
}
