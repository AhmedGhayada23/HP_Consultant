import 'package:hb/core/data/datasource/accounting_request_remote_datasource.dart';
import 'package:hb/core/data/datasource/services_remote_datasource.dart';
import 'package:hb/core/domain/repository/services_repository.dart';
import 'package:hb/core/domain/usecase/services_usecase.dart';
import 'package:hb/core/data/datasource/service_types_remote_datasource.dart';
import 'package:hb/core/domain/repository/service_types_repository.dart';
import 'package:hb/core/domain/usecase/service_types_usecase.dart';
import 'package:hb/core/data/datasource/service_request_remote_datasource.dart';
import 'package:hb/core/domain/repository/service_request_repository.dart';
import 'package:hb/core/domain/usecase/service_request_usecase.dart';
import 'package:hb/core/data/datasource/consultant_requests_remote_datasource.dart';
import 'package:hb/core/domain/repository/consultant_requests_repository.dart';
import 'package:hb/core/domain/usecase/consultant_requests_usecase.dart';
import 'package:hb/core/data/datasource/active_project_data_source.dart';
import 'package:hb/core/data/datasource/assign_consultant_remote_data_source.dart';
import 'package:hb/core/data/datasource/assigned_project_data_source.dart';
import 'package:hb/core/data/datasource/auth_remote_data_source.dart';
import 'package:hb/core/data/datasource/chat_remote_datasource.dart';
import 'package:hb/core/data/datasource/message_remote_datasource.dart';
import 'package:hb/core/data/datasource/city_remote_data_source.dart';
import 'package:hb/core/data/datasource/industry_remote_data_source.dart';
import 'package:hb/core/data/datasource/consultant_meeting_request_data_source.dart';
import 'package:hb/core/data/datasource/consultant_project_remote_datasouce.dart';
import 'package:hb/core/data/datasource/consultant_remote_datasource.dart';
import 'package:hb/core/data/datasource/country_remote_data_source.dart';
import 'package:hb/core/data/datasource/course_detail_data_source.dart';
import 'package:hb/core/data/datasource/course_remote_data_source.dart';
import 'package:hb/core/data/datasource/dashboard_remote_data_source.dart';
import 'package:hb/core/data/datasource/details_application_data_source.dart';
import 'package:hb/core/data/datasource/details_consultant_meeting_request_data_source.dart';
import 'package:hb/core/data/datasource/details_consultant_project_data_source.dart';
import 'package:hb/core/data/datasource/details_hb_lab_project_data_source.dart';
import 'package:hb/core/data/datasource/details_hb_lab_project_consultant_data_source.dart';
import 'package:hb/core/data/datasource/details_job_project_data_source.dart';
import 'package:hb/core/data/datasource/details_job_talent_data_source.dart';
import 'package:hb/core/data/datasource/details_jobs_marketplace_data_source.dart';
import 'package:hb/core/data/datasource/details_project_data_source.dart';
import 'package:hb/core/data/datasource/employee_progress_datasource.dart';
import 'package:hb/core/data/datasource/purchased_course_remote_datasource.dart';
import 'package:hb/core/data/datasource/hb_lab_ideas_box_data_source.dart';
import 'package:hb/core/data/datasource/hb_lab_ideas_box_accounting_data_source.dart';
import 'package:hb/core/domain/repository/hb_lab_ideas_box_accounting_repository.dart';
import 'package:hb/core/domain/usecase/hb_lab_ideas_box_accounting_usecase.dart';
import 'package:hb/core/data/datasource/hb_lab_project_data_source.dart';
import 'package:hb/core/data/datasource/hb_lab_project_accounting_data_source.dart';
import 'package:hb/core/domain/repository/hb_lab_project_accounting_repository.dart';
import 'package:hb/core/domain/usecase/hb_lab_project_accounting_usecase.dart';
import 'package:hb/core/data/datasource/invoices_finance_remote_datasource.dart';
import 'package:hb/core/data/datasource/job_and_talent_remote_datasource.dart';
import 'package:hb/core/data/datasource/job_application_data_source.dart';
import 'package:hb/core/data/datasource/job_project_data_source.dart';
import 'package:hb/core/data/datasource/jobs_internship_data_source.dart';
import 'package:hb/core/data/datasource/latest_project_remote_datasource.dart';
import 'package:hb/core/data/datasource/milestone_remote_data_source.dart';
import 'package:hb/core/data/datasource/my_application_remote_datasource.dart';
import 'package:hb/core/data/datasource/my_coureses_data_source.dart';
import 'package:hb/core/data/datasource/notification_remote_datasource.dart';
import 'package:hb/core/data/datasource/paymant_invoice_data_source.dart';
import 'package:hb/core/data/datasource/profile_remote_data_source.dart';
import 'package:hb/core/data/datasource/project_file_remote_data_source.dart';
import 'package:hb/core/data/datasource/recent_invoice_remote_datasource.dart';
import 'package:hb/core/data/datasource/recommended_jos_data_source.dart';
import 'package:hb/core/data/datasource/report_invoice_remote_datasource.dart';
import 'package:hb/core/data/datasource/training_courses_remote_datasource.dart';
import 'package:hb/core/domain/repository/accounting_request_repository.dart';
import 'package:hb/core/domain/repository/active_project_repository.dart';
import 'package:hb/core/domain/repository/assign_consultant_repository.dart';
import 'package:hb/core/domain/repository/assigned_project_repository.dart';
import 'package:hb/core/domain/repository/auth_repository.dart';
import 'package:hb/core/domain/repository/chat_repository.dart';
import 'package:hb/core/domain/repository/message_repository.dart';
import 'package:hb/core/domain/repository/city_repositiry.dart';
import 'package:hb/core/domain/repository/industry_repository.dart';
import 'package:hb/core/domain/repository/consultant_meeting_request_repository.dart';
import 'package:hb/core/domain/repository/consultant_project_repository.dart';
import 'package:hb/core/domain/repository/consultant_repository.dart';
import 'package:hb/core/domain/repository/country_repository.dart';
import 'package:hb/core/domain/repository/course_detail_repository.dart';
import 'package:hb/core/domain/repository/course_repository.dart';
import 'package:hb/core/domain/repository/dashboard_repository.dart';
import 'package:hb/core/domain/repository/details_application_repository.dart';
import 'package:hb/core/domain/repository/details_consultant_meeting_request_repository.dart';
import 'package:hb/core/domain/repository/details_consultant_project_repository.dart';
import 'package:hb/core/domain/repository/details_hb_lab_project_repository.dart';
import 'package:hb/core/domain/repository/details_job_project_reopsitory.dart';
import 'package:hb/core/domain/repository/details_job_talent_repository.dart';
import 'package:hb/core/domain/repository/details_jobs_marketplace_repository.dart';
import 'package:hb/core/domain/repository/details_project_repository.dart';
import 'package:hb/core/domain/repository/employee_developer_repository.dart';
import 'package:hb/core/domain/repository/employee_progress_repository.dart';
import 'package:hb/core/domain/repository/hb_lab_ideas_box_repository.dart';
import 'package:hb/core/domain/repository/hb_lab_project_repository.dart';
import 'package:hb/core/domain/repository/invoices_finance_repository.dart';
import 'package:hb/core/domain/repository/job_and_talent_repository.dart';
import 'package:hb/core/domain/repository/job_application_repository.dart';
import 'package:hb/core/domain/repository/job_project_repository.dart';
import 'package:hb/core/domain/repository/jobs_internship_repository.dart';
import 'package:hb/core/domain/repository/latest_project_remote_repository.dart';
import 'package:hb/core/domain/repository/milestone_repository.dart';
import 'package:hb/core/domain/repository/my_application_repository.dart';
import 'package:hb/core/domain/repository/my_coureses_repository.dart';
import 'package:hb/core/domain/repository/notification_repository.dart';
import 'package:hb/core/domain/repository/paymant_invoice_repository.dart';
import 'package:hb/core/domain/repository/profile_repository.dart';
import 'package:hb/core/domain/repository/project_file_repository.dart';
import 'package:hb/core/domain/repository/recent_invoice_repository.dart';
import 'package:hb/core/domain/repository/recommended_jos_repository.dart';
import 'package:hb/core/domain/repository/report_invoice_repository.dart';
import 'package:hb/core/domain/repository/training_courses_repository.dart';
import 'package:hb/core/data/datasource/consultant_lookups_data_source.dart';
import 'package:hb/core/domain/repository/consultant_lookups_repository.dart';
import 'package:hb/core/domain/usecase/consultant_lookups_usecase.dart';
import 'package:hb/core/domain/usecase/accounting_request_usecase.dart';
import 'package:hb/core/domain/usecase/active_project_usecase.dart';
import 'package:hb/core/domain/usecase/assign_consultant_usecase.dart';
import 'package:hb/core/domain/usecase/assigned_project_usecase.dart';
import 'package:hb/core/domain/usecase/auth_use_case.dart';
import 'package:hb/core/domain/usecase/city_usecase.dart';
import 'package:hb/core/domain/usecase/industry_usecase.dart';
import 'package:hb/core/domain/usecase/consultant_meeting_request_usecase.dart';
import 'package:hb/core/domain/usecase/consultant_usecase.dart';
import 'package:hb/core/domain/usecase/country_usecase.dart';
import 'package:hb/core/domain/usecase/course_detail_usecase.dart';
import 'package:hb/core/domain/usecase/dashboard_usecase.dart';
import 'package:hb/core/domain/usecase/details_consultant_meeting_request_usecase.dart';
import 'package:hb/core/domain/usecase/details_consultant_project_usecase.dart';
import 'package:hb/core/domain/usecase/details_hb_lab_project_usecase.dart';
import 'package:hb/core/domain/usecase/details_job_project_usecase.dart';
import 'package:hb/core/domain/usecase/details_jobs_marketplace_usecase.dart';
import 'package:hb/core/domain/usecase/details_project_usecase.dart';
import 'package:hb/core/domain/usecase/get_chat_usecase.dart';
import 'package:hb/core/domain/usecase/get_message_usecase.dart';
import 'package:hb/core/domain/usecase/get_consultant_project_usecase.dart';
import 'package:hb/core/domain/usecase/get_courses_usecase.dart';
import 'package:hb/core/domain/usecase/get_details_application_usecase.dart';
import 'package:hb/core/domain/usecase/get_details_job_talent_usecase.dart';
import 'package:hb/core/domain/usecase/get_employees_progress_usecase.dart';
import 'package:hb/core/domain/usecase/get_purchased_course_usecase.dart';
import 'package:hb/core/domain/usecase/get_invoices_finance_usecase.dart';
import 'package:hb/core/domain/usecase/get_job_and_talent_usecase.dart';
import 'package:hb/core/domain/usecase/get_job_application_usecase.dart';
import 'package:hb/core/domain/usecase/get_latest_project_usecase.dart';
import 'package:hb/core/domain/usecase/get_notifications_usecase.dart';
import 'package:hb/core/domain/usecase/get_recent_invoices_usecase.dart';
import 'package:hb/core/domain/usecase/get_training_courses_usecase.dart';
import 'package:hb/core/domain/usecase/hb_lab_ideas_box_usecase.dart';
import 'package:hb/core/domain/usecase/hb_lab_project_usecase.dart';
import 'package:hb/core/domain/usecase/job_project_usecase.dart';
import 'package:hb/core/domain/usecase/jobs_internship_usecase.dart';
import 'package:hb/core/domain/usecase/milestone_usecase.dart';
import 'package:hb/core/domain/usecase/my_application_usecase.dart';
import 'package:hb/core/domain/usecase/my_coureses_usecase.dart';
import 'package:hb/core/domain/usecase/paymant_invoice_usecase.dart';
import 'package:hb/core/domain/usecase/profile_usecase.dart';
import 'package:hb/core/domain/usecase/recommended_jos_usecase.dart';
import 'package:hb/core/domain/usecase/report_invoice_usecase.dart';
import 'package:hb/core/domain/usecase/upload_project_file_usecase.dart';
import 'package:hb/core/data/datasource/boost_project_datasource.dart';
import 'package:hb/core/data/datasource/consultant_dashboard_datasource.dart';
import 'package:hb/core/data/datasource/details_ideas_box_data_source.dart';
import 'package:hb/core/data/datasource/details_ideas_box_consultant_data_source.dart';
import 'package:hb/core/data/datasource/hb_lab_join_datasource.dart';
import 'package:hb/core/data/datasource/hb_lab_join_consultant_datasource.dart';
import 'package:hb/core/data/datasource/job_apply_datasource.dart';
import 'package:hb/core/domain/repository/boost_project_repository.dart';
import 'package:hb/core/domain/repository/consultant_dashboard_repository.dart';
import 'package:hb/core/domain/repository/details_ideas_box_repository.dart';
import 'package:hb/core/domain/repository/hb_lab_join_repository.dart';
import 'package:hb/core/domain/repository/job_apply_repository.dart';
import 'package:hb/core/domain/usecase/boost_project_usecase.dart';
import 'package:hb/core/domain/usecase/consultant_dashboard_usecase.dart';
import 'package:hb/core/data/datasource/hb_lab_comment_datasource.dart';
import 'package:hb/core/data/datasource/hb_lab_comment_consultant_datasource.dart';
import 'package:hb/core/data/datasource/hb_lab_upvote_datasource.dart';
import 'package:hb/core/data/datasource/hb_lab_upvote_consultant_datasource.dart';
import 'package:hb/core/data/datasource/submit_idea_datasource.dart';
import 'package:hb/core/data/datasource/submit_idea_consultant_datasource.dart';
import 'package:hb/core/domain/repository/hb_lab_comment_repository.dart';
import 'package:hb/core/domain/repository/hb_lab_upvote_repository.dart';
import 'package:hb/core/domain/repository/submit_idea_repository.dart';
import 'package:hb/core/domain/usecase/details_ideas_box_usecase.dart';
import 'package:hb/core/domain/usecase/hb_lab_comment_usecase.dart';
import 'package:hb/core/domain/usecase/hb_lab_join_usecase.dart';
import 'package:hb/core/domain/usecase/hb_lab_upvote_usecase.dart';
import 'package:hb/core/domain/usecase/job_apply_usecase.dart';
import 'package:hb/core/domain/usecase/submit_idea_usecase.dart';
import 'package:hb/core/data/datasource/schedule_interview_data_source.dart';
import 'package:hb/core/domain/repository/schedule_interview_repository.dart';
import 'package:hb/core/domain/usecase/schedule_interview_usecase.dart';
import 'package:hb/core/data/datasource/reject_application_data_source.dart';
import 'package:hb/core/domain/repository/reject_application_repository.dart';
import 'package:hb/core/domain/usecase/reject_application_usecase.dart';
import 'package:hb/core/data/datasource/course_enroll_data_source.dart';
import 'package:hb/core/domain/repository/course_enroll_repository.dart';
import 'package:hb/core/domain/usecase/course_enroll_usecase.dart';
import 'package:hb/core/data/datasource/job_opportunity_details_data_source.dart';
import 'package:hb/core/domain/repository/job_opportunity_details_repository.dart';
import 'package:hb/core/domain/usecase/job_opportunity_details_usecase.dart';
import 'package:hb/core/data/datasource/apply_job_data_source.dart';
import 'package:hb/core/domain/repository/apply_job_repository.dart';
import 'package:hb/core/domain/usecase/apply_job_usecase.dart';
import 'package:hb/core/data/datasource/my_course_details_data_source.dart';
import 'package:hb/core/domain/repository/my_course_details_repository.dart';
import 'package:hb/core/domain/usecase/my_course_details_usecase.dart';
import 'package:hb/core/data/datasource/completed_courses_data_source.dart';
import 'package:hb/core/domain/repository/completed_courses_repository.dart';
import 'package:hb/core/domain/usecase/completed_courses_usecase.dart';
import 'package:hb/core/data/datasource/details_my_application_data_source.dart';
import 'package:hb/core/domain/repository/details_my_application_repository.dart';
import 'package:hb/core/domain/usecase/details_my_application_usecase.dart';
import 'package:hb/core/data/datasource/store_token_data_source.dart';
import 'package:hb/core/domain/repository/store_token_repository.dart';
import 'package:hb/core/domain/usecase/store_token_usecase.dart';

