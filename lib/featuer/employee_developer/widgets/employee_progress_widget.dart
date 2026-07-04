import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/employee_progress_cubit/employee_progress_cubit.dart';
import 'package:hb/core/cubit/employee_progress_cubit/employee_progress_state.dart';
import 'package:hb/core/data/models/employee_progress_model.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/featuer/employee_developer/widgets/card_employee_progress_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EmployeeProgressWidget extends StatelessWidget {
  const EmployeeProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeProgressCubit, EmployeeProgressState>(
      builder: (context, state) {
        // ─── Error ────────────────────────────────────────────────
        final loc = AppLocalizations.of(context)!;
        if (state.errorMessage != null) {
          return Center(
            child: Column(
              children: [
                Text(state.errorMessage!),
                TextButton(
                  onPressed: () => context.read<EmployeeProgressCubit>().fetchEmployeesProgress(),
                  child: Text(loc.retry),
                ),
              ],
            ),
          );
        }

        // ─── Loading → fake | Loaded → real ──────────────────────
        final data = state.employees ?? List.generate(3, (_) => EmployeeProgressModel.fake());

        // ─── Empty ────────────────────────────────────────────────
        if (!state.loading && data.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.track_changes_outlined,
            title: loc.no_data_available,
            subtitle: loc.no_data_available,
          );
        }

        return Skeletonizer(
          enabled: state.loading,
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (_, index) => CardEmployeeProgressWidget(employee: data[index]),
          ),
        );
      },
    );
  }
}
