import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/core/cubit/details_ideas_box_cubit/details_ideas_box_cubit.dart';
import 'package:hb/core/cubit/details_ideas_box_cubit/details_ideas_box_state.dart';
import 'package:hb/core/data/models/details_ideas_box_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/featuer/file_web_view/file_web_view.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vector_graphics/vector_graphics.dart';

class DetailsIdeasBoxView extends StatelessWidget {
  final int ideaId;
  const DetailsIdeasBoxView({super.key, required this.ideaId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DetailsIdeasBoxCubit(consultant: true)..fetchDetailsIdeasBox(ideaId),
      child: const _DetailsIdeasBoxBody(),
    );
  }
}

class _DetailsIdeasBoxBody extends StatefulWidget {
  const _DetailsIdeasBoxBody();

  @override
  State<_DetailsIdeasBoxBody> createState() => _DetailsIdeasBoxBodyState();
}

class _DetailsIdeasBoxBodyState extends State<_DetailsIdeasBoxBody> {
  static const _commentsPerPage = 5;
  int _commentPage = 0;

  // فتح/عرض الملف داخل الـ WebView (بدون تحميل)
  void _viewFile(BuildContext context, String url, String name) {
    if (url.isEmpty) {
      showCustomSnackBar(
        context,
        AppLocalizations.of(context)!.no_file_available,
        SnackBarType.error,
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FileWebViewPage(fileName: name, fileUrl: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocBuilder<DetailsIdeasBoxCubit, DetailsIdeasBoxState>(
      builder: (context, state) {
        final isLoading = state.loading;
        final idea = isLoading
            ? DetailsIdeasBoxModel.fake()
            : state.data;

        if (state.errorMessage != null && !isLoading) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.blackColor,
              iconTheme: IconThemeData(color: AppColor.whiteColor),
              title: Text(
                loc.title,
                style: MyTextStyle()
                    .textStyleSemiBold20()
                    .copyWith(color: AppColor.whiteColor),
              ),
            ),
            body: EmptyStateWidget(
              title: loc.failed_to_load_idea,
              subtitle: state.errorMessage,
              icon: Icons.error_outline,
              actionButtonText: loc.retry,
              onActionPressed: () => context
                  .read<DetailsIdeasBoxCubit>()
                  .fetchDetailsIdeasBox(
                      (context.read<DetailsIdeasBoxCubit>().state.data?.id ??
                          0)),
            ),
          );
        }

        final comments = idea?.comments ?? [];
        final totalPages = (comments.length / _commentsPerPage).ceil();
        final safePage = totalPages == 0 ? 0 : _commentPage.clamp(0, totalPages - 1);
        final pageComments = comments.isEmpty
            ? <IdeaComment>[]
            : comments.sublist(
                safePage * _commentsPerPage,
                ((safePage + 1) * _commentsPerPage).clamp(0, comments.length),
              );

        return Skeletonizer(
          enabled: isLoading,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.blackColor,
              iconTheme: IconThemeData(color: AppColor.whiteColor),
              title: Text(
                idea?.title ?? '',
                style: MyTextStyle()
                    .textStyleSemiBold20()
                    .copyWith(color: AppColor.whiteColor),
              ),
              actions: [
                Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: (idea?.userHasUpvoted == true
                            ? AppColor.k1primeryColor
                            : AppColor.whiteColor)
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Center(
                    child: VectorGraphic(
                      loader: AssetBytesLoader(AppSvg.likeSvg),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
              ],
            ),
            bottomNavigationBar: Container(
              height: 100.h,
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                boxShadow: [
                  BoxShadow(color: Colors.white10, offset: Offset(0, -3))
                ],
              ),
              child: CustomButton(
                onTap: () => showAddCommentDialog(context, consultant: true),
                color: AppColor.k1primeryColor,
                text: loc.add_your_comment,
              ),
            ),
            body: SingleChildScrollView(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoRow(
                        label: loc.idea_title, value: idea?.title ?? ''),
                    SizedBox(height: 16.h),
                    InfoRow(
                        label: loc.author,
                        value: idea?.authorName ?? ''),
                    SizedBox(height: 16.h),
                    InfoRow(
                        label: loc.submitted_on,
                        value: idea?.submittedOnDisplay ?? ''),
                    SizedBox(height: 16.h),
                    InfoRow(
                        label: loc.status,
                        value: idea?.statusLabel ?? ''),
                    SizedBox(height: 16.h),
                    InfoRow(
                        label: loc.votes,
                        value: '${idea?.votesCount ?? 0}'),
                    if (idea?.tags != null &&
                        idea!.tags!.isNotEmpty) ...[
                      SizedBox(height: 20.h),
                      Text(loc.tags_label,
                          style: MyTextStyle().textStyleMedium14()),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.r,
                        runSpacing: 4.h,
                        children: idea.tags!
                            .map(
                              (tag) => Chip(
                                backgroundColor: AppColor.gray5,
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(4.r)),
                                label: Text(
                                  tag,
                                  style: MyTextStyle()
                                      .textStyleMedium16()
                                      .copyWith(
                                          color: AppColor.blackColor),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    if (idea?.description != null &&
                        idea!.description!.isNotEmpty) ...[
                      SizedBox(height: 20.h),
                      Text(loc.description,
                          style: MyTextStyle().textStyleMedium14()),
                      SizedBox(height: 8.h),
                      Text(
                        idea.description!,
                        style: MyTextStyle().textStyleMedium15(),
                      ),
                    ],
                    if (idea?.attachments != null &&
                        idea!.attachments!.isNotEmpty) ...[
                      SizedBox(height: 20.h),
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: AppColor.gray5,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          children: idea.attachments!
                              .map(
                                (att) => ListTile(
                                  minLeadingWidth: 0,
                                  minTileHeight: 0,
                                  minVerticalPadding: 0,
                                  contentPadding: EdgeInsets.zero,
                                  onTap: () => _viewFile(
                                    context,
                                    att.url ?? '',
                                    att.fileName ?? '',
                                  ),
                                  trailing: Icon(
                                    Icons.visibility_outlined,
                                    color: AppColor.k1primeryColor,
                                    size: 22.r,
                                  ),
                                  leading: Container(
                                    width: 39.w,
                                    height: 43.h,
                                    decoration: BoxDecoration(
                                      color: AppColor.k1primeryColor
                                          .withValues(alpha: 0.15),
                                      borderRadius:
                                          BorderRadius.circular(8.r),
                                    ),
                                    child: Center(
                                      child: VectorGraphic(
                                          loader: AssetBytesLoader(
                                              AppSvg.fileSvg)),
                                    ),
                                  ),
                                  title: Text(
                                    att.fileName ?? '',
                                    style: MyTextStyle()
                                        .textStyleRegular14(),
                                  ),
                                  subtitle: Text(
                                    att.typeLabel ?? '',
                                    style:
                                        MyTextStyle().textStyleRegular11(),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                    DashedLine(),
                    SizedBox(height: 20.h),
                    Text(loc.comments,
                        style: MyTextStyle().textStyleMedium14()),
                    SizedBox(height: 20.h),
                    if (comments.isEmpty && !isLoading)
                      Center(
                        child: Text(
                          loc.no_comments_yet,
                          style: MyTextStyle()
                              .textStyleRegular14()
                              .copyWith(color: Colors.grey),
                        ),
                      )
                    else
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: AppColor.gray5,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: pageComments.length,
                          itemBuilder: (context, index) {
                            final comment = pageComments[index];
                            return Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      comment.authorName ?? '',
                                      style: MyTextStyle()
                                          .textStyleSemiBold14(),
                                    ),
                                    Text(
                                      comment.createdAt ?? '',
                                      style: MyTextStyle()
                                          .textStyleMedium14(),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  comment.body ?? '',
                                  style:
                                      MyTextStyle().textStyleRegular14(),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (_, __) => DashedLine(),
                        ),
                      ),
                    if (totalPages > 1) ...[
                      SizedBox(height: 12.h),
                      _buildPaginator(totalPages, safePage),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaginator(int totalPages, int currentPage) {
    return NumberPaginator(
      numberPages: totalPages,
      initialPage: currentPage,
      onPageChange: (int index) {
        setState(() => _commentPage = index);
      },
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            PrevButton(
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColor.gray5,
                child: Icon(Icons.arrow_back_ios_new, size: 14.r),
              ),
            ),
            Expanded(
              child: NumberContent(
                buttonBuilder: (context, index, isSelected) => Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: isSelected ? 1 : 0,
                      color: isSelected
                          ? const Color(0xFF542198)
                          : Colors.transparent,
                    ),
                    color: isSelected
                        ? const Color(0xFFE9E1FF)
                        : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: MyTextStyle().textStyleMedium16().copyWith(
                            color: isSelected
                                ? const Color(0xFF542198)
                                : AppColor.blackColor,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            NextButton(
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColor.gray5,
                child:
                    Icon(Icons.arrow_forward_ios_outlined, size: 14.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