class UseCases {
  static final getAuthUseCase = AuthUseCase(AuthRepositoryImpl(AuthRemoteDataSourceImpl()));
  static final getRecentInvoicesUseCase = GetRecentInvoicesUseCase(
    RecentInvoiceRepositoryImpl(RecentInvoiceRemoteDataSourceImpl()),
  );

  static final getLatestProjectUsecase = GetLatestProjectUsecase(
    LatestProjectRemoteRepositoryImpl(LatestProjectRemoteDatasourceImpl()),
  );

  static final notificationRepository =
      NotificationRepositoryImpl(NotificationRemoteDataSourceImpl());

  static final getNotificationsUseCase =
      GetNotificationsUseCase(notificationRepository);
  static final getJobAndTalentUsecase = GetJobAndTalentUsecase(
    JobAndTalentRepositoryImpl(JobAndTalentRemoteDatasourceImpl()),
  );
  static final getConsultantProjectUsecase = GetConsultantProjectUsecase(
    ConsultantProjectRepositoryImpl(ConsultantProjectRemoteDatasouceImpl()),
  );

  static final getPurchasedCourseUsecase = GetPurchasedCourseUsecase(
    GetPurchasedCourseRepositoryImpl(PurchasedCourseDatasourceImpl()),
  );

  static final getInvoicesFinanceUsecase = GetInvoicesFinanceUsecase(
    InvoicesFinanceRepositoryImpl(InvoicesFinanceRemoteDataSourceImpl()),
  );

