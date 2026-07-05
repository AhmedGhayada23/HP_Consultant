import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/hb_lab_project_accounting_cubit/hb_lab_project_accounting_cubit.dart';
import 'package:hb/core/cubit/hb_lab_project_accounting_cubit/hb_lab_project_accounting_state.dart';
import 'package:hb/core/data/models/hb_lab_project_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/featuer/hb_lab_accounting/presentation/details_hb_lab_project_accounting.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HbLabProjectAccounting extends StatelessWidget {
  const HbLabProjectAccounting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HbLabProjectAccountingCubit, HbLabProjectAccountingState>(
      builder: (context, state) {
        final loc = AppLocalizations.of(context)!;
        if (state.errorMessage != null && !state.loading) {
          return EmptyStateWidget(
            title: loc.failed_to_load_projects,
            subtitle: state.errorMessage,
            icon: Icons.error_outline,
            actionButtonText: loc.retry,
            onActionPressed: () =>
                context.read<HbLabProjectAccountingCubit>().fetchHbLabProject(),
          );
        }

        final isLoading = state.loading && state.data.isEmpty;
        final items = isLoading
            ? List.generate(3, (_) => HbLabProjectModel.fake())
            : state.data;

        if (!isLoading && items.isEmpty) {
          return EmptyStateWidget(
            title: loc.no_hb_lab_projects,
            subtitle: loc.no_hb_lab_projects,
            icon: Icons.folder_open_outlined,
          );
        }

        return Skeletonizer(
          enabled: isLoading,
          child: Column(
            children: [
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.category ?? '',
                          style: MyTextStyle()
                              .textStyleMedium14()
                              .copyWith(color: AppColor.h1Color),
                        ),
                        Text(item.title ?? '',
                            style: MyTextStyle().textStyleSemiBold16()),
                        DashedLine(),
                        SizedBox(height: 20.h),
                        InfoRow(label: '${loc.status}: ', value: item.status ?? ''),
                        SizedBox(height: 8.h),
                        InfoRow(label: '${loc.deadline}: ', value: item.deadline ?? ''),
                        if (item.budget != null) ...[
                          SizedBox(height: 8.h),
                          InfoRow(label: '${loc.budget}: ', value: item.budget!),
                        ],
                        SizedBox(height: 20.h),
                        CustomButtonBorder(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailsHbLabProjectAccounting(
                                  hbLabProjectModel: item),
                            ),
                          ),
                          borderColor: AppColor.k1primeryColor,
                          text: loc.view_details,
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (state.loadingMore)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: const CircularProgressIndicator(),
                ),
              if (!state.hasMore && items.isNotEmpty && !isLoading)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    loc.all_projects_loaded(state.total),
                    style: MyTextStyle()
                        .textStyleRegular14()
                        .copyWith(color: Colors.grey),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
