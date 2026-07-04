import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/consultant_lookups_cubit/consultant_lookups_cubit.dart';
import 'package:hb/core/cubit/consultant_lookups_cubit/consultant_lookups_state.dart';
import 'package:hb/core/cubit/profile_cubit/profile_cubit.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = context.read<ConsultantLookupsCubit>();
    if (cubit.state.professions.isEmpty) {
      cubit.fetchLookups();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final profileCubit = context.read<ProfileCubit>();
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return BlocBuilder<ConsultantLookupsCubit, ConsultantLookupsState>(
      builder: (context, state) {
        final professionNames = state.professions
            .map((p) => isAr && p.nameAr.isNotEmpty ? p.nameAr : p.name)
            .toList();

        // تحديد الاختيار الحالي بناءً على selectedStudentProfessionId
        String? currentProfession;
        if (profileCubit.selectedStudentProfessionId != null) {
          final match = state.professions.where(
            (p) => p.id == profileCubit.selectedStudentProfessionId,
          );
          if (match.isNotEmpty) {
            currentProfession =
                isAr && match.first.nameAr.isNotEmpty ? match.first.nameAr : match.first.name;
          }
        }

        return Skeletonizer(
          enabled: state.loading,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              MyTextFieldWidget(
                controller: profileCubit.schoolUniversityController,
                hintText: loc.school_university,
                textInputAction: TextInputAction.next,
                validator: (value) => Validators.required(value, context),
              ),
              SizedBox(height: 16.h),
              MyTextFieldWidget(
                controller: profileCubit.studentMajorController,
                hintText: loc.major,
                textInputAction: TextInputAction.next,
                validator: (value) => Validators.required(value, context),
              ),
              SizedBox(height: 16.h),
              CustomDropdown(
                hint: loc.profession,
                items: state.loading ? ['...'] : professionNames,
                selectedValue: currentProfession,
                onChanged: (name) {
                  final match = state.professions.where(
                    (p) => (isAr && p.nameAr.isNotEmpty ? p.nameAr : p.name) == name,
                  );
                  if (match.isNotEmpty) {
                    profileCubit.selectedStudentProfessionId = match.first.id;
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
