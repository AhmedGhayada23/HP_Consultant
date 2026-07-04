import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/consultant_cubit/consultant_cubit.dart';
import 'package:hb/core/cubit/consultant_cubit/consultant_state.dart';
import 'package:hb/core/cubit/consultant_requests_cubit/consultant_requests_cubit.dart';
import 'package:hb/core/cubit/consultant_requests_cubit/consultant_requests_state.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/l10n/app_localizations.dart';

class FiltterConsultantDirectoryWidget extends StatelessWidget {
  final int index;
  const FiltterConsultantDirectoryWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return _buildByIndex(context, index);
  }

  Widget _buildByIndex(BuildContext context, int i) {
    switch (i) {
      case 0:
        return buildFilterConsultantWidget(context);
      case 1:
        return buildFilterConsultantRequesWidget(context);
      default:
        return const SizedBox.shrink();
    }
  }
}

Widget buildFilterConsultantWidget(BuildContext context) {
  final loc = AppLocalizations.of(context)!;
  // نطاقات الميزانية (العرض مترجم لخيار "أي ميزانية"، الباقي أرقام) → (min, max)
  final budgetRanges = <String, List<String>>{
    loc.any_budget: ['', ''],
    '€0 - €50': ['0', '50'],
    '€50 - €100': ['50', '100'],
    '€100+': ['100', ''],
  };
  // التوافر: العرض مترجم، والقيمة المُرسَلة بالإنجليزية
  final availabilityLabels = <String, String>{
    'all': loc.all,
    'available': loc.available,
    'busy': loc.busy,
  };
  return BlocBuilder<ConsultantCubit, ConsultantState>(
    builder: (context, state) {
      final cubit = context.read<ConsultantCubit>();
      final categories = state.categories ?? [];

      // الاسم المعروض للتصنيف المختار
      final selectedCat = categories
          .where((c) => c.id.toString() == state.selectedCategory);
      final categoryValue =
          selectedCat.isEmpty ? null : selectedCat.first.name;

      return Column(
        children: [
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Category (من الـ API)
              Expanded(
                child: CustomDropdown(
                  hint: loc.category,
                  color: AppColor.whiteColor,
                  items: categories.map((c) => c.name).toList(),
                  selectedValue: categoryValue,
                  onChanged: (value) {
                    final match = categories.where((c) => c.name == value);
                    cubit.setCategory(
                        match.isEmpty ? '' : match.first.id.toString());
                  },
                ),
              ),
              SizedBox(width: 12.w),
              // Availability
              Expanded(
                child: CustomDropdown(
                  hint: loc.availability,
                  color: AppColor.whiteColor,
                  items: availabilityLabels.values.toList(),
                  selectedValue: availabilityLabels[state.availability],
                  onChanged: (value) {
                    final entry = availabilityLabels.entries.firstWhere(
                      (e) => e.value == value,
                      orElse: () => MapEntry('all', loc.all),
                    );
                    cubit.setAvailability(entry.key);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Budget range (min/max)
          CustomDropdown(
            hint: loc.budget,
            color: AppColor.whiteColor,
            items: budgetRanges.keys.toList(),
            onChanged: (value) {
              final range = budgetRanges[value] ?? const ['', ''];
              cubit.setBudgetRange(range[0], range[1]);
            },
          ),
        ],
      );
    },
  );
}


Widget buildFilterConsultantRequesWidget(BuildContext context) {
  final loc = AppLocalizations.of(context)!;
  // القيمة الإنجليزية (المُرسَلة للخادم) → التسمية المترجمة (للعرض)
  final requestStatusLabels = <String, String>{
    'all': loc.all,
    'submitted': loc.submitted,
    'in_progress': loc.in_progress,
    'completed': loc.completed,
    'cancelled': loc.cancelled,
    'pending': loc.pending,
    'approved': loc.approved,
    'rejected': loc.rejected,
  };
  return BlocBuilder<ConsultantRequestsCubit, ConsultantRequestsState>(
    buildWhen: (prev, curr) => prev.status != curr.status,
    builder: (context, state) {
      return Column(
        children: [
          SizedBox(height: 12.h),
          CustomDropdown(
            hint: loc.status_all,
            color: AppColor.whiteColor,
            items: requestStatusLabels.values.toList(),
            selectedValue: requestStatusLabels[state.status],
            onChanged: (value) {
              final entry = requestStatusLabels.entries.firstWhere(
                (e) => e.value == value,
                orElse: () => MapEntry('all', loc.all),
              );
              context.read<ConsultantRequestsCubit>().setStatus(entry.key);
            },
          ),
        ],
      );
    },
  );
}
