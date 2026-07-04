import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/consultant_requests_cubit/consultant_requests_cubit.dart';
import 'package:hb/core/cubit/consultant_requests_cubit/consultant_requests_state.dart';
import 'package:hb/core/data/models/consultant_request_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RequestedCounsultantCard extends StatelessWidget {
  const RequestedCounsultantCard({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocBuilder<ConsultantRequestsCubit, ConsultantRequestsState>(
      builder: (context, state) {
        final loading = state.loading ?? false;

        if (!loading && state.data != null && state.data!.isEmpty) {
          return EmptyStateWidget(
            title: loc.no_data_available,
            icon: Icons.inbox_outlined,
          );
        }

        final data = state.data ??
            List.generate(3, (_) => ConsultantRequestModel(
                  projectTitle: 'Project title',
                  requestId: 'SR-0000',
                  serviceType: 'Service type',
                  dateSubmitted: '01 Jan 2025',
                  consultantRequested: 'Consultant name',
                  budget: '€000',
                  status: 'Pending',
                ));

        return Skeletonizer(
          enabled: loading,
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final req = data[index];
              return Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: AppColor.whiteColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            req.projectTitle,
                            style: MyTextStyle().textStyleSemiBold16(),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        if (req.budget.isNotEmpty)
                          Text(
                            req.budget,
                            style: MyTextStyle()
                                .textStyleSemiBold16()
                                .copyWith(color: AppColor.k1primeryColor),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      req.consultantRequested,
                      style: MyTextStyle().textStyleRegular14(),
                    ),
                    DashedLine(),
                    SizedBox(height: 20.h),
                    if (req.requestId.isNotEmpty) ...[
                      InfoRow(label: '${loc.request_id}: ', value: req.requestId),
                      SizedBox(height: 12.h),
                    ],
                    if (req.serviceType.isNotEmpty) ...[
                      InfoRow(label: '${loc.service_type}: ', value: req.serviceType),
                      SizedBox(height: 12.h),
                    ],
                    if (req.pricingType.isNotEmpty) ...[
                      InfoRow(label: '${loc.pricing_type}: ', value: req.pricingType),
                      SizedBox(height: 12.h),
                    ],
                    if (req.dateSubmitted.isNotEmpty) ...[
                      InfoRow(label: '${loc.date_submitted}: ', value: req.dateSubmitted),
                      SizedBox(height: 12.h),
                    ],
                    if (req.preferredDeadline.isNotEmpty) ...[
                      InfoRow(label: '${loc.deadline}: ', value: req.preferredDeadline),
                      SizedBox(height: 12.h),
                    ],
                    InfoRow(label: '${loc.status}: ', value: req.status),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 10.h),
            itemCount: data.length,
          ),
        );
      },
    );
  }
}