  static final chatRepository =
      ChatRepositoryImpl(ChatRemoteDataSourceImpl());

  static final getChatRepositoryUsecase = GetChatUsecase(chatRepository);

  // ── Message (نسخة مستقلة عن chat_support) ──────────────────────────────
  static final messageRepository =
      MessageRepositoryImpl(MessageRemoteDataSourceImpl());

  static final getMessageRepositoryUsecase = GetMessageUsecase(messageRepository);
  static final getDetailsJobTalentUsecase = GetDetailsJobTalentUsecase(
    DetailsJobTalentRepositoryImpl(DetailsJobTalentDataSourceImpl()),
  );
  static final getJobApplicationUsecase = GetJobApplicationUsecase(
    JobApplicationRepositoryImpl(JobApplicationDataSourceImpl()),
  );
  static final getDetailsApplicationUsecase = GetDetailsApplicationUsecase(
    DetailsApplicationRepositoryImpl(DetailsApplicationDataSourceImpl()),
  );
  static final getDetailsConsultantProjectUsecase = DetailsConsultantProjectUsecase(
    DetailsConsultantProjectRepositoryImpl(DetailsConsultantProjectDataSourceImpl()),
  );

  static final getAssignedProjectUsecase = AssignedProjectUsecase(
    AssignedProjectRepositoryImpl(AssignedProjectModelDataSourceImpl()),
  );
  static final getActiveProjectUsecase = ActiveProjectUsecase(
    ActiveProjectRepositoryImpl(ActiveProjectDataSourceImpl()),
  );

