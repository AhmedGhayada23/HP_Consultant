import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/details_jobs_marketplace_cubit/details_jobs_marketplace_cubit.dart';
import 'package:hb/core/cubit/job_application_cubit/job_application_cubit.dart';
import 'package:hb/core/cubit/job_apply_cubit/job_apply_cubit.dart';
import 'package:hb/core/cubit/job_details_cubit/job_details_cubit.dart';
import 'package:hb/core/cubit/jobs_internship_cubit/jobs_internship_cubit.dart';
import 'package:hb/core/cubit/update_job_cubit/update_job_cubit.dart';

class JobsProviders {
  static List<BlocProvider> providers = [
    BlocProvider(create: (_) => JobApplyCubit()),
    BlocProvider(create: (_) => JobApplicationCubit()),
    BlocProvider(create: (_) => JobsInternshipCubit()),
    BlocProvider(create: (_) => DetailsJobsMarketplaceCubit()),
    BlocProvider(create: (context) => UpdateJobCubit()),
    BlocProvider(create: (context) => JobDetailsCubit()),

  ];
}
