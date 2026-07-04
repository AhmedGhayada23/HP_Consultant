import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/new_idea_cubit/new_idea_cubit.dart';
import 'package:hb/featuer/auth_otp/presentation/auth_otp_view.dart';
import 'package:hb/featuer/auth_signIn/presentation/auth_signIn_view.dart';
import 'package:hb/featuer/auth_signup/presentation/auth_sign_up_view.dart';
import 'package:hb/featuer/career_opportunities/presentation/career_opportunities_view.dart';
import 'package:hb/featuer/chat_support/presentation/chat_support_view.dart';
import 'package:hb/featuer/message/presentation/message_list_view.dart';
import 'package:hb/featuer/consultant_project/presentation/consultant_meeting_requests_view.dart';
import 'package:hb/featuer/consultant_project/presentation/consultant_project_view.dart';
import 'package:hb/featuer/consultant_project/presentation/new_project_view.dart';
import 'package:hb/featuer/counsultants_directory/presentation/counsultants_directory_view.dart';
import 'package:hb/featuer/employee_developer/presentation/employee_developer_view.dart';
import 'package:hb/featuer/employee_developer/presentation/purchase_new_course_view.dart';
import 'package:hb/featuer/forget_password/presentation/forget_password_screen.dart';
import 'package:hb/featuer/hb_lab/presentation/boost_project_view.dart';
import 'package:hb/featuer/splash/presentation/splash_view.dart';
import 'package:hb/featuer/hb_lab/presentation/hb_lab_view.dart';
import 'package:hb/featuer/hb_lab_accounting/presentation/hb_lab_accounting_view.dart';
import 'package:hb/featuer/hb_lab_accounting/presentation/submit_a_new_idea_accounting_view.dart';
import 'package:hb/featuer/hb_lab/presentation/submit_a_new_idea_view.dart';
import 'package:hb/featuer/invoices_finance/presentation/invoices_finance_view.dart';
import 'package:hb/featuer/jobs_and_talent/presentation/job_and_talent_view.dart';
import 'package:hb/featuer/jobs_and_talent/presentation/new_job_view.dart';
import 'package:hb/featuer/jobs_marketplace/presentation/jobs_marketplace_view.dart';
import 'package:hb/featuer/jobs_projects/presentation/jobs_projects_view.dart';
import 'package:hb/featuer/my_coureses/presentation/my_coureses_view.dart';
import 'package:hb/featuer/notification/presentation/notification_view.dart';
import 'package:hb/featuer/paymants_invoices/presentation/paymants_invoices_view.dart';
import 'package:hb/featuer/profile_setting/presentation/change_password_view.dart';
import 'package:hb/featuer/profile_setting/presentation/profile_setting_view.dart';
import 'package:hb/featuer/reports_ivoices/presentation/reports_ivoices_view.dart';
import 'package:hb/featuer/select_account_type/presentation/select_account_type_view.dart';
import 'package:hb/featuer/user/presentation/user_view.dart';
import 'package:hb/featuer/user_home/accounting_clint_home/presentation/accounting_clint_view.dart';
import 'package:hb/featuer/user_home/accounting_clint_home/presentation/request_new_service_view.dart';
import 'package:hb/featuer/user_home/company_home/presentation/company_home_view.dart';
import 'package:hb/featuer/user_home/consultant_home/presentation/consultant_home_view.dart';
import 'package:hb/featuer/user_home/student_home/presentation/student_home_view.dart';
import 'package:hb/featuer/user_home/visitor_home/presentation/visitor_home.dart';
import 'package:hb/featuer/visitor_course_discovery/presentation/visitor_course_discovery_view.dart';
import 'package:hb/featuer/visitor_career_opportunities/presentation/visitor_career_opportunities.dart';

