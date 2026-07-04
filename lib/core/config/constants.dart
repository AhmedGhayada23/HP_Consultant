class Constants {
  static const int receiveTimeout = 60000;
  static const int connectionTimeout = 60000;
  static const String baseUrl =
      'https://workspace.hbconsulting-services.com/api/v1';
  static const String imageUrl = 'https://workspace.hbconsulting-services.com';
  static const String loginUrl = '/auth/login';
  static const String registerUrl = '/auth/register';
  static const String sendCodeForActivateUrl = '/auth/send-code-for-activate';
  static const String checkCodeForActivateUrl = '/auth/check-code-for-activate';
  static const String profileUrl = '/profile/me';
  static const String dashboardCamponyUrl = '/dashboard/stats';
  static const String updatePasswordUrl = '/profile/update-password';
  static const String countryCodesUrl = '/countries';
  static const String profileUpdateDataUrl = '/profile/update-data';
  static const String deleteAccountUrl = '/profile/delete-account';
  static const String forgetPasswordSendCodeUrl = '/forget-password/send-code';
  static const String forgetPasswordCheckCodeUrl =
      '/forget-password/check-code';
  static const String forgetResetPasswordUrl =
      '/forget-password/reset-password';
  static const String jobsUrl = '/jobs';
  static const String skillsUrl = '/list/skills';
  static const String projectTypesUrl = '/list/project_types';
  static const String paymentTypesUrl = '/list/payment_types';
  static const String consultantsUrl = '/consultants';
  static const String consultantsDirectoryUrl = '/consultants-directory';
  static const String consultantCategoriesUrl = '/consultant-categories';
  static const String consultantRequestsUrl = '/consultant-requests';
  static const String projectsUrl = '/projects';
  static const String servicesUrl = '/services';
  static const String serviceTypesUrl = '/service-types';
  static const String serviceRequestsUrl = '/service-requests';
  static const String meetingRequestsUrl = '/meeting-requests';
  static const String trainingPurchasedUrl = '/training/purchased';
  static const String trainingCoursesUrl = '/training/courses';
  static const String trainingPurchaseUrl = '/training/purchase';
  static const String employeesProgressUrl = '/training/employees-progress';
  static const String reportInvoicesUrl = '/invoices';
  static const String reportsInvoicesUrl = '/reports-invoices';
  static const String industriesUrl = '/industries';
  static const String consultantLookupsUrl =
      'https://workspace.hbconsulting-services.com/api/consultant/lookups';
  static const String consultantRegisterUrl =
      'https://workspace.hbconsulting-services.com/api/consultant/register';
  static const String consultantDashboardUrl =
      'https://workspace.hbconsulting-services.com/api/consultant/dashboard';
  static const String consultantJobsUrl =
      'https://workspace.hbconsulting-services.com/api/consultant/jobs';
  static const String consultantProjectsUrl =
      'https://workspace.hbconsulting-services.com/api/consultant/projects';
  static const String hbLabProjectsUrl =
      'https://workspace.hbconsulting-services.com/api/consultant/hb-lab/projects';
  static const String hbLabProjectsAccountingUrl =
      'https://workspace.hbconsulting-services.com/api/v1/hb-lab/projects';
  static const String hbLabIdeasUrl =
      'https://workspace.hbconsulting-services.com/api/consultant/hb-lab/ideas';
  static const String hbLabIdeasAccountingUrl =
      'https://workspace.hbconsulting-services.com/api/v1/hb-lab/ideas';

  static const String chatConversationsUrl =
      'https://workspace.hbconsulting-services.com/api/chat/conversations';
  static const String chatDirectConversationsUrl =
      'https://workspace.hbconsulting-services.com/api/chat/direct/conversations';

  // ── Pusher ─────────────────────────────────────────────────────────────────
  static const String pusherAppKey        = 'ae104d95199f36b7b3c9';
  static const String pusherCluster       = 'ap2';
  static const String pusherAuthUrl       =
      'https://workspace.hbconsulting-services.com/api/broadcasting/auth';
  static const String pusherChannelConversation = 'private-conversation.'; // + conversationId
  static const String pusherChannelUser         = 'private-user.';         // + userId
  static const String pusherEventMessage        = 'message.sent';
  static const String pusherEventConversation   = 'conversation.updated';
  static const String pusherEventNotification   = 'notification.created';
  // ───────────────────────────────────────────────────────────────────────────

  static const String notificationsUrl =
      'https://workspace.hbconsulting-services.com/api/notifications';
  static const String notificationsUnreadCountUrl =
      'https://workspace.hbconsulting-services.com/api/notifications/unread-count';
  static const String notificationsReadAllUrl =
      'https://workspace.hbconsulting-services.com/api/notifications/read-all';

  static const String token = 'token';
  static const String userId = 'user_id';
  static const String onBorder = 'onBorder';
  static const String langCode = 'lang_code';
}
