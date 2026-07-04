import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/service_requests_list_cubit/service_requests_list_cubit.dart';
import 'package:hb/core/cubit/service_requests_list_cubit/service_requests_list_state.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/l10n/app_localizations.dart';

class FiltterServiceRequestWidget extends StatelessWidget {
  const FiltterServiceRequestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // القيمة الإنجليزية (المُرسَلة للخادم) → التسمية المترجمة (للعرض)
    final statusLabels = <String, String>{
      'all': loc.all,
      'submitted': loc.submitted,
      'in_progress': loc.in_progress,
      'completed': loc.completed,
      'cancelled': loc.cancelled,
      'pending': loc.pending,
      'approved': loc.approved,
      'rejected': loc.rejected,
    };
    return Column(
      children: [
        SizedBox(height: 12.h),
        BlocBuilder<ServiceRequestsListCubit, ServiceRequestsListState>(
          buildWhen: (prev, curr) => prev.status != curr.status,
          builder: (context, state) {
            return CustomDropdown(
              hint: loc.status_all,
              color: AppColor.whiteColor,
              items: statusLabels.values.toList(),
              selectedValue: statusLabels[state.status],
              onChanged: (label) {
                // من التسمية المعروضة → القيمة الإنجليزية المُرسَلة
                final entry = statusLabels.entries.firstWhere(
                  (e) => e.value == label,
                  orElse: () => MapEntry('all', loc.all),
                );
                context.read<ServiceRequestsListCubit>().setStatus(entry.key);
              },
            );
          },
        ),
      ],
    );
  }
}