class MyRoutes {
  final splashView = 'splashView';
  final selectAccountTypeView = 'selectAccountTypeView';
  final authSiginIn = 'authSiginIn';
  final authSiginUp = 'authSiginUp';
  final authOtpView = 'authOtpView';
  final userView = 'userView';
  final notificationView = 'notificationView';
  final jobView = 'jobView';
  final companyHomeView = 'companyHomeView';
  final consultantHomeView = 'consultantHomeView';
  final studentHomeView = 'studentHomeView';
  final accountingClintView = 'accountingClintView';
  final newJobView = 'newJobView';
  final consultantProjectView = 'consultantProjectView';
  final newProjectView = 'NewProjectView';
  final employeeDeveloperView = 'employeeDeveloperView';
  final invoicesFinanceView = 'invoicesFinanceView';
  final chatSupportView = 'chatSupportView';
  final messageView = 'messageView';
  final profileSettingView = 'profileSettingView';
  final changePasswordView = 'changePasswordView';
  final consultantMeetingRequestsView = 'consultantMeetingRequestsView';
  final purchaseNewCourseView = 'purchaseNewCourseView';
  final jobsMarketplaceView = 'jobsMarketplaceView';
  final jobsProjectsView = 'jobsProjectsView';
  final paymantsInvoicesView = 'paymantsInvoicesView';
  final hbLabView = 'hbLabView';
  final hbLabAccountingView = 'hbLabAccountingView';
  final submitANewIdeaAccountingView = 'submitANewIdeaAccountingView';
  final boostProjectView = 'boostProjectView';
  final submitANewIdeaView = 'submitANewIdeaView';
  final myCouresesView = 'myCouresesView';
  final careerOpportunitiesView = 'careerOpportunitiesView';
  final requestNewServiceView = 'requestNewServiceView';
  final counsultantsDirectoryView = 'counsultantsDirectoryView';
  final reportsIvoicesView = 'reportsIvoicesView';
  final visitorHome = 'visitorHome';
  final visitorCourseDiscoveryView = 'visitorCourseDiscoveryView';
  final visitorCareerOpportunities = 'visitorCareerOpportunities';
  final forgetPasswordScreen = 'forgetPasswordScreen';


  Map<String, Widget Function(BuildContext)> routes() {
    return {
      splashView: (context) => const SplashView(),
      selectAccountTypeView: (context) => const SelectAccountTypeView(),
      authSiginIn: (context) => AuthSigninView(),
      authSiginUp: (context) => AuthSignUpView(title: ''),
      authOtpView: (context) => AuthOtpView(),
      userView: (context) => UserView(),
      notificationView: (context) => NotificationView(),
      jobView: (context) => JobAndTalentView(),
      companyHomeView: (context) => CompanyHomeView(),
      newJobView: (context) => NewJobView(),
      consultantProjectView: (context) => ConsultantProjectView(),
      newProjectView: (context) => NewProjectView(),
      employeeDeveloperView: (context) => EmployeeDeveloperView(),
      invoicesFinanceView: (context) => InvoicesFinanceView(),
      chatSupportView: (context) => ChatSupportView(),
      messageView: (context) => MessageListView(),
      profileSettingView: (context) => ProfileSettingView(),
      changePasswordView: (context) => ChangePasswordView(),
      consultantMeetingRequestsView: (context) => ConsultantMeetingRequestsView(),
      purchaseNewCourseView: (context) => PurchaseNewCourseView(),
      consultantHomeView: (context) => ConsultantHomeView(),
      jobsMarketplaceView: (context) => JobsMarketplaceView(),
      jobsProjectsView: (context) => JobsProjectsView(),
      paymantsInvoicesView: (context) => PaymantsInvoicesView(),
      hbLabView: (context) => HbLabView(),
      hbLabAccountingView: (context) => HbLabAccountingView(),
      submitANewIdeaAccountingView: (context) =>
          SubmitANewIdeaAccountingView(),
      boostProjectView: (context) => BoostProjectView(),
      submitANewIdeaView: (context) => BlocProvider(
            create: (_) => NewIdeaCubit(consultant: true),
            child: SubmitANewIdeaView(),
          ),
      studentHomeView: (context) => StudentHomeView(),
      myCouresesView: (contxt) => MyCouresesView(),
      careerOpportunitiesView: (context) => CareerOpportunitiesView(),
      accountingClintView: (contxt) => AccountingClintView(),
      requestNewServiceView: (contect) => RequestNewServiceView(),
      counsultantsDirectoryView: (contect) => CounsultantsDirectoryView(),
      reportsIvoicesView: (context) => ReportsIvoicesView(),
      visitorHome: (context) => VisitorHome(),
      visitorCourseDiscoveryView: (context) => VisitorCourseDiscoveryView(),
      visitorCareerOpportunities : (context) => VisitorCareerOpportunities(),
      forgetPasswordScreen : (context) => ForgetPasswordScreen(),
    };
  }
}