  static final getDetailsProjectUsecase = DetailsProjectUsecase(
    DetailsProjectRepositoryImpl(DetailsProjectDataSourceImpl()),
  );

  static final getConsultantMeetingRequestUsecase = ConsultantMeetingRequestUsecase(
    ConsultantMeetingRequestRepositoryImpl(ConsultantMeetingRequestDataSourceImpl()),
  );

  static final getDetailsConsultantMeetingRequestUsecase = DetailsConsultantMeetingRequestUsecase(
    DetailsConsultantMeetingRequestRepositoryImpl(DetailsConsultantMeetingRequestDataSourceImpl()),
  );
  static final getRecommendedJosUsecase = RecommendedJosUsecase(
    RecommendedJosRepositoryImpl(RecommendedJosDataSourceImpl()),
  );

  static final getDetailsJobsMarketplaceUsecase = DetailsJobsMarketplaceUsecase(
    DetailsJobsMarketplaceRepositoryImpl(DetailsJobsMarketplaceDataSourceImpl()),
  );

  static final getHbLabProjectUsecase = HbLabProjectUsecase(
    HbLabProjectRepositoryImpl(HbLabProjectDataSourceImpl()),
  );
  static final getHbLabProjectAccountingUsecase = HbLabProjectAccountingUsecase(
    HbLabProjectAccountingRepositoryImpl(
        HbLabProjectAccountingDataSourceImpl()),
  );
  static final getDetailsHbLabProjectUsecase = DetailsHbLabProjectUsecase(
    DetailsHbLabProjectRepositoryImpl(DetailsHbLabProjectDataSourceImpl()),
  );
  // قسم الاستشاري: نفس البيانات والمنطق، endpoint مختلف (/api/consultant/...)
  static final getDetailsHbLabProjectConsultantUsecase =
      DetailsHbLabProjectUsecase(
    DetailsHbLabProjectRepositoryImpl(
        DetailsHbLabProjectConsultantDataSourceImpl()),
  );

