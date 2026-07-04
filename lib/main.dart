import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/config/storage/local_storage.dart';
import 'package:hb/core/cubit/industry_cubit/industry_cubit.dart';
import 'package:hb/core/widgets/connectivity_gate.dart';
import 'package:hb/core/widgets/restart_widget.dart';
import 'package:hb/core/cubit/consultant_dashboard_cubit/consultant_dashboard_cubit.dart';
import 'package:hb/core/cubit/consultant_lookups_cubit/consultant_lookups_cubit.dart';
import 'package:hb/core/cubit/accounting_request_cubit/accounting_request_cubit.dart';
import 'package:hb/core/cubit/services_cubit/services_cubit.dart';
import 'package:hb/core/cubit/service_requests_list_cubit/service_requests_list_cubit.dart';
import 'package:hb/core/cubit/active_project_cubit/active_project_cubit.dart';
import 'package:hb/core/cubit/add_project_cubit/add_project_cubit.dart';
import 'package:hb/core/cubit/apply_now_job_internship_cubit/apply_now_job_internship_cubit.dart';
import 'package:hb/core/cubit/assign_consultant_cubit/assign_consultant_cubit.dart';
import 'package:hb/core/cubit/assigned_project_cubit/assigned_project_cubit.dart';
import 'package:hb/core/cubit/auth_otp_cubit/auth_otp_cubit.dart';
import 'package:hb/core/cubit/auth_sigin_cubit/auth_sigin_cubit.dart';
import 'package:hb/core/cubit/auth_signup_cubit/auth_signup_cubit.dart';
import 'package:hb/core/cubit/boost_project_cubit/boost_project_cubit.dart';
import 'package:hb/core/cubit/box_cubit/box_cubit.dart';
import 'package:hb/core/cubit/change_passsword_cubit/change_passsword_cubit.dart';
import 'package:hb/core/cubit/chat_cubit/chat_cubit.dart';
import 'package:hb/core/cubit/message_cubit/message_cubit.dart';
import 'package:hb/core/cubit/city_cubit/city_cubit.dart';
import 'package:hb/core/cubit/consultant_cubit/consultant_cubit.dart';
import 'package:hb/core/cubit/consultant_requests_cubit/consultant_requests_cubit.dart';
import 'package:hb/core/cubit/consultant_meeting_request_cubit/consultant_meeting_request_cubit.dart';
import 'package:hb/core/cubit/consultant_project_cubit/consultant_project_cubit.dart';
import 'package:hb/core/cubit/consultant_request_cubit/consultant_request_cubit.dart';
import 'package:hb/core/cubit/contact_person_cubit/contact_person_cubit.dart';
import 'package:hb/core/cubit/country_cubit/country_cubit.dart';
import 'package:hb/core/cubit/course_detail_cubit/course_detail_cubit.dart';
import 'package:hb/core/cubit/course_enroll_cubit/course_enroll_cubit.dart';
import 'package:hb/core/cubit/job_opportunity_details_cubit/job_opportunity_details_cubit.dart';
import 'package:hb/core/cubit/my_course_details_cubit/my_course_details_cubit.dart';
import 'package:hb/core/cubit/completed_courses_cubit/completed_courses_cubit.dart';
import 'package:hb/core/cubit/details_my_application_cubit/details_my_application_cubit.dart';
import 'package:hb/core/cubit/store_token_cubit/store_token_cubit.dart';
import 'package:hb/core/cubit/course_discovery_cubit/course_discovery_cubit.dart';
import 'package:hb/core/cubit/dashboard_campany_cubit/dashboard_campany_cubit.dart';
import 'package:hb/core/cubit/details_application_cubit/details_application_cubit.dart';
import 'package:hb/core/cubit/reject_application_cubit/reject_application_cubit.dart';
import 'package:hb/core/cubit/details_consultant_meeting_request_cubit/details_consultant_meeting_request_cubit.dart';
import 'package:hb/core/cubit/details_consultant_project_cubit/details_consultant_project_cubit.dart';
import 'package:hb/core/cubit/details_hb_lab_project_cubit/details_hb_lab_project_cubit.dart';
import 'package:hb/core/cubit/details_hb_lab_project_cubit/details_hb_lab_project_consultant_cubit.dart';
import 'package:hb/core/cubit/details_job_project_cubit/details_job_project_cubit.dart';
import 'package:hb/core/cubit/details_job_talent_cubit/details_job_talent_cubit.dart';
import 'package:hb/core/cubit/details_jobs_marketplace_cubit/details_jobs_marketplace_cubit.dart';
import 'package:hb/core/cubit/details_project_cubit/details_project_cubit.dart';
import 'package:hb/core/cubit/dropdown_cubit/dropdown_cubit.dart';
import 'package:hb/core/cubit/employee_developer_cubit/purchased_course_cubit.dart';
import 'package:hb/core/cubit/employee_progress_cubit/employee_progress_cubit.dart';
import 'package:hb/core/cubit/forget_password_cubit/forget_password_cubit.dart';
import 'package:hb/core/cubit/hb_lab_ideas_box_cubit/hb_lab_ideas_box_cubit.dart';
import 'package:hb/core/cubit/hb_lab_ideas_box_accounting_cubit/hb_lab_ideas_box_accounting_cubit.dart';
import 'package:hb/core/cubit/hb_lab_project_cubit/hb_lab_project_cubit.dart';
import 'package:hb/core/cubit/hb_lab_project_accounting_cubit/hb_lab_project_accounting_cubit.dart';
import 'package:hb/core/cubit/invoices_finance_cubit/invoices_finance_cubit.dart';
import 'package:hb/core/cubit/job_and_talent_cubit/job_and_talent_cubit.dart';
import 'package:hb/core/cubit/job_application_cubit/job_application_cubit.dart';
import 'package:hb/core/cubit/job_apply_cubit/job_apply_cubit.dart';
import 'package:hb/core/cubit/job_details_cubit/job_details_cubit.dart';
import 'package:hb/core/cubit/job_project_cubit/job_project_cubit.dart';
import 'package:hb/core/cubit/jobs_internship_cubit/jobs_internship_cubit.dart';
import 'package:hb/core/cubit/latest_project_cubit/latest_project_cubit.dart';
import 'package:hb/core/cubit/locale_cubit/locale_cubit.dart';
import 'package:hb/core/cubit/locale_cubit/locale_state.dart';
import 'package:hb/core/cubit/milestone_cubit/milestone_cubit.dart';
import 'package:hb/core/cubit/my_application_cubit/my_application_cubit.dart';
import 'package:hb/core/cubit/my_courses_cubit/my_courses_cubit.dart';
import 'package:hb/core/cubit/new_idea_cubit/new_idea_cubit.dart';
import 'package:hb/core/cubit/new_job_cubit/new_job_cubit.dart';
import 'package:hb/core/cubit/notification_cubit/notification_cubit.dart';
import 'package:hb/core/cubit/paymant_invoice_cubit/paymant_invoice_cubit.dart';
import 'package:hb/core/cubit/payment_types_cubit/payment_types_cubit.dart';
import 'package:hb/core/cubit/profile_cubit/profile_cubit.dart';
import 'package:hb/core/cubit/project_types_cubit/project_types_cubit.dart';
import 'package:hb/core/cubit/recent_invoice_cubit/recent_invoice_cubit.dart';
import 'package:hb/core/cubit/recommended_jos_cubit/recommended_jos_cubit.dart';
import 'package:hb/core/cubit/reevaluate_project_cubit/reevaluate_project_cubit.dart';
import 'package:hb/core/cubit/report_invoice_cubit/report_invoice_cubit.dart';
import 'package:hb/core/cubit/request_consultant_cubit/request_consultant_cubit.dart';
import 'package:hb/core/cubit/service_request_cubit/service_request_cubit.dart';
import 'package:hb/core/cubit/skills_cubit/skills_cubit.dart';
import 'package:hb/core/cubit/training_courses_cubit/training_courses_cubit.dart';
import 'package:hb/core/cubit/training_details_courses/training_details_courses_cubit.dart';
import 'package:hb/core/cubit/update_job_cubit/update_job_cubit.dart';
import 'package:hb/core/cubit/update_project_cubit/update_project_cubit.dart';
import 'package:hb/core/cubit/upload_file_cubit/upload_file_cubit.dart';
import 'package:hb/core/cubit/user_cubit/user_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hb/core/navigation/app_navigator.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/utils/fb_notifications.dart';
import 'package:hb/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await LocalStorage().initStorage();

  // ── Firebase ──────────────────────────────────────────────────────────────
  await Firebase.initializeApp();
  await FbNotifications.initNotifications();
  // ─────────────────────────────────────────────────────────────────────────
  // ✅ تبدأ دائماً من شاشة البداية (Splash) وهي تقرّر الوجهة حسب حالة الدخول
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(
        initialRoute: MyRoutes().splashView,
      ),
    ),
  );

  // يُشغَّل بعد runApp حتى يكون الـ Navigator جاهزاً (فتح من إشعار والتطبيق مغلق)
  WidgetsBinding.instance.addPostFrameCallback((_) {
    FbNotifications.checkInitialMessage();
  });
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return RestartWidget(
      child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => EmployeeProgressCubit()),

        BlocProvider(create: (context) => PurchasedCourseCubit()),

        BlocProvider(create: (context) => TrainingDetailsCoursesCubit()),

        BlocProvider(create: (context) => TrainingCoursesCubit()),

        BlocProvider(create: (context) => UploadFileCubit()),

        BlocProvider(create: (context) => AssignConsultantCubit()),

        BlocProvider(create: (context) => MilestoneCubit()),

        BlocProvider(create: (context) => UpdateProjectCubit()),

        BlocProvider(create: (context) => JobDetailsCubit()),

        BlocProvider(create: (context) => UpdateJobCubit()),
        BlocProvider(create: (context) => PaymentTypesCubit()),

        BlocProvider(create: (context) => ProjectTypesCubit()),

        BlocProvider(create: (context) => SkillsCubit()),

        BlocProvider(create: (context) => ForgetPasswordCubit()),

        BlocProvider(create: (context) => ChangePassswordCubit()),

        BlocProvider(create: (context) => DashboardCampanyCubit()),

        BlocProvider(create: (context) => CityCubit()),

        BlocProvider(create: (context) => CountryCubit()),

        BlocProvider(create: (context) => IndustryCubit()),

        BlocProvider(create: (context) => LocaleCubit()),

        BlocProvider(create: (context) => ProfileCubit()),

        BlocProvider(create: (context) => ContactPersonCubit()),

        BlocProvider(create: (context) => ChangePassswordCubit()),

        BlocProvider(create: (context) => RequestConsultantCubit()),

        BlocProvider(create: (context) => ServiceRequestCubit()),

        BlocProvider(create: (context) => ServiceRequestCubit()),

        BlocProvider(create: (context) => ApplyNowJobInternshipCubit()),

        BlocProvider(create: (context) => NewIdeaCubit()),

        BlocProvider(create: (context) => ReevaluateProjectCubit()),

        BlocProvider(create: (context) => BoostProjectCubit()),

        BlocProvider(create: (context) => JobApplyCubit()),

        BlocProvider(create: (context) => ConsultantRequestCubit()),

        BlocProvider(create: (context) => AddProjectCubit()),

        BlocProvider(create: (context) => NewJobCubit()),

        BlocProvider(create: (context) => ConsultantDashboardCubit()),

        BlocProvider(create: (context) => ConsultantLookupsCubit()),

        BlocProvider(create: (context) => AuthSignupCubit()),

        BlocProvider(create: (context) => AuthOtpCubit()),

        BlocProvider(create: (context) => AuthSiginCubit()),

        BlocProvider(create: (context) => ReportInvoiceCubit()),

        BlocProvider(create: (context) => ConsultantCubit()),
        BlocProvider(create: (context) => ConsultantRequestsCubit()),

        BlocProvider(create: (context) => AccountingRequestCubit()),
        BlocProvider(create: (context) => ServicesCubit()),
        BlocProvider(create: (context) => ServiceRequestsListCubit()),

        BlocProvider(create: (context) => MyApplicationCubit()),

        BlocProvider(create: (context) => MyCoursesCubit()),

        BlocProvider(create: (context) => PaymantInvoiceCubit()),

        BlocProvider(create: (context) => JobsInternshipCubit()),

        BlocProvider(create: (context) => CourseDetailCubit()),

        BlocProvider(create: (context) => CourseDiscoveryCubit()),

        BlocProvider(create: (context) => CourseEnrollCubit()),

        BlocProvider(create: (context) => JobOpportunityDetailsCubit()),

        BlocProvider(create: (context) => MyCourseDetailsCubit()),

        BlocProvider(create: (context) => CompletedCoursesCubit()),

        BlocProvider(create: (context) => DetailsMyApplicationCubit()),

        BlocProvider(create: (context) => StoreTokenCubit()),

        BlocProvider(create: (context) => DetailsJobProjectCubit()),

        BlocProvider(create: (context) => JobProjectCubit()),

        BlocProvider(create: (context) => HbLabIdeasBoxCubit()),
        BlocProvider(create: (context) => HbLabIdeasBoxAccountingCubit()),

        BlocProvider(create: (context) => DetailsHbLabProjectCubit()),
        BlocProvider(create: (context) => DetailsHbLabProjectConsultantCubit()),

        BlocProvider(create: (context) => HbLabProjectCubit()),
        BlocProvider(create: (context) => HbLabProjectAccountingCubit()),

        BlocProvider(create: (context) => DetailsJobsMarketplaceCubit()),

        BlocProvider(create: (context) => RecommendedJosCubit()),

        BlocProvider(
          create: (context) => DetailsConsultantMeetingRequestCubit(),
        ),

        BlocProvider(create: (context) => ConsultantMeetingRequestCubit()),

        BlocProvider(create: (context) => DetailsProjectCubit()),

        BlocProvider(create: (context) => ActiveProjectCubit()),

        BlocProvider(create: (context) => AssignedProjectCubit()),

        BlocProvider(create: (context) => DetailsConsultantProjectCubit()),

        BlocProvider(create: (context) => DetailsApplicationCubit()),

        BlocProvider(create: (context) => RejectApplicationCubit()),

        BlocProvider(create: (context) => JobApplicationCubit()),

        BlocProvider(create: (context) => DetailsJobTalentCubit()),

        BlocProvider(create: (context) => BoxCubit()),

        BlocProvider(create: (context) => ChatCubit()),
        BlocProvider(create: (context) => MessageCubit()),

        BlocProvider(create: (context) => InvoicesFinanceCubit()),

        BlocProvider(create: (context) => PurchasedCourseCubit()),

        BlocProvider(create: (context) => ConsultantProjectCubit()),

        BlocProvider(create: (context) => JobAndTalentCubit()),

        BlocProvider(create: (context) => NotificationCubit()),

        BlocProvider(create: (context) => LatestProjectCubit()),

        BlocProvider(create: (context) => RecentInvoiceCubit()),

        BlocProvider(
          create: (context) {
            final cubit = UserCubit();
            cubit.loadUserStateFromStorage();
            return cubit;
          },
        ),
        BlocProvider(create: (context) => DropdownCubit()),
      ],
      child: ScreenUtilInit(
        designSize: Size(393, 852),
        child: BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, state) {
            return MaterialApp(
              locale: state.locale,
              supportedLocales: const [Locale('ar'), Locale('en')],
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (context, child) => DevicePreview.appBuilder(
                context,
                ConnectivityGate(child: child),
              ),
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,

              routes: MyRoutes().routes(),
              initialRoute: initialRoute,
            );
          },
        ),
      ),
      ),
    );
  }
}
