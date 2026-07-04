import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/auth_signup_cubit/auth_signup_cubit.dart';
import 'package:hb/core/cubit/consultant_lookups_cubit/consultant_lookups_cubit.dart';
import 'package:hb/core/cubit/consultant_lookups_cubit/consultant_lookups_state.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AsStudent extends StatefulWidget {
  const AsStudent({super.key});

  @override
  State<AsStudent> createState() => _AsStudentState();
}

class _AsStudentState extends State<AsStudent> {
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
        final fakeProfessions = ['Loading...', 'Loading...', 'Loading...'];
        final professionNames = state.professions
            .map((p) => isAr && p.nameAr.isNotEmpty ? p.nameAr : p.name)
            .toList();

        return Skeletonizer(
          enabled: state.loading,
          child: Column(
            children: [
              SizedBox(height: 16.h),
              MyTextFieldWidget(
                controller: authCubit.schoolUniversityController,
                hintText: loc.school_university,
                textInputAction: TextInputAction.next,
                validator: (value) => Validators.required(value, context),
              ),
              SizedBox(height: 16.h),
              CustomDropdown(
                hint: loc.profession,
                items: state.loading ? fakeProfessions : professionNames,
                onChanged: (name) {
                  final match = state.professions.where(
                    (p) => (isAr && p.nameAr.isNotEmpty ? p.nameAr : p.name) == name,
                  );
                  if (match.isNotEmpty) authCubit.setProfessionId(match.first.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