  static final getHbLabIdeasBoxUsecase = HbLabIdeasBoxUsecase(
    HbLabIdeasBoxRepositoryImpl(HbLabIdeasBoxDataSourceImpl()),
  );
  static final getHbLabIdeasBoxAccountingUsecase =
      HbLabIdeasBoxAccountingUsecase(
    HbLabIdeasBoxAccountingRepositoryImpl(
        HbLabIdeasBoxAccountingDataSourceImpl()),
  );

  static final getJobProjectUsecase = JobProjectUsecase(
    JobProjectRepositoryImpl(JobProjectDataSourceImpl()),
  );

  static final getDetailsJobProjectUsecase = DetailsJobProjectUsecase(
    DetailsJobProjectReopsitoryImpl(DetailsJobProjectDataSourceImpl()),
  );

  static final getCoursesUseCase = GetCoursesUseCase(
    CourseRepositoryImpl(CourseRemoteDataSourceImpl()),
  );

  static final getCourseDetailUseCase = GetCourseDetailUseCase(
    CourseDetailRepositoryImpl(CourseDetailDataSourceImpl()),
  );

  static final getJobsInternshipUsecase = GetJobsInternshipUsecase(
    JobsInternshipRepositoryImpl(JobsInternshipDataSourceImpl()),
  );

