import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/store_token_cubit/store_token_cubit.dart';
import 'package:hb/core/cubit/user_cubit/user_cubit.dart';
import 'package:hb/core/cubit/user_cubit/user_state.dart';
import 'package:hb/featuer/user_home/accounting_clint_home/presentation/accounting_clint_view.dart';
import 'package:hb/featuer/user_home/company_home/presentation/company_home_view.dart';
import 'package:hb/featuer/user_home/consultant_home/presentation/consultant_home_view.dart';
import 'package:hb/featuer/user_home/student_home/presentation/student_home_view.dart';
import 'package:hb/featuer/user_home/visitor_home/presentation/visitor_home.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<UserCubit, UserStates>(
        builder: (context, state) {
          final bool isVisitor = state is! CompanyUserState &&
              state is! ConsultantUserState &&
              state is! StudentUserState &&
              state is! AccountingClintUserState;

          // أرسل الـ FCM token لغير الزائر (الكيوبت يضمن الإرسال مرة واحدة)
          if (!isVisitor) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<StoreTokenCubit>().storeToken();
            });
          }

          if (state is CompanyUserState) {
            return CompanyHomeView();
          } else if (state is ConsultantUserState) {
            return ConsultantHomeView();
          } else if (state is StudentUserState) {
            return StudentHomeView();
          } else if (state is AccountingClintUserState) {
            return AccountingClintView();
          } else {
            return VisitorHome();
          }
        },
      ),
    );
  }
}
