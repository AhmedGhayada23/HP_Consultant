import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/consultant_meeting_request_cubit/consultant_meeting_request_cubit.dart';
import 'package:hb/core/cubit/consultant_meeting_request_cubit/consultant_meeting_request_state.dart';
import 'package:hb/core/data/models/consultant_meeting_request_modle.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/featuer/consultant_project/presentation/consultant_meeting_requests_details.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ConsultantMeetingRequestsWidget extends StatelessWidget {
  const ConsultantMeetingRequestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsultantMeetingRequestCubit, ConsultantMeetingRequestState>(
      builder: (context, state) {
        final loc = AppLocalizations.of(context)!;

        // loading
        if (state.loading == true) {
          return Skeletonizer(
            enabled: true,
            child: _buildList(context, List.generate(3, (_) => ConsultantMeetingRequestModel.fake())),
          );
        }

        final data = state.data ?? [];

        // empty
        if (data.isEmpty) {
          return EmptyStateWidget(
            title: loc.meeting_requests_empty_title,
            subtitle: loc.meeting_requests_empty_subtitle,
            icon: Icons.calendar_today_outlined,
          );
        }

        return _buildList(context, data);
      },
    );
  }

  Widget _buildList(BuildContext context, List<ConsultantMeetingRequestModel> data) {
    final loc = AppLocalizations.of(context)!;

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
              builder: (context) => ConsultantMeetingRequestsDetails(
                consultantMeetingRequestModel: item,
              ),
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
                Text(item.title, style: MyTextStyle().textStyleSemiBold16()),
                const DashedLine(),
                SizedBox(height: 20.h),
                _infoRow(loc.category, item.category),
                SizedBox(height: 20.h),
                _infoRow(loc.created_on, item.createdOn),
                SizedBox(height: 20.h),
                _infoRow(loc.assign_consultant, item.assignedConsultants),
                SizedBox(height: 20.h),
                _infoRow(loc.status, item.statusLabel),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label:', style: MyTextStyle().textStyleRegular14()),
        Text(value, style: MyTextStyle().textStyleMedium14()),
      ],
    );
  }
}
