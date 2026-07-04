import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/change_passsword_cubit/change_passsword_cubit.dart';
import 'package:hb/core/cubit/contact_person_cubit/contact_person_cubit.dart';
import 'package:hb/core/cubit/profile_cubit/profile_cubit.dart';

class ProfileProviders {
  static List<BlocProvider> providers = [
    BlocProvider(create: (context) => ProfileCubit()),

    BlocProvider(create: (context) => ContactPersonCubit()),

    BlocProvider(create: (context) => ChangePassswordCubit()),
  ];
}
