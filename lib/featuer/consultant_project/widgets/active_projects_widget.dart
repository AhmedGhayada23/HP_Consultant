import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/active_project_cubit/active_project_cubit.dart';
import 'package:hb/core/cubit/active_project_cubit/active_project_state.dart';
import 'package:hb/core/data/models/active_project_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/featuer/consultant_project/presentation/project_details_view.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ActiveProjectsWidget extends StatelessWidget {
  const ActiveProjectsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveProjectCubit, ActiveProjectState>(
      builder: (context, state) {
        final bool loading = state.loading ?? false;

        // ✅ Skeleton أثناء التحميل
        if (loading) {
          final fake = List.generate(3, (_) => ActiveProjectModel());
          return Skeletonizer(enabled: true, child: _buildList(context, fake));
        }

        final data = state.data ?? [];

        // ✅ EmptyState لو فش داتا
        if (data.isEmpty) {
          return EmptyStateWidget(
            title: AppLocalizations.of(context)!.noActiveProjects,
            subtitle: AppLocalizations.of(context)!.addNewProjectHint,
            icon: Icons.folder_open_outlined,
            actionButtonText: AppLocalizations.of(context)!.addProject,
          );
        }

        return _buildList(context, data);
      },
    );
  }

  Widget _buildList(BuildContext context, List<ActiveProjectModel> data) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        final item = data[index];
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProjectDetailsView(activeProjectModel: item),
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title ?? '',
                  style: MyTextStyle().textStyleSemiBold16(),
                ),
                DashedLine(),
                SizedBox(height: 20.h),
                _infoRow(
                  context,
                  AppLocalizations.of(context)!.deadline,
                  item.deadline ?? '',
                ),
                SizedBox(height: 20.h),
                _infoRow(
                  context,
                  AppLocalizations.of(context)!.assign_consultant,
                  item.assignedConsultants ?? '',
                ),
                SizedBox(height: 20.h),
                _infoRow(
                  context,
                  AppLocalizations.of(context)!.budget,
                  item.budget ?? '',
                ),
                SizedBox(height: 20.h),
                _infoRow(
                  context,
                  AppLocalizations.of(context)!.status,
                  item.status ?? '',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:', style: MyTextStyle().textStyleRegular14()),
        SizedBox(width: 8.w),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: MyTextStyle().textStyleMedium14(),
          ),
        ),
      ],
    );
  }
}
