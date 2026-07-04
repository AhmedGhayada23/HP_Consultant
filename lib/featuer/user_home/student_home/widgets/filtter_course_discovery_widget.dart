import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/course_discovery_cubit/course_discovery_cubit.dart';
import 'package:hb/core/cubit/course_discovery_cubit/course_discovery_state.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/l10n/app_localizations.dart';

class FiltterCourseDiscoveryWidget extends StatefulWidget {
  const FiltterCourseDiscoveryWidget({super.key});

  @override
  State<FiltterCourseDiscoveryWidget> createState() =>
      _FiltterCourseDiscoveryWidgetState();
}

class _FiltterCourseDiscoveryWidgetState
    extends State<FiltterCourseDiscoveryWidget> {
  String? _selectedLevel; // canonical (beginner / intermediate / advanced)
  int? _selectedCategoryId;
  String? _selectedCategoryName;

  void _apply() {
    context.read<CourseDiscoveryCubit>().applyFilters(
          level: _selectedLevel,
          categoryId: _selectedCategoryId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // العرض مترجم، والقيمة المُرسَلة للخادم بالإنجليزية فقط
    final levels = {
      loc.beginner: 'beginner',
      loc.intermediate: 'intermediate',
      loc.advanced: 'advanced',
    };
    // تسمية العرض للمستوى المختار حالياً
    String? selectedLevelLabel;
    levels.forEach((label, value) {
      if (value == _selectedLevel) selectedLevelLabel = label;
    });

    return BlocBuilder<CourseDiscoveryCubit, CourseDiscoveryState>(
      builder: (context, state) {
        // التصنيفات المتراكمة (تبقى كاملة حتى بعد اختيار تصنيف)
        final categories = state.categories;

        return Column(
          children: [
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomDropdown(
                    hint: loc.experience_level,
                    items: levels.keys.toList(),
                    selectedValue: selectedLevelLabel,
                    color: AppColor.whiteColor,
                    onChanged: (value) {
                      setState(() => _selectedLevel = levels[value]);
                      _apply();
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomDropdown(
                    hint: loc.category,
                    items: categories.values.toList(),
                    selectedValue: _selectedCategoryName,
                    color: AppColor.whiteColor,
                    onChanged: (value) {
                      final id = categories.entries
                          .firstWhere((e) => e.value == value)
                          .key;
                      setState(() {
                        _selectedCategoryName = value;
                        _selectedCategoryId = id;
                      });
                      _apply();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
