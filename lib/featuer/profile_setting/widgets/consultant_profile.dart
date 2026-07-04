import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/consultant_lookups_cubit/consultant_lookups_cubit.dart';
import 'package:hb/core/cubit/consultant_lookups_cubit/consultant_lookups_state.dart';
import 'package:hb/core/cubit/profile_cubit/profile_cubit.dart';
import 'package:hb/core/data/models/user_model.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/file_picker_field.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';

class ConsultantProfile extends StatefulWidget {
  final ProfileResponseModel userModel;
  const ConsultantProfile({super.key, required this.userModel});

  @override
  State<ConsultantProfile> createState() => _ConsultantProfileState();
}

class _ConsultantProfileState extends State<ConsultantProfile> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ConsultantLookupsCubit>().fetchLookups();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = context.read<ProfileCubit>();
    final cp = widget.userModel.user.consultantProfile;
    final skillNames = widget.userModel.user.skills.map((s) => s.name).toList();

    return BlocBuilder<ConsultantLookupsCubit, ConsultantLookupsState>(
      builder: (context, state) {
        final professionItems = state.professions.map((p) => p.name).toList();

        return Column(
          children: [
            SizedBox(height: 20.h),
            CustomDropdown(
              hint: loc.profession,
              items: professionItems,
              selectedValue: cp?.professionName,
              onChanged: (value) {},
            ),
            SizedBox(height: 16.h),
            CustomDropdown(
              key: ValueKey('skills_${state.skills.length}'),
              hint: loc.skills,
              isMultiSelect: true,
              skillItems: state.skills,
              selectedSkills: skillNames,
              onMultiChanged: (values) {},
            ),
            SizedBox(height: 16.h),
            MyTextFieldWidget(
              controller: cubit.hourlyRateController,
              hintText: loc.hourly_rate,
              keyboardType: TextInputType.number,
              validator: (value) => Validators.required(value, context),
            ),
            SizedBox(height: 16.h),
            MyTextFieldWidget(
              controller: cubit.portfolioUrl1Controller,
              validator: (value) =>
                  Validators.required(value, context) ??
                  Validators.url(value, context),
              hintText: loc.portfolio_link_1,
            ),
            SizedBox(height: 16.h),
            MyTextFieldWidget(
              controller: cubit.portfolioUrl2Controller,
              validator: (value) => Validators.url(value, context),
              hintText: loc.portfolio_link_2,
            ),
            SizedBox(height: 16.h),
            FilePickerField(
              controller: cubit.cvController,
              label: loc.your_cv,
            ),
          ],
        );
      },
    );
  }
}
