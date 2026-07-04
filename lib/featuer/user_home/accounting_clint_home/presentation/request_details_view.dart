import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/edit_service_request_cubit/edit_service_request_cubit.dart';
import 'package:hb/core/cubit/service_request_details_cubit/service_request_details_cubit.dart';
import 'package:hb/core/cubit/service_request_details_cubit/service_request_details_state.dart';
import 'package:hb/core/data/models/service_request_item_model.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/featuer/user_home/accounting_clint_home/presentation/edit_service_request_view.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:hb/utils/universal_downloader.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vector_graphics/vector_graphics.dart';

class RequestDetailsView extends StatefulWidget {
  const RequestDetailsView({super.key});

  @override
  State<RequestDetailsView> createState() => _RequestDetailsViewState();
}

class _RequestDetailsViewState extends State<RequestDetailsView> {
  @override
  void initState() {
    super.initState();
    context.read<ServiceRequestDetailsCubit>().fetchDetails();
  }

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('submit')) return const Color(0xffE5A000);
    if (s.contains('progress')) return AppColor.k1primeryColor;
    if (s.contains('complete') || s.contains('approv')) {
      return const Color(0xff2E7D32);
    }
    if (s.contains('cancel') || s.contains('reject')) {
      return AppColor.countNotificationBgColor;
    }
    if (s.contains('pending')) return const Color(0xffE5A000);
    return AppColor.blackColor;
  }

  // فتح صفحة تعديل الطلب مع تعبئة البيانات، وتحديث التفاصيل بعد الحفظ
  void _openEdit(ServiceRequestItemModel req) {
    final detailsCubit = context.read<ServiceRequestDetailsCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => EditServiceRequestCubit()..prefill(req),
          child: EditServiceRequestView(
            requestId: req.id,
            onSaved: () => detailsCubit.fetchDetails(),
          ),
        ),
      ),
    );
  }

  // تأكيد ثم إلغاء الطلب وتحديث التفاصيل عند النجاح
  void _confirmCancel(ServiceRequestItemModel req) {
    final loc = AppLocalizations.of(context)!;
    final cubit = context.read<ServiceRequestDetailsCubit>();
    showConfirmDialog(
      context,
      title: loc.cancel_request,
      subTitle: loc.cancel_request_confirm_subtitle,
      confirmText: loc.cancel_request,
      onConfirm: () => cubit.cancelRequest(context),
    );
  }

  Future<void> _downloadFile(BuildContext context, String url) async {
    if (url.isEmpty) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    final ok = await UniversalDownloader().downloadFile(
      url: url,
      saveToGallery: false,
    );
    if (!context.mounted) return;
    Navigator.pop(context);
    final loc = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? loc.file_downloaded_successfully : loc.download_failed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColor.gray5,
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        title: Text(
          loc.request_details,
          style: MyTextStyle().textStyleSemiBold20().copyWith(color: AppColor.whiteColor),
        ),
      ),
      body: BlocBuilder<ServiceRequestDetailsCubit, ServiceRequestDetailsState>(
        builder: (context, state) {
          final loading = state.loading;
          final req = state.data ??
              ServiceRequestItemModel(
                requestId: 'SR-0000',
                serviceType: 'Service type',
                submittedOn: '01 Jan 2026',
                preferredDeadline: '01 Jan 2026',
                proposedBudget: '€000',
                status: 'Submitted',
                description: 'Request description placeholder text here.',
              );
          return RefreshIndicator(
            color: AppColor.k1primeryColor,
            onRefresh: () =>
                context.read<ServiceRequestDetailsCubit>().fetchDetails(),
            child: Skeletonizer(
              enabled: loading,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                child: Column(
                  children: [
                    _detailsCard(loc, req),
                    if (req.requestFiles.isNotEmpty) ...[
                      SizedBox(height: 20.h),
                      _filesCard(req),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<ServiceRequestDetailsCubit, ServiceRequestDetailsState>(
        builder: (context, state) => _bottomBar(loc, state.data, state.cancelling),
      ),
    );
  }

  Widget _detailsCard(AppLocalizations loc, ServiceRequestItemModel req) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColor.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoRow(label: loc.request_id, value: req.requestId),
          SizedBox(height: 16.h),
          InfoRow(label: loc.service_type, value: req.serviceType),
          SizedBox(height: 16.h),
          InfoRow(label: loc.submitted_on, value: req.submittedOn),
          SizedBox(height: 16.h),
          InfoRow(label: loc.preferred_deadline, value: req.preferredDeadline),
          SizedBox(height: 16.h),
          InfoRow(label: loc.proposed_budget, value: req.proposedBudget),
          SizedBox(height: 16.h),
          InfoRow(
            label: loc.status,
            value: req.status,
            valueColor: _statusColor(req.status),
          ),
          SizedBox(height: 16.h),
          Text(loc.description, style: MyTextStyle().textStyleRegular14()),
          SizedBox(height: 8.h),
          Text(req.description, style: MyTextStyle().textStyleSemiBold16()),
        ],
      ),
    );
  }

  Widget _filesCard(ServiceRequestItemModel req) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColor.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.request_files, style: MyTextStyle().textStyleSemiBold16()),
          DashedLine(),
          SizedBox(height: 12.h),
          ...req.requestFiles.map(
            (f) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColor.gray5,
                  borderRadius: BorderRadius.circular(16.r),
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
                          color: AppColor.k1primeryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: VectorGraphic(
                              loader: AssetBytesLoader(AppSvg.fileSvg)),
                        ),
                      ),
                      title: Text(f.fileName,
                          style: MyTextStyle().textStyleRegular14()),
                      subtitle: Text(f.fileType,
                          style: MyTextStyle().textStyleRegular11()),
                    ),
                    SizedBox(height: 12.h),
                    CustomButtonBorder(
                      onTap: () => _downloadFile(context, f.url),
                      borderColor: AppColor.k1primeryColor,
                      text: loc.download_file,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar(
      AppLocalizations loc, ServiceRequestItemModel? req, bool cancelling) {
    final status = (req?.status ?? '').toLowerCase();

    Widget child;
    if (status.contains('progress')) {
      child = CustomButton(
        onTap: () {},
        color: AppColor.k1primeryColor,
        text: loc.approve_mark_completed,
      );
    } else if (status.contains('complete')) {
      child = CustomButton(
        onTap: () =>
            Navigator.pushNamed(context, MyRoutes().requestNewServiceView),
        color: AppColor.k1primeryColor,
        text: loc.request_another_service,
      );
    } else if ((req?.canEdit ?? false) || (req?.canCancel ?? false)) {
      child = Row(
        children: [
          if (req?.canEdit ?? false)
            Expanded(
              child: CustomButton(
                onTap: () => _openEdit(req!),
                color: AppColor.k1primeryColor,
                text: loc.edit_request,
              ),
            ),
          if ((req?.canEdit ?? false) && (req?.canCancel ?? false))
            SizedBox(width: 8.w),
          if (req?.canCancel ?? false)
            Expanded(
              child: CustomButtonBorder(
                onTap: cancelling ? () {} : () => _confirmCancel(req!),
                borderColor: AppColor.countNotificationBgColor,
                text: cancelling ? loc.cancelling : loc.cancel_request,
              ),
            ),
        ],
      );
    } else {
      child = CustomButton(
        onTap: () =>
            Navigator.pushNamed(context, MyRoutes().requestNewServiceView),
        color: AppColor.k1primeryColor,
        text: loc.request_another_service,
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        boxShadow: [BoxShadow(color: AppColor.borderColor, offset: Offset(0, -3))],
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}
