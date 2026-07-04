import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/active_project_cubit/active_project_cubit.dart';
import 'package:hb/core/cubit/add_project_cubit/add_project_cubit.dart';
import 'package:hb/core/cubit/assigned_project_cubit/assigned_project_cubit.dart';
import 'package:hb/core/cubit/details_project_cubit/details_project_cubit.dart';

class ProjectsProviders {
  static List<BlocProvider> providers = [
    BlocProvider(create: (_) => AddProjectCubit()),
    BlocProvider(create: (_) => ActiveProjectCubit()),
    BlocProvider(create: (_) => AssignedProjectCubit()),
    BlocProvider(create: (_) => DetailsProjectCubit()),
  ];
}
