import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/consultant_meeting_request_cubit/consultant_meeting_request_cubit.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/l10n/app_localizations.dart';

class FiltterMeetingRequest extends StatelessWidget {
  const FiltterMeetingRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    // العرض مترجم، والقيمة المُرسَلة للخادم بالإنجليزية فقط
    final categories = {
      loc.category_development: 'Development',
      loc.category_consulting: 'Consulting',
      loc.category_design: 'Design',
      loc.category_training: 'Training',
      loc.category_audit: 'Audit',
      loc.category_other: 'Other',
    };
    final statuses = {
      loc.all: null, // الكل → بدون فلتر
      loc.in_review: 'In Review',
      loc.cancelled: 'Cancelled',
      loc.assigned: 'Assigned',
    };

    return Column(
      children: [
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomDropdown(
                hint: loc.category,
                items: categories.keys.toList(),
                color: AppColor.whiteColor,
                onChanged: (value) => context
                    .read<ConsultantMeetingRequestCubit>()
                    .fetchConsultantMeetingRequest(category: categories[value]),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: CustomDropdown(
                hint: loc.status_all,
                items: statuses.keys.toList(),
                color: AppColor.whiteColor,
                onChanged: (value) => context
                    .read<ConsultantMeetingRequestCubit>()
                    .fetchConsultantMeetingRequest(status: statuses[value]),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),
      ],
    );
  }
}
