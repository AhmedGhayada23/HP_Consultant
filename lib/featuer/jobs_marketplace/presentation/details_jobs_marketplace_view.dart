import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/details_jobs_marketplace_cubit/details_jobs_marketplace_cubit.dart';
import 'package:hb/core/cubit/details_jobs_marketplace_cubit/details_jobs_marketplace_state.dart';
import 'package:hb/core/data/models/details_jobs_marketplace_model.dart';
import 'package:hb/core/data/models/recommended_jos_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/featuer/jobs_marketplace/presentation/apple_now_job_view.dart';
import 'package:hb/utils/universal_downloader.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vector_graphics/vector_graphics.dart';

class DetailsJobsMarketplaceView extends StatefulWidget {
  final RecommendedJobModel recommendedJobModel;
  const DetailsJobsMarketplaceView({super.key, required this.recommendedJobModel});

  @override
  State<DetailsJobsMarketplaceView> createState() =>
      _DetailsJobsMarketplaceViewState();
}

class _DetailsJobsMarketplaceViewState
    extends State<DetailsJobsMarketplaceView> {
  final UniversalDownloader _downloader = UniversalDownloader();

  @override
  void initState() {
    super.initState();
    context
        .read<DetailsJobsMarketplaceCubit>()
        .fetchDetailsJobsMarketplace(widget.recommendedJobModel.id);
  }

  Future<void> _downloadFile(BuildContext context, String url) async {
    final loc = AppLocalizations.of(context)!;
    if (url.isEmpty) {
      showCustomSnackBar(context, loc.no_file_available, SnackBarType.error);
      return;
    }
    if (_downloader.isDownloading) return;
    showCustomSnackBar(context, loc.downloading, SnackBarType.warning);
    final ok = await _downloader.downloadFile(url: url, saveToGallery: false);
    if (!context.mounted) return;
    showCustomSnackBar(
      context,
      ok ? loc.file_downloaded_successfully : loc.download_failed,
      ok ? SnackBarType.success : SnackBarType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocBuilder<DetailsJobsMarketplaceCubit, DetailsJobsMarketplaceState>(
      builder: (context, state) {
        final fakeData = DetailsJobsMarketplaceModel.fake();
        final job = state.data ?? fakeData;
        final isLoading = state.loading;

        return Skeletonizer(
          enabled: isLoading,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.blackColor,
              iconTheme: const IconThemeData(color: AppColor.whiteColor),
              title: Text(
                loc.job_details,
                style: MyTextStyle()
                    .textStyleSemiBold20()
                    .copyWith(color: AppColor.whiteColor),
              ),
            ),
            bottomNavigationBar: Container(
              height: 100.h,
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    offset: const Offset(0, -3),
                    color: AppColor.borderColor,
                  ),
                ],
              ),
              child: CustomButton(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AppleNowJobView(
                        recommendedJobModel: widget.recommendedJobModel),
                  ),
                ),
                color: AppColor.k1primeryColor,
                text: loc.apply_now,
              ),
            ),
            body: state.errorMessage != null && !isLoading
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: EmptyStateWidget(
                        title: loc.failed_to_load_job_details,
                        subtitle: state.errorMessage,
                        icon: Icons.cloud_off_outlined,
                        actionButtonText: loc.retry,
                        onActionPressed: () => context
                            .read<DetailsJobsMarketplaceCubit>()
                            .fetchDetailsJobsMarketplace(
                                widget.recommendedJobModel.id),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoRow(
                              label: loc.job_title,
                              value: job.title ?? ''),
                          SizedBox(height: 20.h),
                          InfoRow(
                              label: loc.type,
                              value: job.jobTypeLabel ?? ''),
                          SizedBox(height: 20.h),
                          InfoRow(
                              label: loc.budget,
                              value: job.budgetDisplay ?? ''),
                          SizedBox(height: 20.h),
                          InfoRow(
                              label: loc.deadline,
                              value: job.deadlineDisplay ?? ''),
                          SizedBox(height: 20.h),
                          InfoRow(
                              label: loc.status,
                              value: job.statusLabel ?? ''),
                          if (job.companyName != null) ...[
                            SizedBox(height: 20.h),
                            InfoRow(
                                label: loc.company,
                                value: job.companyName!),
                          ],
                          if (job.companyLocation != null) ...[
                            SizedBox(height: 20.h),
                            InfoRow(
                                label: loc.company_location,
                                value: job.companyLocation!),
                          ],
                          if (job.jobLocation != null) ...[
                            SizedBox(height: 20.h),
                            InfoRow(
                                label: loc.job_location,
                                value: job.jobLocation!),
                          ],
                          SizedBox(height: 20.h),
                          Text(loc.description,
                              style: MyTextStyle().textStyleMedium14()),
                          SizedBox(height: 8.h),
                          Text(
                            job.description ?? '',
                            style: MyTextStyle().textStyleMedium15(),
                          ),

                          if (job.skills.isNotEmpty) ...[
                            SizedBox(height: 20.h),
                            Text(loc.required_skills,
                                style: MyTextStyle().textStyleMedium14()),
                            SizedBox(height: 12.h),
                            Wrap(
                              spacing: 8.r,
                              runSpacing: 8.r,
                              children: job.skills
                                  .map(
                                    (skill) => Chip(
                                      backgroundColor: AppColor.gray5,
                                      side: BorderSide.none,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                      ),
                                      label: Text(
                                        skill,
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

                          if (job.projectFiles.isNotEmpty) ...[
                            DashedLine(),
                            SizedBox(height: 20.h),
                            Text(loc.project_files_deliverables,
                                style: MyTextStyle().textStyleMedium16()),
                            SizedBox(height: 20.h),
                            ListView.separated(
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: job.projectFiles.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 10.h),
                              itemBuilder: (context, index) => Container(
                                padding: EdgeInsets.all(16.r),
                                decoration: BoxDecoration(
                                  color: AppColor.gray5,
                                  borderRadius:
                                      BorderRadius.circular(16.r),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      minLeadingWidth: 0,
                                      minTileHeight: 0,
                                      minVerticalPadding: 0,
                                      contentPadding: EdgeInsets.zero,
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
                                                AppSvg.fileSvg),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        job.projectFiles[index].name,
                                        style: MyTextStyle()
                                            .textStyleRegular14(),
                                      ),
                                      subtitle: Text(loc.pdf_file,
                                          style: MyTextStyle()
                                              .textStyleRegular11()),
                                    ),
                                    SizedBox(height: 12.h),
                                    CustomButtonBorder(
                                      onTap: () => _downloadFile(
                                        context,
                                        job.projectFiles[index].url,
                                      ),
                                      borderColor: AppColor.k1primeryColor,
                                      text: loc.download_file,
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
}