  static final getPaymantInvoiceUsecase = PaymantInvoiceUsecase(
    PaymantInvoiceRepositoryImpl(InvoicesRemoteDataSourceImpl()),
  );

  static final getMyCouresesUsecase = MyCouresesUsecase(
    MyCouresesRepositoryImpl(MyCouresesDataSourceImpl()),
  );
  static final getMyApplicationUsecase = MyApplicationUsecase(
    MyApplicationRepositoryImpl(MyApplicationRemoteDataSourceImpl()),
  );
  static final getAccountingRequestUsecase = AccountingRequestUsecase(
    AccountingRequestRepositoryImpl(AccountingRequestRemoteDataSourceImpl()),
  );
  static final getServicesUsecase = ServicesUsecase(
    ServicesRepositoryImpl(ServicesRemoteDataSourceImpl()),
  );
  static final getServiceDetailsUsecase = ServiceDetailsUsecase(
    ServicesRepositoryImpl(ServicesRemoteDataSourceImpl()),
  );
  static final getServiceTypesUsecase = ServiceTypesUsecase(
    ServiceTypesRepositoryImpl(ServiceTypesRemoteDataSourceImpl()),
  );
  static final createServiceRequestUsecase = CreateServiceRequestUsecase(
    ServiceRequestRepositoryImpl(ServiceRequestRemoteDataSourceImpl()),
  );
  static final getServiceRequestsUsecase = GetServiceRequestsUsecase(
    ServiceRequestRepositoryImpl(ServiceRequestRemoteDataSourceImpl()),
  );
  static final getServiceRequestDetailsUsecase =
      GetServiceRequestDetailsUsecase(
    ServiceRequestRepositoryImpl(ServiceRequestRemoteDataSourceImpl()),
  );
  static final updateServiceRequestUsecase = UpdateServiceRequestUsecase(
    ServiceRequestRepositoryImpl(ServiceRequestRemoteDataSourceImpl()),
  );
  static final uploadServiceRequestFilesUsecase =
      UploadServiceRequestFilesUsecase(
    ServiceRequestRepositoryImpl(ServiceRequestRemoteDataSourceImpl()),
  );
  static final cancelServiceRequestUsecase = CancelServiceRequestUsecase(
    ServiceRequestRepositoryImpl(ServiceRequestRemoteDataSourceImpl()),
  );
  static final getConsultantRequestsUsecase = ConsultantRequestsUsecase(
    ConsultantRequestsRepositoryImpl(ConsultantRequestsRemoteDataSourceImpl()),
  );
  static final createConsultantRequestUsecase = CreateConsultantRequestUsecase(
    ConsultantRequestsRepositoryImpl(ConsultantRequestsRemoteDataSourceImpl()),
  );
  static final getConsultantDetailsUsecase = ConsultantDetailsUsecase(
    ConsultantRepositoryImpl(ConsultantRemoteDataSourceImpl()),
  );
  static final getConsultantCvUsecase = ConsultantCvUsecase(
    ConsultantRepositoryImpl(ConsultantRemoteDataSourceImpl()),
  );
  static final getConsultantCategoriesUsecase = ConsultantCategoriesUsecase(
    ConsultantRepositoryImpl(ConsultantRemoteDataSourceImpl()),
  );
  static final getConsultantUsecase = ConsultantUsecase(
    ConsultantRepositoryImpl(ConsultantRemoteDataSourceImpl()),
  );
  static final getReportInvoiceUsecase = ReportInvoiceUsecase(
    ReportInvoiceRepositoryImpl(ReportInvoiceRemoteDataSourceImpl()),
  );

