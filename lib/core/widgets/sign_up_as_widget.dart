  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:hb/core/cubit/user_cubit/user_cubit.dart';
  import 'package:hb/core/styles/app_font.dart';
  import 'package:hb/core/widgets/dashed_line.dart';
  import 'package:hb/core/widgets/select_option_tile.dart';
  import 'package:hb/featuer/auth_signup/presentation/auth_sign_up_view.dart';
  import 'package:hb/l10n/app_localizations.dart';

  class SignUpAsWidget extends StatelessWidget {
    const SignUpAsWidget({super.key});
 final List<String> signUpOptions = const [
  "as_company",
  "as_consultant",
  "as_student",
  "as_accounting_client",
];

String getLocalizedOption(BuildContext context, String key) {
  final loc = AppLocalizations.of(context)!;

  switch (key) {
    case 'as_company':
      return loc.as_company;
    case 'as_consultant':
      return loc.as_consultant;
    case 'as_student':
      return loc.as_student;
    case 'as_accounting_client':
      return loc.as_accounting_client;
    default:
      return '';
  }
}

    UserType getUserTypeFromTitle(String title) {
      switch (title) {
        case 'As a Company':
          return UserType.CompanyUser;
        case 'As a Consultant':
          return UserType.ConsultantUser;
        case 'As a Student':
          return UserType.StudentUser;
        case 'As a Accounting Client':
          return UserType.AccountingClintUser;
        default:
          return UserType.VisitorUser;
      }
    }

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min, // مهم علشان يكون البوتوم شيت حجمه على قد المحتوى
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.sign_up_as, style: MyTextStyle().textStyleSemiBold20()),
            SizedBox(height: 24.h),
            DashedLine(),
            SizedBox(height: 20.h),

            // ✅ استبدل ListView بـ Column + List.generate
            Column(
              children: List.generate(
                signUpOptions.length,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: index == signUpOptions.length - 1 ? 0 : 8.h),
                  child: SelectOptionTile(
                    title: getLocalizedOption(context, signUpOptions[index]),
                    onTap: () {
                      final selectedType = getUserTypeFromTitle(signUpOptions[index]);

                      BlocProvider.of<UserCubit>(context).getUserState(selectedType);
                      // تنفيذ حدث عند اختيار عنصر
                      print('Selected: ${signUpOptions[index]}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthSignUpView(title: getLocalizedOption(context, signUpOptions[index])),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
