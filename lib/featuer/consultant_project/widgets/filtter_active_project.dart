import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/active_project_cubit/active_project_cubit.dart';
import 'package:hb/core/cubit/consultant_project_cubit/consultant_project_cubit.dart';
import 'package:hb/core/cubit/consultant_project_cubit/consultant_project_state.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/date_picker_field.dart';
import 'package:hb/l10n/app_localizations.dart';

class FiltterActiveProject extends StatefulWidget {
  const FiltterActiveProject({super.key});

  @override
  State<FiltterActiveProject> createState() => _FiltterActiveProjectState();
}

class _FiltterActiveProjectState extends State<FiltterActiveProject> {
  String? _selectedStatus; // canonical (active / closed ...) أو null للكل
  String? _selectedConsultant; // اسم المستشار أو null للكل
  final _deadlineController = TextEditingController();

  void _applyFilter() {
    context.read<ActiveProjectCubit>().fetchActiveProject(
          status: _selectedStatus,
          consultant: _selectedConsultant,
        );
  }

  @override
  void dispose() {
    _deadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    // العرض مترجم، والقيمة المُرسَلة للخادم بالإنجليزية فقط
    final statuses = {
      loc.all: null,
      loc.active: 'active',
      loc.closed: 'closed',
      loc.planning: 'planning',
      loc.completed: 'completed',
    };

    return Column(
      children: [
        SizedBox(height: 12.h),
        // Status لحاله
        CustomDropdown(
          hint: loc.status_all,
          items: statuses.keys.toList(),
          color: AppColor.whiteColor,
          onChanged: (value) {
            _selectedStatus = statuses[value];
            _applyFilter();
          },
        ),
        SizedBox(height: 12.h),
        // Consultant + Deadline جمب بعض
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<ConsultantProjectCubit, ConsultantProjectState>(
                builder: (context, state) {
                  // خيار "الكل" مترجم + أسماء المستشارين كما هي
                  final map = <String, String?>{loc.all: null};
                  for (final c in state.consultantProjectData ?? []) {
                    if (c.name.isNotEmpty) map[c.name] = c.name;
                  }
                  return CustomDropdown(
                    hint: loc.consultant,
                    items: map.keys.toList(),
                    color: AppColor.whiteColor,
                    onChanged: (value) {
                      _selectedConsultant = map[value];
                      _applyFilter();
                    },
                  );
                },
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: DatePickerField(
                controller: _deadlineController,
                label: loc.deadline,
                onDatePicked: (date) {
                  context.read<ActiveProjectCubit>().fetchActiveProject(
                        deadlineTo: date.toString(),
                        status: _selectedStatus,
                        consultant: _selectedConsultant,
                      );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