  static final getCountryUsecase = CountryUsecase(
    CountryRepositoryImpl(CountryRemoteDataSourceImpl()),
  );

  static final getConsultantLookupsUsecase = ConsultantLookupsUsecase(
    ConsultantLookupsRepositoryImpl(ConsultantLookupsDataSourceImpl()),
  );

  static final getCityUsecase = CityUsecase(CityRepositoryImpl(CityRemoteDataSourceImpl()));
  static final getIndustryUsecase =
      IndustryUsecase(IndustryRepositoryImpl(IndustryRemoteDataSourceImpl()));

  static final getProfileUsecase = ProfileUsecase(
    ProfileRepositoryImpl(ProfileRemoteDataSourceImpl()),
  );
  static final getDashboardUsecase = DashboardUsecase(
    DashboardRepositoryImpl(DashboardRemoteDataSourceImpl()),
  );
  static final getMilestoneUsecase = MilestoneUsecase(
    MilestoneRepositoryImpl(MilestoneRemoteDataSourceImpl()),
  );
  static final getAssignConsultantUsecase = AssignConsultantUsecase(
    AssignConsultantRepositoryImpl(AssignConsultantRemoteDataSourceImpl()),
  );
  static final uploadProjectFileUseCase = UploadProjectFileUseCase(
    ProjectFileRepositoryImpl(ProjectFileRemoteDataSourceImpl()),
  );
  static final getTrainingCoursesUsecase = GetTrainingCoursesUsecase(
    TrainingCoursesRepositoryImpl(TrainingCoursesRemoteDatasourceImpl()),
  );
  static final getEmployeesProgressUsecase = GetEmployeesProgressUsecase(
    EmployeeProgressRepositoryImpl(EmployeeProgressDatasourceImpl()),
  );
  static final getConsultantDashboardUsecase = ConsultantDashboardUsecase(
    ConsultantDashboardRepositoryImpl(ConsultantDashboardDataSourceImpl()),
  );
  static final getJobApplyUsecase = JobApplyUsecase(
    JobApplyRepositoryImpl(JobApplyDataSourceImpl()),
  );
  static final getHbLabJoinUsecase = HbLabJoinUsecase(
    HbLabJoinRepositoryImpl(HbLabJoinDataSourceImpl()),
  );
  // قسم الاستشاري: نفس المنطق، endpoint مختلف (/api/consultant/...)
  static final getHbLabJoinConsultantUsecase = HbLabJoinUsecase(
    HbLabJoinRepositoryImpl(HbLabJoinConsultantDataSourceImpl()),
  );
  static final getBoostProjectUsecase = BoostProjectUsecase(
    BoostProjectRepositoryImpl(BoostProjectDataSourceImpl()),
  );
  static final getDetailsIdeasBoxUsecase = DetailsIdeasBoxUsecase(
    DetailsIdeasBoxRepositoryImpl(DetailsIdeasBoxDataSourceImpl()),
  );
  // قسم الاستشاري: نفس المنطق، endpoint مختلف (/api/consultant/...)
  static final getDetailsIdeasBoxConsultantUsecase = DetailsIdeasBoxUsecase(
    DetailsIdeasBoxRepositoryImpl(DetailsIdeasBoxConsultantDataSourceImpl()),
  );
  static final getSubmitIdeaUsecase = SubmitIdeaUsecase(
    SubmitIdeaRepositoryImpl(SubmitIdeaDataSourceImpl()),
  );
  // قسم الاستشاري: نفس المنطق، endpoint مختلف (/api/consultant/...)
  static final getSubmitIdeaConsultantUsecase = SubmitIdeaUsecase(
    SubmitIdeaRepositoryImpl(SubmitIdeaConsultantDataSourceImpl()),
  );
  static final getHbLabUpvoteUsecase = HbLabUpvoteUsecase(
    HbLabUpvoteRepositoryImpl(HbLabUpvoteDataSourceImpl()),
  );
  // قسم الاستشاري: نفس المنطق، endpoint مختلف (/api/consultant/...)
  static final getHbLabUpvoteConsultantUsecase = HbLabUpvoteUsecase(
    HbLabUpvoteRepositoryImpl(HbLabUpvoteConsultantDataSourceImpl()),
  );
  static final getHbLabCommentUsecase = HbLabCommentUsecase(
    HbLabCommentRepositoryImpl(HbLabCommentDataSourceImpl()),
  );
  // قسم الاستشاري: نفس المنطق، endpoint مختلف (/api/consultant/...)
  static final getHbLabCommentConsultantUsecase = HbLabCommentUsecase(
    HbLabCommentRepositoryImpl(HbLabCommentConsultantDataSourceImpl()),
  );
  static final scheduleInterviewUsecase = ScheduleInterviewUsecase(
    ScheduleInterviewRepositoryImpl(ScheduleInterviewDataSourceImpl()),
  );
  static final rejectApplicationUsecase = RejectApplicationUsecase(
    RejectApplicationRepositoryImpl(RejectApplicationDataSourceImpl()),
  );
  static final courseEnrollUsecase = CourseEnrollUsecase(
    CourseEnrollRepositoryImpl(CourseEnrollDataSourceImpl()),
  );
  static final jobOpportunityDetailsUsecase = JobOpportunityDetailsUsecase(
    JobOpportunityDetailsRepositoryImpl(JobOpportunityDetailsDataSourceImpl()),
  );
  static final applyJobUsecase = ApplyJobUsecase(
    ApplyJobRepositoryImpl(ApplyJobDataSourceImpl()),
  );
  static final myCourseDetailsUsecase = MyCourseDetailsUsecase(
    MyCourseDetailsRepositoryImpl(MyCourseDetailsDataSourceImpl()),
  );
  static final completedCoursesUsecase = CompletedCoursesUsecase(
    CompletedCoursesRepositoryImpl(CompletedCoursesDataSourceImpl()),
  );
  static final detailsMyApplicationUsecase = DetailsMyApplicationUsecase(
    DetailsMyApplicationRepositoryImpl(DetailsMyApplicationDataSourceImpl()),
  );
  static final storeTokenUsecase = StoreTokenUsecase(
    StoreTokenRepositoryImpl(StoreTokenDataSourceImpl()),
  );
}
