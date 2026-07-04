import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/auth_signup_cubit/auth_signup_cubit.dart';
import 'package:hb/core/cubit/consultant_lookups_cubit/consultant_lookups_cubit.dart';
import 'package:hb/core/cubit/consultant_lookups_cubit/consultant_lookups_state.dart';
import 'package:hb/core/data/models/skills_model.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AsConsultant extends StatefulWidget {
  const AsConsultant({super.key});

  @override
  State<AsConsultant> createState() => _AsConsultantState();
}

class _AsConsultantState extends State<AsConsultant> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ConsultantLookupsCubit>().fetchLookups();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final authCubit = context.read<AuthSignupCubit>();
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return BlocBuilder<ConsultantLookupsCubit, ConsultantLookupsState>(
      builder: (context, state) {
        final fakeCategoryNames = ['Loading...', 'Loading...', 'Loading...'];
        final fakeSkills = List.generate(3, (_) => SkillsModel.fack());

        final professionNames = state.professions
            .map((c) => isAr && c.nameAr.isNotEmpty ? c.nameAr : c.name)
            .toList();

        return Skeletonizer(
          enabled: state.loading,
          child: Column(
            children: [
              SizedBox(height: 16.h),
              CustomDropdown(
                hint: loc.profession,
                items: state.loading ? fakeCategoryNames : professionNames,
                onChanged: (name) {
                  final match = state.professions.where(
                    (c) =>
                        (isAr && c.nameAr.isNotEmpty ? c.nameAr : c.name) ==
                        name,
                  );
                  if (match.isNotEmpty)
                    authCubit.setProfessionId(match.first.id);
                },
              ),
              SizedBox(height: 16.h),
              CustomDropdown(
                hint: loc.skills,
                isMultiSelect: true,
                skillItems: state.loading ? fakeSkills : state.skills,
                onMultiChanged: (names) {
                  final ids = state.skills
                      .where((s) => names.contains(s.name))
                      .map((s) => int.tryParse(s.id) ?? 0)
                      .where((id) => id > 0)
                      .toList();
                  authCubit.setSkillIds(ids);
                },
              ),
              SizedBox(height: 16.h),
              MyTextFieldWidget(
                controller: authCubit.hourlyRateController,
                hintText: loc.hourly_rate,
                keyboardType: TextInputType.number,
                validator: (value) => Validators.required(value, context),
              ),
              SizedBox(height: 16.h),
              MyTextFieldWidget(
                controller: authCubit.protfolioLink1Controller,
                hintText: loc.portfolio_link_1,
                validator: (value) =>
                    Validators.required(value, context) ??
                    Validators.url(value, context),
              ),
              SizedBox(height: 16.h),
              MyTextFieldWidget(
                controller: authCubit.protfolioLink2Controller,
                hintText: loc.portfolio_link_2,
                validator: (value) => Validators.url(value, context),
              ),
              SizedBox(height: 16.h),
              MyTextFieldWidget(
                controller: authCubit.cvController,
                hintText: loc.your_cv,
                showIcon: true,
                assetsIcon: AppSvg.uplodeSvg,
                readOnly: true,
                onTap: () => authCubit.pickCvFile(),
                validator: (value) => Validators.required(value, context),
              ),
            ],
          ),
        );
      },
    );
  }
}
