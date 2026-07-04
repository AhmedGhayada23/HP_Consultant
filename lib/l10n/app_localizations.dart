import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcome_back;

  /// No description provided for @please_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Please Sign in to Continue'**
  String get please_sign_in;

  /// No description provided for @email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email_address;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @remember_me.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get remember_me;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgot_password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @join_as_guest.
  ///
  /// In en, this message translates to:
  /// **'Join as a Guest'**
  String get join_as_guest;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account?'**
  String get dont_have_account;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get sign_up;

  /// No description provided for @choose_language.
  ///
  /// In en, this message translates to:
  /// **'Choose your language...'**
  String get choose_language;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @sign_up_as.
  ///
  /// In en, this message translates to:
  /// **'Sign up as...'**
  String get sign_up_as;

  /// No description provided for @as_company.
  ///
  /// In en, this message translates to:
  /// **'As a Company'**
  String get as_company;

  /// No description provided for @as_consultant.
  ///
  /// In en, this message translates to:
  /// **'As a Consultant'**
  String get as_consultant;

  /// No description provided for @as_student.
  ///
  /// In en, this message translates to:
  /// **'As a Student'**
  String get as_student;

  /// No description provided for @as_accounting_client.
  ///
  /// In en, this message translates to:
  /// **'As an Accounting Client'**
  String get as_accounting_client;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @upload_image.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get upload_image;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @mobile_number.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobile_number;

  /// No description provided for @company_name.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get company_name;

  /// No description provided for @registration_number.
  ///
  /// In en, this message translates to:
  /// **'Registration Number'**
  String get registration_number;

  /// No description provided for @industry.
  ///
  /// In en, this message translates to:
  /// **'Industry'**
  String get industry;

  /// No description provided for @main_country.
  ///
  /// In en, this message translates to:
  /// **'Main Country'**
  String get main_country;

  /// No description provided for @main_city.
  ///
  /// In en, this message translates to:
  /// **'Main City'**
  String get main_city;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @agree_terms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms & Conditions and Privacy Policy'**
  String get agree_terms;

  /// No description provided for @continue_signup.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_signup;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @jobs_talent.
  ///
  /// In en, this message translates to:
  /// **'Jobs & Talent'**
  String get jobs_talent;

  /// No description provided for @consultants_projects.
  ///
  /// In en, this message translates to:
  /// **'Consultants & Projects'**
  String get consultants_projects;

  /// No description provided for @employee_development.
  ///
  /// In en, this message translates to:
  /// **'Employee Development'**
  String get employee_development;

  /// No description provided for @invoices_finance.
  ///
  /// In en, this message translates to:
  /// **'Invoices & Finance'**
  String get invoices_finance;

  /// No description provided for @chat_support.
  ///
  /// In en, this message translates to:
  /// **'Chat & Support'**
  String get chat_support;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @failed_to_load_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Failed to Load Dashboard'**
  String get failed_to_load_dashboard;

  /// No description provided for @recommended_jobs_for_you.
  ///
  /// In en, this message translates to:
  /// **'Recommended Jobs for You'**
  String get recommended_jobs_for_you;

  /// No description provided for @no_recommended_jobs.
  ///
  /// In en, this message translates to:
  /// **'No Recommended Jobs'**
  String get no_recommended_jobs;

  /// No description provided for @no_recommended_jobs_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Check back later for jobs that match your skills.'**
  String get no_recommended_jobs_subtitle;

  /// No description provided for @no_active_projects.
  ///
  /// In en, this message translates to:
  /// **'No Active Projects'**
  String get no_active_projects;

  /// No description provided for @no_active_projects_subtitle.
  ///
  /// In en, this message translates to:
  /// **'You have no active projects at the moment.'**
  String get no_active_projects_subtitle;

  /// No description provided for @earnings_this_month.
  ///
  /// In en, this message translates to:
  /// **'Earnings (this Month)'**
  String get earnings_this_month;

  /// No description provided for @hb_lab_activity.
  ///
  /// In en, this message translates to:
  /// **'HB Lab Activity'**
  String get hb_lab_activity;

  /// No description provided for @next_milestone.
  ///
  /// In en, this message translates to:
  /// **'Next Milestone'**
  String get next_milestone;

  /// No description provided for @milestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get milestones;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @ideas.
  ///
  /// In en, this message translates to:
  /// **'Ideas'**
  String get ideas;

  /// No description provided for @of_count.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get of_count;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @profile_settings.
  ///
  /// In en, this message translates to:
  /// **'Profile & Settings'**
  String get profile_settings;

  /// No description provided for @active_projects.
  ///
  /// In en, this message translates to:
  /// **'Active Projects'**
  String get active_projects;

  /// No description provided for @active_consultants.
  ///
  /// In en, this message translates to:
  /// **'Active Consultants'**
  String get active_consultants;

  /// No description provided for @pending_applications.
  ///
  /// In en, this message translates to:
  /// **'Pending Applications'**
  String get pending_applications;

  /// No description provided for @upcoming_deadlines.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Deadlines'**
  String get upcoming_deadlines;

  /// No description provided for @recent_invoices.
  ///
  /// In en, this message translates to:
  /// **'Recent Invoices'**
  String get recent_invoices;

  /// No description provided for @latest_projects.
  ///
  /// In en, this message translates to:
  /// **'Latest Projects'**
  String get latest_projects;

  /// No description provided for @search_jobs_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Search jobs by title, skills, or company…'**
  String get search_jobs_placeholder;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @applicants.
  ///
  /// In en, this message translates to:
  /// **'Applicants'**
  String get applicants;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline;

  /// No description provided for @created_on.
  ///
  /// In en, this message translates to:
  /// **'Created On'**
  String get created_on;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @post_new_job.
  ///
  /// In en, this message translates to:
  /// **'Post New Job'**
  String get post_new_job;

  /// No description provided for @status_all.
  ///
  /// In en, this message translates to:
  /// **'Status | All'**
  String get status_all;

  /// No description provided for @on_hold.
  ///
  /// In en, this message translates to:
  /// **'On Hold'**
  String get on_hold;

  /// No description provided for @finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finance;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @pending_request.
  ///
  /// In en, this message translates to:
  /// **'Pending Request'**
  String get pending_request;

  /// No description provided for @in_progress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get in_progress;

  /// No description provided for @pending_payment.
  ///
  /// In en, this message translates to:
  /// **'Pending Payment'**
  String get pending_payment;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @budget_min.
  ///
  /// In en, this message translates to:
  /// **'Budget (Minimum)'**
  String get budget_min;

  /// No description provided for @budget_max.
  ///
  /// In en, this message translates to:
  /// **'Budget (Maximum)'**
  String get budget_max;

  /// No description provided for @required_skills_multiselect.
  ///
  /// In en, this message translates to:
  /// **'Required Skills (Multi Select)'**
  String get required_skills_multiselect;

  /// No description provided for @project_type.
  ///
  /// In en, this message translates to:
  /// **'Project Type'**
  String get project_type;

  /// No description provided for @payment_type.
  ///
  /// In en, this message translates to:
  /// **'Payment Type'**
  String get payment_type;

  /// No description provided for @job_files.
  ///
  /// In en, this message translates to:
  /// **'Job Files'**
  String get job_files;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @job_details.
  ///
  /// In en, this message translates to:
  /// **'Job Details'**
  String get job_details;

  /// No description provided for @required_skills.
  ///
  /// In en, this message translates to:
  /// **'Required Skills'**
  String get required_skills;

  /// No description provided for @job_title.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get job_title;

  /// No description provided for @job_description.
  ///
  /// In en, this message translates to:
  /// **'Job Description'**
  String get job_description;

  /// No description provided for @job_applicants.
  ///
  /// In en, this message translates to:
  /// **'Job Applicants'**
  String get job_applicants;

  /// No description provided for @profession.
  ///
  /// In en, this message translates to:
  /// **'Profession'**
  String get profession;

  /// No description provided for @major.
  ///
  /// In en, this message translates to:
  /// **'Major'**
  String get major;

  /// No description provided for @rate_per_hour.
  ///
  /// In en, this message translates to:
  /// **'Rate/hr'**
  String get rate_per_hour;

  /// No description provided for @skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skills;

  /// No description provided for @applied_on.
  ///
  /// In en, this message translates to:
  /// **'Applied On'**
  String get applied_on;

  /// No description provided for @edit_job.
  ///
  /// In en, this message translates to:
  /// **'Edit Job'**
  String get edit_job;

  /// No description provided for @close_job.
  ///
  /// In en, this message translates to:
  /// **'Close Job'**
  String get close_job;

  /// No description provided for @close_job_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close this job? Applicants will no longer be able to apply.'**
  String get close_job_confirm_message;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @applicant_details.
  ///
  /// In en, this message translates to:
  /// **'Applicant Details'**
  String get applicant_details;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @applied_date.
  ///
  /// In en, this message translates to:
  /// **'Applied Date'**
  String get applied_date;

  /// No description provided for @download_cv.
  ///
  /// In en, this message translates to:
  /// **'Download CV'**
  String get download_cv;

  /// No description provided for @cv_downloaded.
  ///
  /// In en, this message translates to:
  /// **'CV downloaded successfully'**
  String get cv_downloaded;

  /// No description provided for @downloaded_no_viewer.
  ///
  /// In en, this message translates to:
  /// **'File downloaded, but no app was found to open it'**
  String get downloaded_no_viewer;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @busy.
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get busy;

  /// No description provided for @any_budget.
  ///
  /// In en, this message translates to:
  /// **'Any Budget'**
  String get any_budget;

  /// No description provided for @recent_projects.
  ///
  /// In en, this message translates to:
  /// **'Recent Projects'**
  String get recent_projects;

  /// No description provided for @work_history.
  ///
  /// In en, this message translates to:
  /// **'Work History'**
  String get work_history;

  /// No description provided for @invite_to_interview.
  ///
  /// In en, this message translates to:
  /// **'Invite to Interview'**
  String get invite_to_interview;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @hire.
  ///
  /// In en, this message translates to:
  /// **'Hire'**
  String get hire;

  /// No description provided for @available_dates.
  ///
  /// In en, this message translates to:
  /// **'Available Dates'**
  String get available_dates;

  /// No description provided for @schedule_meeting.
  ///
  /// In en, this message translates to:
  /// **'Schedule Meeting'**
  String get schedule_meeting;

  /// No description provided for @meeting_title.
  ///
  /// In en, this message translates to:
  /// **'Meeting Title'**
  String get meeting_title;

  /// No description provided for @meeting_date.
  ///
  /// In en, this message translates to:
  /// **'Meeting Date'**
  String get meeting_date;

  /// No description provided for @meeting_time.
  ///
  /// In en, this message translates to:
  /// **'Meeting Time'**
  String get meeting_time;

  /// No description provided for @meeting_link.
  ///
  /// In en, this message translates to:
  /// **'Meeting Link'**
  String get meeting_link;

  /// No description provided for @consultant_meeting_requests.
  ///
  /// In en, this message translates to:
  /// **'Consultant Meeting Requests'**
  String get consultant_meeting_requests;

  /// No description provided for @search_by_title.
  ///
  /// In en, this message translates to:
  /// **'Search by title...'**
  String get search_by_title;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @role_expertise.
  ///
  /// In en, this message translates to:
  /// **'Role / Expertise'**
  String get role_expertise;

  /// No description provided for @assigned_projects.
  ///
  /// In en, this message translates to:
  /// **'Assigned Project(s)'**
  String get assigned_projects;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @view_consultant_profile.
  ///
  /// In en, this message translates to:
  /// **'View Consultant Profile'**
  String get view_consultant_profile;

  /// No description provided for @assign_to_project.
  ///
  /// In en, this message translates to:
  /// **'Assign to a project'**
  String get assign_to_project;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @consultant_profile.
  ///
  /// In en, this message translates to:
  /// **'Consultant Profile'**
  String get consultant_profile;

  /// No description provided for @start_chat.
  ///
  /// In en, this message translates to:
  /// **'Start Chat'**
  String get start_chat;

  /// No description provided for @consultant_overview.
  ///
  /// In en, this message translates to:
  /// **'Consultant Overview'**
  String get consultant_overview;

  /// No description provided for @skill_tags.
  ///
  /// In en, this message translates to:
  /// **'Skill Tags'**
  String get skill_tags;

  /// No description provided for @history_with_this_company.
  ///
  /// In en, this message translates to:
  /// **'History with this Company'**
  String get history_with_this_company;

  /// No description provided for @view_assigned_projects.
  ///
  /// In en, this message translates to:
  /// **'View Assigned Projects'**
  String get view_assigned_projects;

  /// No description provided for @role_in_project.
  ///
  /// In en, this message translates to:
  /// **'Role in Project'**
  String get role_in_project;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @assign_consultant.
  ///
  /// In en, this message translates to:
  /// **'Assign Consultant'**
  String get assign_consultant;

  /// No description provided for @consultant.
  ///
  /// In en, this message translates to:
  /// **'Consultant'**
  String get consultant;

  /// No description provided for @milestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone'**
  String get milestone;

  /// No description provided for @full_time.
  ///
  /// In en, this message translates to:
  /// **'Full Time'**
  String get full_time;

  /// No description provided for @part_time.
  ///
  /// In en, this message translates to:
  /// **'Part Time'**
  String get part_time;

  /// No description provided for @contract.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get contract;

  /// No description provided for @freelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get freelance;

  /// No description provided for @fixed_price.
  ///
  /// In en, this message translates to:
  /// **'Fixed Price'**
  String get fixed_price;

  /// No description provided for @hourly_rate_type.
  ///
  /// In en, this message translates to:
  /// **'Hourly'**
  String get hourly_rate_type;

  /// No description provided for @milestone_payments.
  ///
  /// In en, this message translates to:
  /// **'Milestone Payments'**
  String get milestone_payments;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @new_project.
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get new_project;

  /// No description provided for @project_details.
  ///
  /// In en, this message translates to:
  /// **'Project Details'**
  String get project_details;

  /// No description provided for @consultants_assigned.
  ///
  /// In en, this message translates to:
  /// **'Consultants Assigned'**
  String get consultants_assigned;

  /// No description provided for @add_consultant.
  ///
  /// In en, this message translates to:
  /// **'Add Consultant'**
  String get add_consultant;

  /// No description provided for @add_new_consultant.
  ///
  /// In en, this message translates to:
  /// **'Add New Consultant'**
  String get add_new_consultant;

  /// No description provided for @edit_project.
  ///
  /// In en, this message translates to:
  /// **'Edit Project'**
  String get edit_project;

  /// No description provided for @upload_a_new_file.
  ///
  /// In en, this message translates to:
  /// **'Upload a New File'**
  String get upload_a_new_file;

  /// No description provided for @close_project.
  ///
  /// In en, this message translates to:
  /// **'Close Project'**
  String get close_project;

  /// No description provided for @project_milestones.
  ///
  /// In en, this message translates to:
  /// **'Project Milestones'**
  String get project_milestones;

  /// No description provided for @assigned_to.
  ///
  /// In en, this message translates to:
  /// **'Assigned To'**
  String get assigned_to;

  /// No description provided for @project_files_deliverables.
  ///
  /// In en, this message translates to:
  /// **'Project Files / Deliverables'**
  String get project_files_deliverables;

  /// No description provided for @view_file.
  ///
  /// In en, this message translates to:
  /// **'View File'**
  String get view_file;

  /// No description provided for @upload_file.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get upload_file;

  /// No description provided for @consultant_name.
  ///
  /// In en, this message translates to:
  /// **'Consultant Name'**
  String get consultant_name;

  /// No description provided for @create_new_project.
  ///
  /// In en, this message translates to:
  /// **'Create New Project'**
  String get create_new_project;

  /// No description provided for @project_title.
  ///
  /// In en, this message translates to:
  /// **'Project Title'**
  String get project_title;

  /// No description provided for @project_category.
  ///
  /// In en, this message translates to:
  /// **'Project Category'**
  String get project_category;

  /// No description provided for @category_consulting.
  ///
  /// In en, this message translates to:
  /// **'Consulting'**
  String get category_consulting;

  /// No description provided for @category_technology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get category_technology;

  /// No description provided for @category_development.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get category_development;

  /// No description provided for @category_design.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get category_design;

  /// No description provided for @category_training.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get category_training;

  /// No description provided for @category_audit.
  ///
  /// In en, this message translates to:
  /// **'Audit'**
  String get category_audit;

  /// No description provided for @category_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get category_other;

  /// No description provided for @category_it_development.
  ///
  /// In en, this message translates to:
  /// **'IT / Development'**
  String get category_it_development;

  /// No description provided for @category_accounting.
  ///
  /// In en, this message translates to:
  /// **'Accounting'**
  String get category_accounting;

  /// No description provided for @category_ai_nlp.
  ///
  /// In en, this message translates to:
  /// **'AI / NLP'**
  String get category_ai_nlp;

  /// No description provided for @category_data_science.
  ///
  /// In en, this message translates to:
  /// **'Data Science'**
  String get category_data_science;

  /// No description provided for @category_rpa_it.
  ///
  /// In en, this message translates to:
  /// **'RPA / IT'**
  String get category_rpa_it;

  /// No description provided for @in_review.
  ///
  /// In en, this message translates to:
  /// **'In Review'**
  String get in_review;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @assigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get assigned;

  /// No description provided for @start_date.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get start_date;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @project_description.
  ///
  /// In en, this message translates to:
  /// **'Project Description'**
  String get project_description;

  /// No description provided for @milestone_title.
  ///
  /// In en, this message translates to:
  /// **'Milestone Title'**
  String get milestone_title;

  /// No description provided for @due_date.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get due_date;

  /// No description provided for @budget_allocation.
  ///
  /// In en, this message translates to:
  /// **'Budget Allocation'**
  String get budget_allocation;

  /// No description provided for @assign_to.
  ///
  /// In en, this message translates to:
  /// **'Assign To'**
  String get assign_to;

  /// No description provided for @deliverables_description.
  ///
  /// In en, this message translates to:
  /// **'Deliverables Description'**
  String get deliverables_description;

  /// No description provided for @add_milestone.
  ///
  /// In en, this message translates to:
  /// **'Add Milestone'**
  String get add_milestone;

  /// No description provided for @submit_new_project.
  ///
  /// In en, this message translates to:
  /// **'Submit New Project'**
  String get submit_new_project;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @new_request.
  ///
  /// In en, this message translates to:
  /// **'New Request'**
  String get new_request;

  /// No description provided for @start_chat_with_admin.
  ///
  /// In en, this message translates to:
  /// **'Start Chat with Admin'**
  String get start_chat_with_admin;

  /// No description provided for @start_chat_with_consultant.
  ///
  /// In en, this message translates to:
  /// **'Start Chat with Consultant'**
  String get start_chat_with_consultant;

  /// No description provided for @cancel_request.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get cancel_request;

  /// No description provided for @request_id.
  ///
  /// In en, this message translates to:
  /// **'Request ID'**
  String get request_id;

  /// No description provided for @urgency.
  ///
  /// In en, this message translates to:
  /// **'Urgency'**
  String get urgency;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// No description provided for @not_urgent.
  ///
  /// In en, this message translates to:
  /// **'Not Urgent'**
  String get not_urgent;

  /// No description provided for @request_submitted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Request Submitted Successfully'**
  String get request_submitted_successfully;

  /// No description provided for @consultant_request_sent.
  ///
  /// In en, this message translates to:
  /// **'Your consultant request has been sent.'**
  String get consultant_request_sent;

  /// No description provided for @service_category.
  ///
  /// In en, this message translates to:
  /// **'Service Category'**
  String get service_category;

  /// No description provided for @title_of_request.
  ///
  /// In en, this message translates to:
  /// **'Title of Request'**
  String get title_of_request;

  /// No description provided for @preferred_consultant_type.
  ///
  /// In en, this message translates to:
  /// **'Preferred Consultant Type'**
  String get preferred_consultant_type;

  /// No description provided for @preferred_start_date.
  ///
  /// In en, this message translates to:
  /// **'Preferred Start Date'**
  String get preferred_start_date;

  /// No description provided for @estimated_duration.
  ///
  /// In en, this message translates to:
  /// **'Estimated Duration'**
  String get estimated_duration;

  /// No description provided for @budget_range_min.
  ///
  /// In en, this message translates to:
  /// **'Budget Range (Min)'**
  String get budget_range_min;

  /// No description provided for @budget_range_max.
  ///
  /// In en, this message translates to:
  /// **'Budget Range (Max)'**
  String get budget_range_max;

  /// No description provided for @upload_supporting_document.
  ///
  /// In en, this message translates to:
  /// **'Upload Supporting Document'**
  String get upload_supporting_document;

  /// No description provided for @budget_range.
  ///
  /// In en, this message translates to:
  /// **'Budget Range'**
  String get budget_range;

  /// No description provided for @assigned_consultant.
  ///
  /// In en, this message translates to:
  /// **'Assigned Consultant'**
  String get assigned_consultant;

  /// No description provided for @meeting_details.
  ///
  /// In en, this message translates to:
  /// **'Meeting Details'**
  String get meeting_details;

  /// No description provided for @consultant_role.
  ///
  /// In en, this message translates to:
  /// **'Consultant (role)'**
  String get consultant_role;

  /// No description provided for @supporting_document.
  ///
  /// In en, this message translates to:
  /// **'Supporting Document'**
  String get supporting_document;

  /// No description provided for @purchase_date.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get purchase_date;

  /// No description provided for @assigned_employees.
  ///
  /// In en, this message translates to:
  /// **'Assigned Employees'**
  String get assigned_employees;

  /// No description provided for @progress_avg.
  ///
  /// In en, this message translates to:
  /// **'Progress Avg'**
  String get progress_avg;

  /// No description provided for @completion_rate.
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get completion_rate;

  /// No description provided for @assign.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get assign;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @purchase_new_course.
  ///
  /// In en, this message translates to:
  /// **'Purchase New Course'**
  String get purchase_new_course;

  /// No description provided for @course_title.
  ///
  /// In en, this message translates to:
  /// **'Course Title'**
  String get course_title;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get selectCountry;

  /// No description provided for @available_countries.
  ///
  /// In en, this message translates to:
  /// **'Available Countries'**
  String get available_countries;

  /// No description provided for @noInvoices.
  ///
  /// In en, this message translates to:
  /// **'No invoices'**
  String get noInvoices;

  /// No description provided for @startFirstInvoice.
  ///
  /// In en, this message translates to:
  /// **'Start creating your first invoice'**
  String get startFirstInvoice;

  /// No description provided for @createNewInvoice.
  ///
  /// In en, this message translates to:
  /// **'Create new invoice'**
  String get createNewInvoice;

  /// No description provided for @noActiveProjects.
  ///
  /// In en, this message translates to:
  /// **'No active projects'**
  String get noActiveProjects;

  /// No description provided for @addNewProjectHint.
  ///
  /// In en, this message translates to:
  /// **'Add a new project to get started'**
  String get addNewProjectHint;

  /// No description provided for @addProject.
  ///
  /// In en, this message translates to:
  /// **'Add project'**
  String get addProject;

  /// No description provided for @no_jobs_available.
  ///
  /// In en, this message translates to:
  /// **'No jobs available'**
  String get no_jobs_available;

  /// No description provided for @start_posting_jobs.
  ///
  /// In en, this message translates to:
  /// **'Start posting jobs to reach talents'**
  String get start_posting_jobs;

  /// No description provided for @job_type.
  ///
  /// In en, this message translates to:
  /// **'Job Type'**
  String get job_type;

  /// No description provided for @no_applicants.
  ///
  /// In en, this message translates to:
  /// **'No Applicants Yet'**
  String get no_applicants;

  /// No description provided for @no_applicants_subtitle.
  ///
  /// In en, this message translates to:
  /// **'No one has applied for this job yet. Share the listing to attract candidates.'**
  String get no_applicants_subtitle;

  /// No description provided for @consultants_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No Consultants Available'**
  String get consultants_empty_title;

  /// No description provided for @consultants_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'There are currently no consultants assigned to this project.'**
  String get consultants_empty_subtitle;

  /// No description provided for @meeting_requests_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No Meeting Requests'**
  String get meeting_requests_empty_title;

  /// No description provided for @meeting_requests_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'There are no meeting requests yet. Create a new request to get started.'**
  String get meeting_requests_empty_subtitle;

  /// No description provided for @no_files.
  ///
  /// In en, this message translates to:
  /// **'No Files'**
  String get no_files;

  /// No description provided for @please_upload_files.
  ///
  /// In en, this message translates to:
  /// **'Please upload your files'**
  String get please_upload_files;

  /// No description provided for @update_project.
  ///
  /// In en, this message translates to:
  /// **'Update Project'**
  String get update_project;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @contact_person.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get contact_person;

  /// No description provided for @change_language.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get change_language;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get log_out;

  /// No description provided for @session_expired_title.
  ///
  /// In en, this message translates to:
  /// **'Session Expired'**
  String get session_expired_title;

  /// No description provided for @session_expired_message.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Please log out and sign in again to continue.'**
  String get session_expired_message;

  /// No description provided for @terms_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms_conditions;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us;

  /// No description provided for @two_factor_auth.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get two_factor_auth;

  /// No description provided for @two_factor_desc.
  ///
  /// In en, this message translates to:
  /// **'Add an extra layer of security to your account. When enabled, you\'ll be asked to verify your identity with a code sent to your email or phone each time you log in.'**
  String get two_factor_desc;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @previous_password.
  ///
  /// In en, this message translates to:
  /// **'Previous Password'**
  String get previous_password;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @confirm_new_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirm_new_password;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @please_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password'**
  String get please_confirm_password;

  /// No description provided for @passwords_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_not_match;

  /// No description provided for @this_field.
  ///
  /// In en, this message translates to:
  /// **'This field'**
  String get this_field;

  /// No description provided for @field.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get field;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @is_required.
  ///
  /// In en, this message translates to:
  /// **'is required'**
  String get is_required;

  /// No description provided for @email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get email_required;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalid_email;

  /// No description provided for @min_length_prefix.
  ///
  /// In en, this message translates to:
  /// **'must be at least'**
  String get min_length_prefix;

  /// No description provided for @min_length_suffix.
  ///
  /// In en, this message translates to:
  /// **'characters long'**
  String get min_length_suffix;

  /// No description provided for @phone_required.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phone_required;

  /// No description provided for @phone_english_digits_only.
  ///
  /// In en, this message translates to:
  /// **'Phone number must contain only English digits'**
  String get phone_english_digits_only;

  /// No description provided for @phone_invalid_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number. It must start with 059 or 056 and be 10 digits long'**
  String get phone_invalid_format;

  /// No description provided for @does_not_match.
  ///
  /// In en, this message translates to:
  /// **'does not match'**
  String get does_not_match;

  /// No description provided for @must_contain_english_digits.
  ///
  /// In en, this message translates to:
  /// **'must contain only English digits'**
  String get must_contain_english_digits;

  /// No description provided for @must_be_positive_integer.
  ///
  /// In en, this message translates to:
  /// **'must be a positive integer without fractions or leading zeros'**
  String get must_be_positive_integer;

  /// No description provided for @password_weak.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long and include an uppercase letter, a lowercase letter, a number, and a special character.'**
  String get password_weak;

  /// No description provided for @forgot_password_desc.
  ///
  /// In en, this message translates to:
  /// **'If you have forgotten your password, please enter your email address associated with your account. We will send you instructions to reset your password.'**
  String get forgot_password_desc;

  /// No description provided for @email_verification.
  ///
  /// In en, this message translates to:
  /// **'Email Verification'**
  String get email_verification;

  /// No description provided for @email_verification_desc.
  ///
  /// In en, this message translates to:
  /// **'Check your email to verify your account, then please write the 5 digits we sent to your email.'**
  String get email_verification_desc;

  /// No description provided for @resend_verification_email.
  ///
  /// In en, this message translates to:
  /// **'Resend Verification Email'**
  String get resend_verification_email;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @log_out_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get log_out_confirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete_account_desc.
  ///
  /// In en, this message translates to:
  /// **'Deleting your HBConsulting account is permanent. All your data, messages, projects, and payment records will be deleted and cannot be recovered.'**
  String get delete_account_desc;

  /// No description provided for @keep_account.
  ///
  /// In en, this message translates to:
  /// **'Keep Account'**
  String get keep_account;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// No description provided for @select_file.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get select_file;

  /// No description provided for @select_a_file_to_upload.
  ///
  /// In en, this message translates to:
  /// **'Select a file to upload'**
  String get select_a_file_to_upload;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @view_details.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get view_details;

  /// No description provided for @apply_now.
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get apply_now;

  /// No description provided for @load_more.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get load_more;

  /// No description provided for @no_data_available.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get no_data_available;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @update_project_successfully.
  ///
  /// In en, this message translates to:
  /// **'Project Updated Successfully'**
  String get update_project_successfully;

  /// No description provided for @update_profile_successfully.
  ///
  /// In en, this message translates to:
  /// **'Profile Updated Successfully'**
  String get update_profile_successfully;

  /// No description provided for @project_submitted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Project Submitted Successfully'**
  String get project_submitted_successfully;

  /// No description provided for @project_submitted_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your project has been created and will be reviewed.'**
  String get project_submitted_subtitle;

  /// No description provided for @please_select_user_to_assign.
  ///
  /// In en, this message translates to:
  /// **'Please select a user to assign'**
  String get please_select_user_to_assign;

  /// No description provided for @milestone_added_successfully.
  ///
  /// In en, this message translates to:
  /// **'Milestone Added Successfully'**
  String get milestone_added_successfully;

  /// No description provided for @no_projects_found.
  ///
  /// In en, this message translates to:
  /// **'No Projects Found'**
  String get no_projects_found;

  /// No description provided for @no_assigned_projects_yet.
  ///
  /// In en, this message translates to:
  /// **'You have not been assigned any projects yet.'**
  String get no_assigned_projects_yet;

  /// No description provided for @pdf_file.
  ///
  /// In en, this message translates to:
  /// **'PDF File'**
  String get pdf_file;

  /// No description provided for @type_message.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get type_message;

  /// No description provided for @deadline_from.
  ///
  /// In en, this message translates to:
  /// **'Deadline From'**
  String get deadline_from;

  /// No description provided for @deadline_to.
  ///
  /// In en, this message translates to:
  /// **'Deadline To'**
  String get deadline_to;

  /// No description provided for @job_category.
  ///
  /// In en, this message translates to:
  /// **'Job Category'**
  String get job_category;

  /// No description provided for @experience_level.
  ///
  /// In en, this message translates to:
  /// **'Experience Level'**
  String get experience_level;

  /// No description provided for @service_type.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get service_type;

  /// No description provided for @under_review.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get under_review;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @filled.
  ///
  /// In en, this message translates to:
  /// **'Filled'**
  String get filled;

  /// No description provided for @planning.
  ///
  /// In en, this message translates to:
  /// **'Planning'**
  String get planning;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @submitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submitted;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @from_date.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get from_date;

  /// No description provided for @to_date.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get to_date;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @invoice_id.
  ///
  /// In en, this message translates to:
  /// **'Invoice ID'**
  String get invoice_id;

  /// No description provided for @payment_status.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get payment_status;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @hourly_rate.
  ///
  /// In en, this message translates to:
  /// **'Hourly Rate'**
  String get hourly_rate;

  /// No description provided for @portfolio_link_1.
  ///
  /// In en, this message translates to:
  /// **'Portfolio Link (1)'**
  String get portfolio_link_1;

  /// No description provided for @portfolio_link_2.
  ///
  /// In en, this message translates to:
  /// **'Portfolio Link (2)'**
  String get portfolio_link_2;

  /// No description provided for @your_cv.
  ///
  /// In en, this message translates to:
  /// **'Your CV'**
  String get your_cv;

  /// No description provided for @owner_name.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get owner_name;

  /// No description provided for @business_name.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get business_name;

  /// No description provided for @business_email.
  ///
  /// In en, this message translates to:
  /// **'Business Email Address'**
  String get business_email;

  /// No description provided for @tax_id.
  ///
  /// In en, this message translates to:
  /// **'Tax ID'**
  String get tax_id;

  /// No description provided for @jobs_marketplace.
  ///
  /// In en, this message translates to:
  /// **'Jobs Marketplace'**
  String get jobs_marketplace;

  /// No description provided for @failed_to_load_jobs.
  ///
  /// In en, this message translates to:
  /// **'Failed to Load Jobs'**
  String get failed_to_load_jobs;

  /// No description provided for @failed_to_load_job_details.
  ///
  /// In en, this message translates to:
  /// **'Failed to Load Job Details'**
  String get failed_to_load_job_details;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @failed_to_load_idea.
  ///
  /// In en, this message translates to:
  /// **'Failed to load idea'**
  String get failed_to_load_idea;

  /// No description provided for @write_your_comment_here.
  ///
  /// In en, this message translates to:
  /// **'Write Your Comment Here...'**
  String get write_your_comment_here;

  /// No description provided for @service_request_submitted_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your service request has been submitted successfully.'**
  String get service_request_submitted_subtitle;

  /// No description provided for @edit_request.
  ///
  /// In en, this message translates to:
  /// **'Edit Request'**
  String get edit_request;

  /// No description provided for @current_files.
  ///
  /// In en, this message translates to:
  /// **'Current Files'**
  String get current_files;

  /// No description provided for @service_requests.
  ///
  /// In en, this message translates to:
  /// **'Service Requests'**
  String get service_requests;

  /// No description provided for @consultants.
  ///
  /// In en, this message translates to:
  /// **'Consultants'**
  String get consultants;

  /// No description provided for @pricing_type.
  ///
  /// In en, this message translates to:
  /// **'Pricing Type'**
  String get pricing_type;

  /// No description provided for @project_id.
  ///
  /// In en, this message translates to:
  /// **'Project ID'**
  String get project_id;

  /// No description provided for @enroll_now.
  ///
  /// In en, this message translates to:
  /// **'Enroll Now'**
  String get enroll_now;

  /// No description provided for @hr.
  ///
  /// In en, this message translates to:
  /// **'Hr'**
  String get hr;

  /// No description provided for @watched.
  ///
  /// In en, this message translates to:
  /// **'Watched'**
  String get watched;

  /// No description provided for @start_watching.
  ///
  /// In en, this message translates to:
  /// **'Start Watching'**
  String get start_watching;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @download_resources.
  ///
  /// In en, this message translates to:
  /// **'Download Resources'**
  String get download_resources;

  /// No description provided for @no_video_available.
  ///
  /// In en, this message translates to:
  /// **'No video available'**
  String get no_video_available;

  /// No description provided for @mark_as_complete.
  ///
  /// In en, this message translates to:
  /// **'Mark as Complete'**
  String get mark_as_complete;

  /// No description provided for @lesson_marked_completed.
  ///
  /// In en, this message translates to:
  /// **'Lesson marked as completed.'**
  String get lesson_marked_completed;

  /// No description provided for @payment_successful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get payment_successful;

  /// No description provided for @payment_success_subtitle.
  ///
  /// In en, this message translates to:
  /// **'You have been enrolled in the course successfully.'**
  String get payment_success_subtitle;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @maintenance_title.
  ///
  /// In en, this message translates to:
  /// **'We\'ll be back soon'**
  String get maintenance_title;

  /// No description provided for @maintenance_message.
  ///
  /// In en, this message translates to:
  /// **'The service is temporarily unavailable while we perform some maintenance. Please try again in a moment.'**
  String get maintenance_message;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get try_again;

  /// No description provided for @request_to_join_project.
  ///
  /// In en, this message translates to:
  /// **'Request to Join Project'**
  String get request_to_join_project;

  /// No description provided for @expertise.
  ///
  /// In en, this message translates to:
  /// **'Expertise'**
  String get expertise;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @failed_to_load_project_details.
  ///
  /// In en, this message translates to:
  /// **'Failed to load project details'**
  String get failed_to_load_project_details;

  /// No description provided for @milestones_tasks.
  ///
  /// In en, this message translates to:
  /// **'Milestones & Tasks'**
  String get milestones_tasks;

  /// No description provided for @project_files.
  ///
  /// In en, this message translates to:
  /// **'Project Files'**
  String get project_files;

  /// No description provided for @project_team.
  ///
  /// In en, this message translates to:
  /// **'Project Team'**
  String get project_team;

  /// No description provided for @desired_outcome.
  ///
  /// In en, this message translates to:
  /// **'Desired Outcome'**
  String get desired_outcome;

  /// No description provided for @reason_for_boost.
  ///
  /// In en, this message translates to:
  /// **'Reason for Boost'**
  String get reason_for_boost;

  /// No description provided for @updated_description.
  ///
  /// In en, this message translates to:
  /// **'Updated Description'**
  String get updated_description;

  /// No description provided for @date_submitted.
  ///
  /// In en, this message translates to:
  /// **'Date Submitted'**
  String get date_submitted;

  /// No description provided for @request.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get request;

  /// No description provided for @consultant_request_submitted.
  ///
  /// In en, this message translates to:
  /// **'Your consultant request has been submitted successfully.'**
  String get consultant_request_submitted;

  /// No description provided for @project_service_title.
  ///
  /// In en, this message translates to:
  /// **'Project/Service Title'**
  String get project_service_title;

  /// No description provided for @service_type_fixed_hourly.
  ///
  /// In en, this message translates to:
  /// **'Service Type (Fixed/Hourly)'**
  String get service_type_fixed_hourly;

  /// No description provided for @fixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get fixed;

  /// No description provided for @hourly.
  ///
  /// In en, this message translates to:
  /// **'Hourly'**
  String get hourly;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @rate_hr.
  ///
  /// In en, this message translates to:
  /// **'Rate/hr'**
  String get rate_hr;

  /// No description provided for @skills_expertise.
  ///
  /// In en, this message translates to:
  /// **'Skills & Expertise'**
  String get skills_expertise;

  /// No description provided for @experience_timeline.
  ///
  /// In en, this message translates to:
  /// **'Experience Timeline'**
  String get experience_timeline;

  /// No description provided for @certifications.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get certifications;

  /// No description provided for @rate_services.
  ///
  /// In en, this message translates to:
  /// **'Rate & Services'**
  String get rate_services;

  /// No description provided for @project_rate.
  ///
  /// In en, this message translates to:
  /// **'Project Rate'**
  String get project_rate;

  /// No description provided for @payment_terms.
  ///
  /// In en, this message translates to:
  /// **'Payment Terms'**
  String get payment_terms;

  /// No description provided for @cv_downloaded_successfully.
  ///
  /// In en, this message translates to:
  /// **'CV downloaded successfully'**
  String get cv_downloaded_successfully;

  /// No description provided for @requested_consultants.
  ///
  /// In en, this message translates to:
  /// **'Requested Consultants'**
  String get requested_consultants;

  /// No description provided for @reports_invoices.
  ///
  /// In en, this message translates to:
  /// **'Reports & Invoices'**
  String get reports_invoices;

  /// No description provided for @cancel_request_confirm_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this service request? This action cannot be undone.'**
  String get cancel_request_confirm_subtitle;

  /// No description provided for @preferred_deadline.
  ///
  /// In en, this message translates to:
  /// **'Preferred Deadline'**
  String get preferred_deadline;

  /// No description provided for @proposed_budget.
  ///
  /// In en, this message translates to:
  /// **'Proposed Budget'**
  String get proposed_budget;

  /// No description provided for @request_files.
  ///
  /// In en, this message translates to:
  /// **'Request Files'**
  String get request_files;

  /// No description provided for @approve_mark_completed.
  ///
  /// In en, this message translates to:
  /// **'Approve & Mark Completed'**
  String get approve_mark_completed;

  /// No description provided for @request_another_service.
  ///
  /// In en, this message translates to:
  /// **'Request Another Service'**
  String get request_another_service;

  /// No description provided for @cancelling.
  ///
  /// In en, this message translates to:
  /// **'Cancelling...'**
  String get cancelling;

  /// No description provided for @request_updated.
  ///
  /// In en, this message translates to:
  /// **'Request Updated'**
  String get request_updated;

  /// No description provided for @service_request_updated_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your service request has been updated successfully.'**
  String get service_request_updated_subtitle;

  /// No description provided for @idea_submitted.
  ///
  /// In en, this message translates to:
  /// **'Idea Submitted'**
  String get idea_submitted;

  /// No description provided for @idea_submitted_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your idea has been submitted successfully. We will review it shortly.'**
  String get idea_submitted_subtitle;

  /// No description provided for @project_submitted.
  ///
  /// In en, this message translates to:
  /// **'Project Submitted'**
  String get project_submitted;

  /// No description provided for @boost_request_submitted.
  ///
  /// In en, this message translates to:
  /// **'Your boost project request has been submitted successfully. We will review it shortly.'**
  String get boost_request_submitted;

  /// No description provided for @goals_deliverables.
  ///
  /// In en, this message translates to:
  /// **'Goals & Deliverables'**
  String get goals_deliverables;

  /// No description provided for @no_file_available.
  ///
  /// In en, this message translates to:
  /// **'No file available'**
  String get no_file_available;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// No description provided for @file_downloaded_successfully.
  ///
  /// In en, this message translates to:
  /// **'File downloaded successfully'**
  String get file_downloaded_successfully;

  /// No description provided for @download_failed.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get download_failed;

  /// No description provided for @no_results_for.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\".'**
  String no_results_for(String query);

  /// No description provided for @no_available_jobs.
  ///
  /// In en, this message translates to:
  /// **'There are no available jobs at the moment.'**
  String get no_available_jobs;

  /// No description provided for @no_jobs_found.
  ///
  /// In en, this message translates to:
  /// **'No Jobs Found'**
  String get no_jobs_found;

  /// No description provided for @all_jobs_loaded.
  ///
  /// In en, this message translates to:
  /// **'All {total} jobs loaded'**
  String all_jobs_loaded(int total);

  /// No description provided for @all_projects_loaded.
  ///
  /// In en, this message translates to:
  /// **'All {total} projects loaded'**
  String all_projects_loaded(int total);

  /// No description provided for @failed_to_load_projects.
  ///
  /// In en, this message translates to:
  /// **'Failed to load projects'**
  String get failed_to_load_projects;

  /// No description provided for @hb_lab.
  ///
  /// In en, this message translates to:
  /// **'HB Lab'**
  String get hb_lab;

  /// No description provided for @hb_lab_projects_tab.
  ///
  /// In en, this message translates to:
  /// **'HB Lab Projects'**
  String get hb_lab_projects_tab;

  /// No description provided for @ideas_box.
  ///
  /// In en, this message translates to:
  /// **'Ideas Box'**
  String get ideas_box;

  /// No description provided for @boost_your_project.
  ///
  /// In en, this message translates to:
  /// **'Boost Your Project'**
  String get boost_your_project;

  /// No description provided for @submit_a_new_idea.
  ///
  /// In en, this message translates to:
  /// **'Submit a New Idea'**
  String get submit_a_new_idea;

  /// No description provided for @upvote.
  ///
  /// In en, this message translates to:
  /// **'Upvote'**
  String get upvote;

  /// No description provided for @upvoted.
  ///
  /// In en, this message translates to:
  /// **'Upvoted'**
  String get upvoted;

  /// No description provided for @add_your_comment.
  ///
  /// In en, this message translates to:
  /// **'Add your Comment'**
  String get add_your_comment;

  /// No description provided for @idea_title.
  ///
  /// In en, this message translates to:
  /// **'Idea Title'**
  String get idea_title;

  /// No description provided for @idea_description.
  ///
  /// In en, this message translates to:
  /// **'Idea Description'**
  String get idea_description;

  /// No description provided for @confidentiality_level.
  ///
  /// In en, this message translates to:
  /// **'Confidentiality Level'**
  String get confidentiality_level;

  /// No description provided for @select_confidentiality.
  ///
  /// In en, this message translates to:
  /// **'Select Confidentiality Level'**
  String get select_confidentiality;

  /// No description provided for @select_tags.
  ///
  /// In en, this message translates to:
  /// **'Select Tags'**
  String get select_tags;

  /// No description provided for @tags_label.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags_label;

  /// No description provided for @attachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get attachment;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @submitted_on.
  ///
  /// In en, this message translates to:
  /// **'Submitted On'**
  String get submitted_on;

  /// No description provided for @votes.
  ///
  /// In en, this message translates to:
  /// **'Votes'**
  String get votes;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @no_comments_yet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get no_comments_yet;

  /// No description provided for @no_ideas_yet.
  ///
  /// In en, this message translates to:
  /// **'No ideas submitted yet'**
  String get no_ideas_yet;

  /// No description provided for @no_hb_lab_projects.
  ///
  /// In en, this message translates to:
  /// **'No HB Lab projects available at the moment'**
  String get no_hb_lab_projects;

  /// No description provided for @reevaluate_project.
  ///
  /// In en, this message translates to:
  /// **'Reevaluate Project'**
  String get reevaluate_project;

  /// No description provided for @career_opportunities.
  ///
  /// In en, this message translates to:
  /// **'Career Opportunities'**
  String get career_opportunities;

  /// No description provided for @my_applications.
  ///
  /// In en, this message translates to:
  /// **'My Applications'**
  String get my_applications;

  /// No description provided for @job_applications.
  ///
  /// In en, this message translates to:
  /// **'Job Applications'**
  String get job_applications;

  /// No description provided for @no_career_opportunities.
  ///
  /// In en, this message translates to:
  /// **'No Career Opportunities'**
  String get no_career_opportunities;

  /// No description provided for @no_career_opportunities_subtitle.
  ///
  /// In en, this message translates to:
  /// **'There are no available career opportunities at the moment.'**
  String get no_career_opportunities_subtitle;

  /// No description provided for @my_courses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get my_courses;

  /// No description provided for @course_details.
  ///
  /// In en, this message translates to:
  /// **'Course Details'**
  String get course_details;

  /// No description provided for @trainer.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get trainer;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @lessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessons;

  /// No description provided for @lessons_count.
  ///
  /// In en, this message translates to:
  /// **'{count} lessons'**
  String lessons_count(int count);

  /// No description provided for @hours_count.
  ///
  /// In en, this message translates to:
  /// **'{count}h'**
  String hours_count(int count);

  /// No description provided for @enrolled_count.
  ///
  /// In en, this message translates to:
  /// **'{count} enrolled'**
  String enrolled_count(int count);

  /// No description provided for @resources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resources;

  /// No description provided for @certificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get certificate;

  /// No description provided for @buy_now.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buy_now;

  /// No description provided for @start_learning.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get start_learning;

  /// No description provided for @course_overview.
  ///
  /// In en, this message translates to:
  /// **'Course Overview'**
  String get course_overview;

  /// No description provided for @certificates.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get certificates;

  /// No description provided for @download_pdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get download_pdf;

  /// No description provided for @trainer_profile.
  ///
  /// In en, this message translates to:
  /// **'Trainer Profile'**
  String get trainer_profile;

  /// No description provided for @enrollment_and_payment.
  ///
  /// In en, this message translates to:
  /// **'Enrollment & Payment'**
  String get enrollment_and_payment;

  /// No description provided for @no_courses_available.
  ///
  /// In en, this message translates to:
  /// **'No courses available'**
  String get no_courses_available;

  /// No description provided for @no_courses_subtitle.
  ///
  /// In en, this message translates to:
  /// **'There are no courses available at the moment.'**
  String get no_courses_subtitle;

  /// No description provided for @all_courses.
  ///
  /// In en, this message translates to:
  /// **'All Courses'**
  String get all_courses;

  /// No description provided for @purchased_courses.
  ///
  /// In en, this message translates to:
  /// **'Purchased Courses'**
  String get purchased_courses;

  /// No description provided for @mark_all_read.
  ///
  /// In en, this message translates to:
  /// **'Mark All as Read'**
  String get mark_all_read;

  /// No description provided for @no_notifications_yet.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get no_notifications_yet;

  /// No description provided for @no_notifications_subtitle.
  ///
  /// In en, this message translates to:
  /// **'You have no notifications at this time.'**
  String get no_notifications_subtitle;

  /// No description provided for @no_chats.
  ///
  /// In en, this message translates to:
  /// **'No Chats'**
  String get no_chats;

  /// No description provided for @no_chats_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation to see it here.'**
  String get no_chats_subtitle;

  /// No description provided for @consultants_directory.
  ///
  /// In en, this message translates to:
  /// **'Consultants Directory'**
  String get consultants_directory;

  /// No description provided for @request_consultant.
  ///
  /// In en, this message translates to:
  /// **'Request a Consultant'**
  String get request_consultant;

  /// No description provided for @jobs_projects.
  ///
  /// In en, this message translates to:
  /// **'Jobs & Projects'**
  String get jobs_projects;

  /// No description provided for @responsibilities.
  ///
  /// In en, this message translates to:
  /// **'Responsibilities'**
  String get responsibilities;

  /// No description provided for @requirements.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get requirements;

  /// No description provided for @benefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get benefits;

  /// No description provided for @job_details_label.
  ///
  /// In en, this message translates to:
  /// **'Job Details'**
  String get job_details_label;

  /// No description provided for @application_details.
  ///
  /// In en, this message translates to:
  /// **'Application Details'**
  String get application_details;

  /// No description provided for @request_details.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get request_details;

  /// No description provided for @service_request.
  ///
  /// In en, this message translates to:
  /// **'Service Request'**
  String get service_request;

  /// No description provided for @new_service_request.
  ///
  /// In en, this message translates to:
  /// **'New Service Request'**
  String get new_service_request;

  /// No description provided for @select_date.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get select_date;

  /// No description provided for @select_time.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get select_time;

  /// No description provided for @meeting_request.
  ///
  /// In en, this message translates to:
  /// **'Meeting Request'**
  String get meeting_request;

  /// No description provided for @new_meeting_request.
  ///
  /// In en, this message translates to:
  /// **'New Meeting Request'**
  String get new_meeting_request;

  /// No description provided for @boost_project.
  ///
  /// In en, this message translates to:
  /// **'Boost Project'**
  String get boost_project;

  /// No description provided for @project_name.
  ///
  /// In en, this message translates to:
  /// **'Project Name'**
  String get project_name;

  /// No description provided for @project_link.
  ///
  /// In en, this message translates to:
  /// **'Project Link'**
  String get project_link;

  /// No description provided for @submit_comment.
  ///
  /// In en, this message translates to:
  /// **'Submit Comment'**
  String get submit_comment;

  /// No description provided for @write_comment.
  ///
  /// In en, this message translates to:
  /// **'Write your comment...'**
  String get write_comment;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @school_university.
  ///
  /// In en, this message translates to:
  /// **'School / University'**
  String get school_university;

  /// No description provided for @jobs_and_internships.
  ///
  /// In en, this message translates to:
  /// **'Jobs & Internships'**
  String get jobs_and_internships;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @type_label.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type_label;

  /// No description provided for @stipend_pay.
  ///
  /// In en, this message translates to:
  /// **'Stipend/Pay'**
  String get stipend_pay;

  /// No description provided for @company_location.
  ///
  /// In en, this message translates to:
  /// **'Company Location'**
  String get company_location;

  /// No description provided for @job_location.
  ///
  /// In en, this message translates to:
  /// **'Job Location'**
  String get job_location;

  /// No description provided for @already_applied.
  ///
  /// In en, this message translates to:
  /// **'Already Applied'**
  String get already_applied;

  /// No description provided for @download_file.
  ///
  /// In en, this message translates to:
  /// **'Download File'**
  String get download_file;

  /// No description provided for @name_label.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name_label;

  /// No description provided for @completed_courses.
  ///
  /// In en, this message translates to:
  /// **'Completed Course(s)'**
  String get completed_courses;

  /// No description provided for @supporting_documents_cv.
  ///
  /// In en, this message translates to:
  /// **'Supporting Documents (CV)'**
  String get supporting_documents_cv;

  /// No description provided for @cover_letter_proposal.
  ///
  /// In en, this message translates to:
  /// **'Cover Letter / Proposal'**
  String get cover_letter_proposal;

  /// No description provided for @confirm_info_accurate.
  ///
  /// In en, this message translates to:
  /// **'I confirm that all information is accurate.'**
  String get confirm_info_accurate;

  /// No description provided for @allow_admin_review.
  ///
  /// In en, this message translates to:
  /// **'Allow HB Consulting Admin to review my proposal before submission.'**
  String get allow_admin_review;

  /// No description provided for @application_date.
  ///
  /// In en, this message translates to:
  /// **'Application Date'**
  String get application_date;

  /// No description provided for @date_applied.
  ///
  /// In en, this message translates to:
  /// **'Date Applied'**
  String get date_applied;

  /// No description provided for @application_submitted_title.
  ///
  /// In en, this message translates to:
  /// **'Application Submitted'**
  String get application_submitted_title;

  /// No description provided for @application_submitted_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your application has been submitted successfully.'**
  String get application_submitted_subtitle;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @job_posted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Job Posted Successfully'**
  String get job_posted_successfully;

  /// No description provided for @job_request_submitted.
  ///
  /// In en, this message translates to:
  /// **'Your job request has been submitted.'**
  String get job_request_submitted;

  /// No description provided for @deadline_must_be_future.
  ///
  /// In en, this message translates to:
  /// **'The deadline can\'t be in the past.'**
  String get deadline_must_be_future;

  /// No description provided for @deadline_after_start_date.
  ///
  /// In en, this message translates to:
  /// **'The deadline must be a date after the start date.'**
  String get deadline_after_start_date;

  /// No description provided for @no_messages_yet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get no_messages_yet;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @learning_outcomes_title.
  ///
  /// In en, this message translates to:
  /// **'Learning Outcomes:'**
  String get learning_outcomes_title;

  /// No description provided for @after_course_able.
  ///
  /// In en, this message translates to:
  /// **'After this course, you will be able to:'**
  String get after_course_able;

  /// No description provided for @key_stats.
  ///
  /// In en, this message translates to:
  /// **'Key Stats'**
  String get key_stats;

  /// No description provided for @hrs.
  ///
  /// In en, this message translates to:
  /// **'hrs'**
  String get hrs;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @format.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get format;

  /// No description provided for @certificate_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes, upon completion'**
  String get certificate_yes;

  /// No description provided for @no_word.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no_word;

  /// No description provided for @curriculum.
  ///
  /// In en, this message translates to:
  /// **'Curriculum'**
  String get curriculum;

  /// No description provided for @whats_included.
  ///
  /// In en, this message translates to:
  /// **'What’s Included'**
  String get whats_included;

  /// No description provided for @guarantee_trust.
  ///
  /// In en, this message translates to:
  /// **'Guarantee / Trust Elements'**
  String get guarantee_trust;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @about_trainer_bio.
  ///
  /// In en, this message translates to:
  /// **'About the Trainer (Bio)'**
  String get about_trainer_bio;

  /// No description provided for @industry_experience.
  ///
  /// In en, this message translates to:
  /// **'Industry Experience:'**
  String get industry_experience;

  /// No description provided for @certifications_label.
  ///
  /// In en, this message translates to:
  /// **'Certifications:'**
  String get certifications_label;

  /// No description provided for @no_trainer_info.
  ///
  /// In en, this message translates to:
  /// **'No trainer information available.'**
  String get no_trainer_info;

  /// No description provided for @reviews_count.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String reviews_count(int count);

  /// No description provided for @continue_course.
  ///
  /// In en, this message translates to:
  /// **'Continue Course'**
  String get continue_course;

  /// No description provided for @download_certificates.
  ///
  /// In en, this message translates to:
  /// **'Download Certificates'**
  String get download_certificates;

  /// No description provided for @status_in_progress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get status_in_progress;

  /// No description provided for @status_not_started.
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get status_not_started;

  /// No description provided for @status_complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get status_complete;

  /// No description provided for @percent_complete.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Complete'**
  String percent_complete(String percent);

  /// No description provided for @minutes_short.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes_short;

  /// No description provided for @no_resources.
  ///
  /// In en, this message translates to:
  /// **'No resources available.'**
  String get no_resources;

  /// No description provided for @video_lessons_hrs.
  ///
  /// In en, this message translates to:
  /// **'{h} hrs of video lessons'**
  String video_lessons_hrs(int h);

  /// No description provided for @certificate_of_completion.
  ///
  /// In en, this message translates to:
  /// **'Certificate of completion'**
  String get certificate_of_completion;

  /// No description provided for @lifetime_access.
  ///
  /// In en, this message translates to:
  /// **'Lifetime access to course updates'**
  String get lifetime_access;

  /// No description provided for @secure_payment.
  ///
  /// In en, this message translates to:
  /// **'Secure Payment (SSL Encrypted)'**
  String get secure_payment;

  /// No description provided for @refund_policy.
  ///
  /// In en, this message translates to:
  /// **'7-day refund policy (no questions asked)'**
  String get refund_policy;

  /// No description provided for @accredited_certificate.
  ///
  /// In en, this message translates to:
  /// **'Accredited Certificate issued by HB Consulting'**
  String get accredited_certificate;

  /// No description provided for @availability_start_date.
  ///
  /// In en, this message translates to:
  /// **'Availability Start Date'**
  String get availability_start_date;

  /// No description provided for @application_submitted.
  ///
  /// In en, this message translates to:
  /// **'Application Submitted'**
  String get application_submitted;

  /// No description provided for @proposed_rate_total.
  ///
  /// In en, this message translates to:
  /// **'Proposed Rate (total)'**
  String get proposed_rate_total;

  /// No description provided for @estimated_duration_weeks.
  ///
  /// In en, this message translates to:
  /// **'Estimated Duration (Weeks)'**
  String get estimated_duration_weeks;

  /// No description provided for @supporting_documents.
  ///
  /// In en, this message translates to:
  /// **'Supporting Documents'**
  String get supporting_documents;

  /// No description provided for @cover_letter.
  ///
  /// In en, this message translates to:
  /// **'Cover letter'**
  String get cover_letter;

  /// No description provided for @cover_letter_hint.
  ///
  /// In en, this message translates to:
  /// **'Cover Letter / Proposal\n\nDescribe your experience, why you\'re a great fit, and what you bring to this project...'**
  String get cover_letter_hint;

  /// No description provided for @course_discovery.
  ///
  /// In en, this message translates to:
  /// **'Course Discovery'**
  String get course_discovery;

  /// No description provided for @payments_invoices.
  ///
  /// In en, this message translates to:
  /// **'Payments & Invoices'**
  String get payments_invoices;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
