import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/hb_lab_ideas_box_accounting_cubit/hb_lab_ideas_box_accounting_cubit.dart';
import 'package:hb/core/cubit/hb_lab_ideas_box_accounting_cubit/hb_lab_ideas_box_accounting_state.dart';
import 'package:hb/core/data/models/hb_lab_ideas_box_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/featuer/hb_lab_accounting/presentation/details_ideas_box_accounting_view.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class IdeasBoxAccounting extends StatelessWidget {
  const IdeasBoxAccounting({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocBuilder<HbLabIdeasBoxAccountingCubit, HbLabIdeasBoxAccountingState>(
      builder: (context, state) {
        if (state.errorMessage != null && !state.loading) {
          return EmptyStateWidget(
            title: loc.failed_to_load_jobs,
            subtitle: state.errorMessage,
            icon: Icons.error_outline,
            actionButtonText: loc.retry,
            onActionPressed: () =>
                context.read<HbLabIdeasBoxAccountingCubit>().fetchHbLabIdeasBox(),
          );
        }

        final isLoading = state.loading && state.data.isEmpty;
        final items = isLoading
            ? List.generate(3, (_) => HbLabIdeasBoxModel.fake())
            : state.data;

        if (!isLoading && items.isEmpty) {
          return EmptyStateWidget(
            title: loc.no_ideas_yet,
            subtitle: loc.no_ideas_yet,
            icon: Icons.lightbulb_outline,
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
                        if (item.authorName != null && item.authorName!.isNotEmpty)
                          Text(
                            '${loc.author}: ${item.authorName}',
                            style: MyTextStyle()
                                .textStyleMedium14()
                                .copyWith(color: AppColor.h1Color),
                          ),
                        Text(item.title ?? '',
                            style: MyTextStyle().textStyleSemiBold16()),
                        DashedLine(),
                        SizedBox(height: 20.h),
                        InfoRow(
                            label: '${loc.submitted_on}: ',
                            value: item.submittedOnDisplay ?? ''),
                        SizedBox(height: 8.h),
                        InfoRow(
                            label: '${loc.votes}: ',
                            value: '${item.votesCount ?? 0}'),
                        SizedBox(height: 8.h),
                        InfoRow(
                            label: '${loc.status}: ', value: item.statusLabel ?? ''),
                        if (item.tags != null && item.tags!.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Wrap(
                            spacing: 6.w,
                            runSpacing: 4.h,
                            children: item.tags!
                                .map(
                                  (tag) => Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: AppColor.k1primeryColor
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      tag,
                                      style: MyTextStyle()
                                          .textStyleRegularColored12(AppColor.k1primeryColor),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          DetailsIdeasBoxAccountingView(
                                            ideaId: item.id ?? 0,
                                          )),
                                ),
                                color: AppColor.k1primeryColor,
                                text: loc.view_details,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: item.userHasUpvoted
                                  ? CustomButton(
                                      onTap: () => context
                                          .read<HbLabIdeasBoxAccountingCubit>()
                                          .toggleUpvote(item.id!),
                                      color: AppColor.k1primeryColor,
                                      text: '${loc.upvoted} ✓',
                                    )
                                  : CustomButtonBorder(
                                      onTap: () => context
                                          .read<HbLabIdeasBoxAccountingCubit>()
                                          .toggleUpvote(item.id!),
                                      borderColor: AppColor.k1primeryColor,
                                      text: loc.upvote,
                                    ),
                            ),
                          ],
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
                    'All ${state.total} ideas loaded',
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
