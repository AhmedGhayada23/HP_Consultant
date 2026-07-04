import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/active_project_cubit/active_project_cubit.dart';
import 'package:hb/core/cubit/active_project_cubit/active_project_state.dart';
import 'package:hb/core/cubit/consultant_project_cubit/consultant_project_cubit.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/l10n/app_localizations.dart';

class FiltterConsultantProject extends StatefulWidget {
  const FiltterConsultantProject({super.key});

  @override
  State<FiltterConsultantProject> createState() => _FiltterConsultantProjectState();
}

class _FiltterConsultantProjectState extends State<FiltterConsultantProject> {
  String? _selectedStatus; // canonical (active / on_hold ...)
  String? _selectedProject; // project id
  String? _selectedRole; // canonical (finance ...)

  void _applyFilter() {
    context.read<ConsultantProjectCubit>().fetchConsultantProject(
          status: _selectedStatus,
          project: _selectedProject,
          role: _selectedRole,
        );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    // العرض مترجم، والقيمة المُرسَلة للخادم بالإنجليزية فقط
    final statuses = {
      loc.all: null, // all → بدون فلتر
      loc.active: 'active',
      loc.on_hold: 'on_hold',
    };
    final roles = {
      loc.all: null,
      loc.finance: 'finance',
    };

    return Column(
      children: [
        SizedBox(height: 12.h),
        // الحالة
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // المشروع — يُقرأ من قائمة المشاريع النشطة (العرض بالعنوان، الإرسال بالـ id)
            Expanded(
              child: BlocBuilder<ActiveProjectCubit, ActiveProjectState>(
                builder: (context, state) {
                  final projects = state.data ?? [];
                  // العنوان → id (all → null)
                  final map = <String, String?>{loc.all: null};
                  for (final p in projects) {
                    if ((p.title ?? '').isNotEmpty) {
                      map[p.title!] = p.id?.toString();
                    }
                  }
                  return CustomDropdown(
                    hint: '${loc.project} | ${loc.all}',
                    items: map.keys.toList(),
                    color: AppColor.whiteColor,
                    onChanged: (value) {
                      _selectedProject = map[value];
                      _applyFilter();
                    },
                  );
                },
              ),
            ),
            SizedBox(width: 8.w),
            // الدور
            Expanded(
              child: CustomDropdown(
                hint: '${loc.role} | ${loc.all}',
                items: roles.keys.toList(),
                color: AppColor.whiteColor,
                onChanged: (value) {
                  _selectedRole = roles[value];
                  _applyFilter();
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
