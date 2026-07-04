import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/city_cubit/city_cubit.dart';
import 'package:hb/core/cubit/country_cubit/country_cubit.dart';
import 'package:hb/core/cubit/industry_cubit/industry_cubit.dart';
import 'package:hb/core/cubit/payment_types_cubit/payment_types_cubit.dart';
import 'package:hb/core/cubit/project_types_cubit/project_types_cubit.dart';
import 'package:hb/core/cubit/skills_cubit/skills_cubit.dart';

class PublicProviders {
  static List<BlocProvider> providers = [
    BlocProvider(create: (context) => SkillsCubit()),
    BlocProvider(create: (context) => PaymentTypesCubit()),
    BlocProvider(create: (context) => ProjectTypesCubit()),
    BlocProvider(create: (context) => CityCubit()),
    BlocProvider(create: (context) => CountryCubit()),
    BlocProvider(create: (context) => IndustryCubit()),
  ];
}
