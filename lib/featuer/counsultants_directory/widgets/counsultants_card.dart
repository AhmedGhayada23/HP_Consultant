import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/consultant_cubit/consultant_cubit.dart';
import 'package:hb/core/cubit/consultant_cubit/consultant_state.dart';
import 'package:hb/core/cubit/consultant_profile_cubit/consultant_profile_cubit.dart';
import 'package:hb/core/data/models/consultant_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/featuer/counsultants_directory/presentation/consultant_directory_profile_view.dart';
import 'package:hb/featuer/counsultants_directory/presentation/request_consultant_view.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CounsultantsCard extends StatelessWidget {
  const CounsultantsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocBuilder<ConsultantCubit, ConsultantState>(
      builder: (context, state) {
        final loading = state.loading ?? false;

        if (!loading && state.data != null && state.data!.isEmpty) {
          return EmptyStateWidget(
            title: loc.no_data_available,
            icon: Icons.inbox_outlined,
          );
        }

        final data = state.data ?? List.generate(3, (index) => ConsultantModel());
        return Skeletonizer(
          enabled: loading,
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      minLeadingWidth: 0,
                      minTileHeight: 0,
                      minVerticalPadding: 0,
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 36.r,
                        backgroundColor: AppColor.gray5,
                        foregroundImage: (data[index].imageUrl ?? '').isNotEmpty
                            ? NetworkImage(data[index].imageUrl!)
                            : null,
                        onForegroundImageError:
                            (data[index].imageUrl ?? '').isNotEmpty
                                ? (_, __) {}
                                : null,
                        child: Icon(Icons.person, color: AppColor.gray4, size: 32.r),
                      ),
                      title: Text(data[index].name ?? '', style: MyTextStyle().textStyleSemiBold16()),
                      subtitle: Text(
                      data[index].title ?? '',
                        style: MyTextStyle().textStyleRegular14(),
                      ),
                    ),
                    DashedLine(),
                    SizedBox(height: 20.h),
                    Text('${loc.skills}: ', style: MyTextStyle().textStyleMedium15()),
                    Wrap(
                      spacing: 8.r,
                      children: List.generate(
                        data[index].skills?.length ?? 0,
                        (indexSkills) => Chip(
                          backgroundColor: AppColor.gray5,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
                          label: Text(data[index].skills?[indexSkills] ?? '', style: MyTextStyle().textStyleRegular14()),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    InfoRow(label: '${loc.experience}: ', value: data[index].experience ?? ''),
                    SizedBox(height: 12.h),
                    InfoRow(label: '${loc.rate}: ', value: data[index].rate ?? ''),
                    SizedBox(height: 12.h),
                    InfoRow(label: '${loc.availability}: ', value: data[index].availability ?? ''),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onTap: () {
                              final id = int.tryParse(data[index].id ?? '');
                              if (id == null) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (_) => ConsultantProfileCubit(
                                      consultantId: id,
                                    ),
                                    child:
                                        const ConsultantDirectoryProfileView(),
                                  ),
                                ),
                              );
                            },
                            color: AppColor.k1primeryColor,
                            text: loc.view_consultant_profile,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: CustomButtonBorder(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestConsultantView(
                                  consultantId:
                                      int.tryParse(data[index].id ?? '') ?? 0,
                                ),
                              ),
                            ),
                            borderColor: AppColor.k1primeryColor,
                            text: loc.request,
                          ),
                        ),
                      ],
                    ),
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
