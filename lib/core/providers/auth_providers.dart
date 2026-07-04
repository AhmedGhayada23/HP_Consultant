import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/auth_otp_cubit/auth_otp_cubit.dart';
import 'package:hb/core/cubit/auth_sigin_cubit/auth_sigin_cubit.dart';
import 'package:hb/core/cubit/auth_signup_cubit/auth_signup_cubit.dart';
import 'package:hb/core/cubit/change_passsword_cubit/change_passsword_cubit.dart';
import 'package:hb/core/cubit/forget_password_cubit/forget_password_cubit.dart';

class AuthProviders {
  static List<BlocProvider> providers = [
    BlocProvider(create: (_) => AuthSignupCubit()),
    BlocProvider(create: (_) => AuthOtpCubit()),
    BlocProvider(create: (_) => AuthSiginCubit()),
    BlocProvider(create: (_) => ForgetPasswordCubit()),
    BlocProvider(create: (_) => ChangePassswordCubit()),
  ];
}
