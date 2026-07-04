import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/l10n/app_localizations.dart';

class FiltterMyCouresesWidget extends StatelessWidget {
  final List<String> levels;
  final List<String> statuses;
  final String? selectedLevel;
  final String? selectedStatus;
  final ValueChanged<String?> onLevelChanged;
  final ValueChanged<String?> onStatusChanged;

  const FiltterMyCouresesWidget({
    super.key,
    this.levels = const [],
    this.statuses = const [],
    this.selectedLevel,
    this.selectedStatus,
    required this.onLevelChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final all = loc.all;

    return Column(
      children: [
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomDropdown(
                hint: loc.level,
                items: [all, ...levels],
                selectedValue: selectedLevel,
                color: AppColor.whiteColor,
                onChanged: (value) =>
                    onLevelChanged(value == all ? null : value),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomDropdown(
                hint: loc.status_all,
                items: [all, ...statuses],
                selectedValue: selectedStatus,
                color: AppColor.whiteColor,
                onChanged: (value) =>
                    onStatusChanged(value == all ? null : value),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
