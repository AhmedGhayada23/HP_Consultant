import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/consultant_project_cubit/consultant_project_cubit.dart';
import 'package:hb/core/cubit/consultant_project_cubit/consultant_project_state.dart';
import 'package:hb/core/data/models/consultant_project_model.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/featuer/consultant_project/widgets/card_consultant_project_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ActiveConsultantsWidget extends StatelessWidget {
  const ActiveConsultantsWidget({super.key});

 @override
Widget build(BuildContext context) {
  return BlocBuilder<ConsultantProjectCubit, ConsultantProjectState>(
    builder: (context, state) {

      /// loading
      if (state.loading == true) {
        return Skeletonizer(
          enabled: true,
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            separatorBuilder: (context, index) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              return CardConsultantProjectWidget(
                  consultantProjectModel: ConsultantProjectModel.fake(),
                );
            },
          ),
        );
      }

      /// success
      if (state.consultantProjectData != null &&
          state.consultantProjectData!.isNotEmpty) {
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: state.consultantProjectData!.length,
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            return CardConsultantProjectWidget(
                  consultantProjectModel: state.consultantProjectData![index],
                );
          },
        );
      }

      /// empty
      return  EmptyStateWidget(title: AppLocalizations.of(context)!.consultants_empty_title,icon:  Icons.groups_outlined,subtitle: AppLocalizations.of(context)!.consultants_empty_subtitle,);
    },
  );
}
}
