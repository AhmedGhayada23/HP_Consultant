import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/local_storage.dart';
import 'package:hb/core/cubit/assign_consultant_cubit/assign_consultant_cubit.dart';
import 'package:hb/core/cubit/assign_consultant_cubit/assign_consultant_state.dart';
import 'package:hb/core/cubit/details_project_cubit/details_project_cubit.dart';
import 'package:hb/core/cubit/add_comment_cubit/add_comment_cubit.dart';
import 'package:hb/core/cubit/add_comment_cubit/add_comment_state.dart';
import 'package:hb/core/cubit/details_ideas_box_cubit/details_ideas_box_cubit.dart';
import 'package:hb/core/cubit/hb_lab_join_cubit/hb_lab_join_cubit.dart';
import 'package:hb/core/cubit/hb_lab_join_cubit/hb_lab_join_state.dart';
import 'package:hb/core/cubit/auth_otp_cubit/auth_otp_cubit.dart';
import 'package:hb/core/cubit/auth_otp_cubit/auth_otp_state.dart';
import 'package:hb/core/cubit/auth_sigin_cubit/auth_sigin_cubit.dart';
import 'package:hb/core/cubit/consultant_project_cubit/consultant_project_cubit.dart';
import 'package:hb/core/cubit/consultant_project_cubit/consultant_project_state.dart';
import 'package:hb/core/cubit/locale_cubit/locale_cubit.dart';
import 'package:hb/core/cubit/schedule_interview_cubit/schedule_interview_cubit.dart';
import 'package:hb/core/cubit/milestone_cubit/milestone_cubit.dart';
import 'package:hb/core/cubit/milestone_cubit/milestone_state.dart';
import 'package:hb/core/cubit/upload_file_cubit/upload_file_cubit.dart';
import 'package:hb/core/cubit/upload_file_cubit/upload_file_state.dart';
import 'package:hb/core/data/models/active_project_model.dart';
import 'package:hb/core/data/models/assign_consultant_model.dart';
import 'package:hb/core/data/models/consultant_project_model.dart';
import 'package:hb/core/data/models/details_job_project_model.dart';
import 'package:hb/core/data/models/details_project_model.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/Schedule_meeting_form_widget.dart';
import 'package:hb/core/widgets/change_language_widget.dart';
import 'package:hb/core/widgets/circle_icon.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/delete_account_widget.dart';
import 'package:hb/core/widgets/file_picker_field.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/core/widgets/sign_up_as_widget.dart';
import 'package:hb/featuer/auth_signup/widgets/custom_checkbox_text_row.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';
import 'package:vector_graphics/vector_graphics.dart';

final GlobalKey<FormState> _forgetPasswordFormKey = GlobalKey<FormState>();

// بوب-أب يظهر عند تغيير اللغة: شعار التطبيق داخل دائرة تحميل + نص "جاري التجهيز"
Future<void> showLanguageSwitchLoader(BuildContext context,
    {required String message}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: false,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => PopScope(
      canPop: false,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الشعار داخل حلقة التحميل
            SizedBox(
              width: 110.r,
              height: 110.r,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 110.r,
                    height: 110.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.5,
                      color: AppColor.k1primeryColor,
                      backgroundColor: AppColor.whiteColor.withValues(alpha: 0.25),
                    ),
                  ),
                  Container(
                    width: 78.r,
                    height: 78.r,
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Image.asset(AppImage.logoImage, fit: BoxFit.contain),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              message,
              style: MyTextStyle()
                  .textStyleSemiBold16()
                  .copyWith(color: AppColor.whiteColor),
            ),
          ],
        ),
        ),
      ),
    ),
  );
}

void showLogOutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColor.whiteColor,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _forgetPasswordFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)!.log_out, style: MyTextStyle().textStyleSemiBold16()),
              DashedLine(),
              SizedBox(height: 20.h),
              Text(
               AppLocalizations.of(context)!.log_out_confirmation,
                style: MyTextStyle().textStyleRegular14(),
              ),

              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        LocalStorage().removeKey(Constants.token);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          MyRoutes().authSiginIn,
                          (route) => true,
                        );
                      },
                      color: AppColor.k1primeryColor,
                      text: AppLocalizations.of(context)!.log_out,
                      textColor: AppColor.whiteColor,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomButtonBorder(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      borderColor: AppColor.k1primeryColor,
                      text: AppLocalizations.of(context)!.cancel,
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// نافذة تأكيد عامة (مثلاً: تأكيد إلغاء طلب الخدمة)
void showConfirmDialog(
  BuildContext context, {
  required String title,
  required String subTitle,
  required String confirmText,
  required VoidCallback onConfirm,
  Color confirmColor = const Color(0xffD32F2F),
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColor.whiteColor,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext sheetContext) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: MyTextStyle().textStyleSemiBold16()),
            DashedLine(),
            SizedBox(height: 20.h),
            Text(subTitle, style: MyTextStyle().textStyleRegular14()),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      Navigator.pop(sheetContext);
                      onConfirm();
                    },
                    color: confirmColor,
                    text: confirmText,
                    textColor: AppColor.whiteColor,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomButtonBorder(
                    onTap: () => Navigator.pop(sheetContext),
                    borderColor: AppColor.k1primeryColor,
                    text: AppLocalizations.of(sheetContext)!.cancel,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ],
        ),
      );
    },
  );
}

void showRequestSubmittedDialog(BuildContext context, {VoidCallback? onDone,required String title,required String subTitle, required String textBtn}) {
  showModalBottomSheet(
    context: context,
    isDismissible: false, // ✅ ما تنغلق بالضغط برا
    enableDrag: false, // ✅ ما تنغلق بالسحب لتحت
    backgroundColor: AppColor.whiteColor,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: MyTextStyle().textStyleSemiBold16()),
            Text(
              subTitle,
              style: MyTextStyle().textStyleRegular14(),
            ),
            DashedLine(),
            SizedBox(height: 20.h),
            Center(child: VectorGraphic(loader: AssetBytesLoader(AppSvg.successSvg))),
            SizedBox(height: 20.h),
            CustomButton(
              onTap: () {
                Navigator.pop(context); // ✅ تغلق الـ bottom sheet
                onDone?.call(); // ✅ تروح للصفحة
              },
              color: AppColor.k1primeryColor,
              text: textBtn,
              textColor: AppColor.whiteColor,
            ),
          ],
        ),
      );
    },
  );
}

void showForgetPasswordPopUp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColor.whiteColor,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const _ForgetPasswordSheet(),
  );
}

// محتوى الـ sheet كـ StatefulWidget مستقل: مفتاح + controller خاصّان
// (لتجنّب اختفاء الـ sheet عند ظهور الكيبورد بسبب مفتاح/controller مشترك)
class _ForgetPasswordSheet extends StatefulWidget {
  const _ForgetPasswordSheet();

  @override
  State<_ForgetPasswordSheet> createState() => _ForgetPasswordSheetState();
}

class _ForgetPasswordSheetState extends State<_ForgetPasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.forgot_password, style: MyTextStyle().textStyleSemiBold16()),
              DashedLine(),
              SizedBox(height: 20.h),
              Text(
                l.forgot_password_desc,
                style: MyTextStyle().textStyleRegular14(),
              ),
              SizedBox(height: 20.h),
              MyTextFieldWidget(
                validator: (value) => Validators.email(value, context),
                hintText: l.email_address,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 24.h),
              BlocBuilder<AuthOtpCubit, AuthOtpState>(
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: state.isSentOtpLoading == true
                        ? SizedBox(
                            key: const ValueKey('loader'),
                            width: double.infinity,
                            height: 64.h,
                            child: Center(
                              child: CircleAvatar(
                                radius: 32.r,
                                backgroundColor: AppColor.k1primeryColor,
                                child: CircularProgressIndicator(
                                  color: AppColor.whiteColor,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            key: const ValueKey('submit_button'),
                            width: double.infinity,
                            height: 64.h,
                            child: CustomButton(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  final email = _emailController.text.trim();
                                  // مزامنة الإيميل مع الـ cubit للخطوات اللاحقة
                                  context
                                      .read<AuthSiginCubit>()
                                      .emailController
                                      .text = email;
                                  context.read<AuthOtpCubit>().forgetPasswordSendCode(
                                        context: context,
                                        email: email,
                                      );
                                }
                              },
                              color: AppColor.k1primeryColor,
                              text: l.submit,
                              textColor: AppColor.whiteColor,
                            ),
                          ),
                  );
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

void shSignUpAs(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    barrierColor: Colors.black.withValues(alpha: 0.7), // خلفية الشاشة سوداء
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return SignUpAsWidget();
    },
  );
}

void showDeleteAccountDialog(BuildContext context, VoidCallback onDelete) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColor.whiteColor,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),

    builder: (BuildContext context) {
      return DeleteAccountWidget();
    },
  );
}

void showScheduleMeetingDialog(BuildContext context, {required int applicationId}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColor.whiteColor,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),

    builder: (_) => BlocProvider(
      create: (_) => ScheduleInterviewCubit(),
      child: ScheduleMeetingFormWidget(applicationId: applicationId),
    ),
  );
}

//successfully
void showsuccessfullyDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColor.whiteColor,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),

    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,

          children: [
            Text('Consultant hired successfully', style: MyTextStyle().textStyleSemiBold16()),

            SizedBox(height: 12.h),
            Text(
              'The applicant John Doe has been successfully hired for the position Frontend Developer.',
              style: MyTextStyle().textStyleRegular14(),
            ),
            DashedLine(),
            SizedBox(height: 20.h),
            Center(child: VectorGraphic(loader: AssetBytesLoader(AppSvg.successSvg))),
            SizedBox(height: 20.h),
            CustomButton(
              onTap: () {
                Navigator.pop(context);
              },
              color: AppColor.k1primeryColor,
              text: 'Done',
              textColor: AppColor.whiteColor,
            ),
          ],
        ),
      );
    },
  );
}

void showContact({
  required BuildContext context,
  required ConsultantProjectModel consultantProjectModel,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColor.whiteColor,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),

    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,

          children: [
            Text(
              AppLocalizations.of(context)!.assign_consultant,
              style: MyTextStyle().textStyleSemiBold16(),
            ),
            DashedLine(),
            SizedBox(height: 20.h),
            Text(
              '${AppLocalizations.of(context)!.consultant}:',
              style: MyTextStyle().textStyleSemiBold16(),
            ),

            Text(consultantProjectModel.name, style: MyTextStyle().textStyleRegular16()),
            SizedBox(height: 20.h),
            CustomDropdown(hint: AppLocalizations.of(context)!.project, items: []),
            SizedBox(height: 20.h),
            CustomDropdown(hint: AppLocalizations.of(context)!.milestone, items: []),
            SizedBox(height: 20.h),
            MyTextFieldWidget(hintText: AppLocalizations.of(context)!.notes, maxLines: 4),
            SizedBox(height: 24.h),

            CustomButton(
              onTap: () {
                Navigator.pop(context);
              },
              color: AppColor.k1primeryColor,
              text: AppLocalizations.of(context)!.submit,
              textColor: AppColor.whiteColor,
            ),
          ],
        ),
      );
    },
  );
}

void showAddConsultantDialog(BuildContext context, DetailsProjectModel project) {
  int? consultantId;
  int? milestoneId;

  final TextEditingController roleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColor.whiteColor,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.assign_consultant,
                style: MyTextStyle().textStyleSemiBold16(),
              ),

              DashedLine(),
              SizedBox(height: 20.h),

              Text(
                '${AppLocalizations.of(context)!.project}:',
                style: MyTextStyle().textStyleSemiBold16(),
              ),

              Text(project.project?.title ?? '', style: MyTextStyle().textStyleRegular16()),

              SizedBox(height: 20.h),

              /// consultant dropdown
              BlocBuilder<ConsultantProjectCubit, ConsultantProjectState>(
                builder: (context, state) {
                  return CustomDropdown(
                    hint: AppLocalizations.of(context)!.assign_to,
                    items: state.consultantProjectData?.map((e) => e.name).toList() ?? [],
                    onChanged: (value) {
                      final selected = state.consultantProjectData?.firstWhere(
                        (e) => e.name == value,
                      );
                      consultantId = selected?.id;
                    },
                  );
                },
              ),

              SizedBox(height: 20.h),

              /// milestone dropdown
              BlocBuilder<MilestoneCubit, MilestoneState>(
                builder: (context, state) {
                  final milestones = state.milestone ?? [];
                  return CustomDropdown(
                    hint:
                        '${AppLocalizations.of(context)!.milestone} (${AppLocalizations.of(context)!.optional})',
                    emptyText: AppLocalizations.of(context)!.no_data_available,
                    items: milestones.map((e) => e.title).toList(),
                    onChanged: (value) {
                      final selected = milestones.firstWhere(
                        (e) => e.title == value,
                      );
                      milestoneId = selected.id;
                    },
                  );
                },
              ),

              SizedBox(height: 20.h),

              /// role
              MyTextFieldWidget(controller: roleController, hintText: "Role"),

              SizedBox(height: 20.h),

              /// notes
              MyTextFieldWidget(
                controller: notesController,
                hintText: AppLocalizations.of(context)!.notes,
                maxLines: 4,
              ),

              SizedBox(height: 24.h),

              /// submit button
              BlocBuilder<AssignConsultantCubit, AssignConsultantState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Container(
                      height: 50.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.k1primeryColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: SizedBox(
                        height: 24.h,
                        width: 24.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      ),
                    );
                  }
                  return CustomButton(
                    onTap: () {
                      /// validation
                      if (consultantId == null) {
                        return;
                      }

                      // المرحلة اختيارية — لا تحقق منها

                      if (roleController.text.isEmpty) {
                        return;
                      }

                      /// send request
                      context.read<AssignConsultantCubit>().assignConsultant(
                        project.project!.id,
                        AssignConsultantModel(
                          consultantId: consultantId!,
                          milestoneId: milestoneId, // اختياري
                          role: roleController.text,
                          notes: notesController.text,
                        ),
                        context,
                      );
                    },
                    color: AppColor.k1primeryColor,
                    text: AppLocalizations.of(context)!.submit,
                    textColor: AppColor.whiteColor,
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showAssignDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColor.whiteColor,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),

    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,

          children: [
            Text('Assign Employees', style: MyTextStyle().textStyleSemiBold16()),
            DashedLine(),
            SizedBox(height: 20.h),
            Text('Course Title:', style: MyTextStyle().textStyleSemiBold16()),

            Text('Agile Project Mgmt', style: MyTextStyle().textStyleRegular16()),
            SizedBox(height: 20.h),
            CustomDropdown(hint: 'Employees', items: []),
            SizedBox(height: 24.h),

            CustomButton(
              onTap: () {
                Navigator.pop(context);
              },
              color: AppColor.k1primeryColor,
              text: 'Submit',
              textColor: AppColor.whiteColor,
            ),
          ],
        ),
      );
    },
  );
}

void showUploadDialog(
  BuildContext context, {
  required int projectId,
  required List<MekestonesAndTasks> milestones,
  required String userName,
  VoidCallback? onSuccess,
}) {
  final cubit = context.read<UploadFileCubit>();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColor.whiteColor,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _UploadDeliverablesSheet(
        projectId: projectId,
        milestones: milestones,
        userName: userName,
        onSuccess: onSuccess,
      ),
    ),
  );
}

class _UploadDeliverablesSheet extends StatefulWidget {
  final int projectId;
  final List<MekestonesAndTasks> milestones;
  final String userName;
  final VoidCallback? onSuccess;
  const _UploadDeliverablesSheet({
    required this.projectId,
    required this.milestones,
    required this.userName,
    this.onSuccess,
  });

  @override
  State<_UploadDeliverablesSheet> createState() => _UploadDeliverablesSheetState();
}

class _UploadDeliverablesSheetState extends State<_UploadDeliverablesSheet> {
  @override
  void initState() {
    super.initState();
    // ابدأ من حالة نظيفة في كل مرة يُفتح فيها الـ sheet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UploadFileCubit>().reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UploadFileCubit>();
    final milestones =
        widget.milestones.where((m) => m.id != null).toList();

    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Project Files / Deliverables',
                style: MyTextStyle().textStyleSemiBold16()),
            DashedLine(),
            SizedBox(height: 20.h),

            /// اسم المستخدم الحالي
            Text('Consultant:', style: MyTextStyle().textStyleSemiBold16()),
            SizedBox(height: 4.h),
            Text(widget.userName, style: MyTextStyle().textStyleRegular16()),
            SizedBox(height: 20.h),

            /// Milestone dropdown
            CustomDropdown(
              hint: AppLocalizations.of(context)!.milestone,
              items: milestones.map((e) => e.title ?? '').toList(),
              onChanged: (value) {
                final selected = milestones.firstWhere(
                  (e) => e.title == value,
                  orElse: () => MekestonesAndTasks(),
                );
                cubit.setMilestone(selected.id);
              },
            ),
            SizedBox(height: 20.h),

            /// File picker
            FilePickerField(
              controller: cubit.fileController,
              label: 'Files / Deliverables',
              assetIcon: AppSvg.fileSvg,
              allowedExtensions: const ['pdf', 'doc', 'docx', 'jpg', 'png'],
              onFilePicked: (file) => cubit.setFile(file),
            ),
            SizedBox(height: 24.h),

            /// Mark as completed
            BlocBuilder<UploadFileCubit, UploadFileState>(
              builder: (context, _) => CustomCheckboxTextRow(
                isChecked: cubit.markCompleted,
                onChanged: (value) => cubit.setMarkCompleted(value),
                text: 'Mark as Completed Milestone',
              ),
            ),
            SizedBox(height: 24.h),

            /// Submit
            BlocConsumer<UploadFileCubit, UploadFileState>(
              listener: (context, state) {
                if (state.success == true) {
                  Navigator.pop(context);
                  showCustomSnackBar(
                    context,
                    'Files uploaded successfully',
                    SnackBarType.success,
                  );
                  widget.onSuccess?.call();
                } else if (state.success == false && state.errorMessage != null) {
                  showCustomSnackBar(
                    context,
                    state.errorMessage!,
                    SnackBarType.error,
                  );
                }
              },
              builder: (context, state) {
                return CustomButton(
                  onTap: state.isLoading
                      ? () {}
                      : () {
                          if (cubit.selectedMilestoneId == null) {
                            showCustomSnackBar(context, 'Select a milestone',
                                SnackBarType.warning);
                            return;
                          }
                          if (cubit.pickedFile == null ||
                              cubit.pickedFile!.path == null) {
                            showCustomSnackBar(context, 'Select a file to upload',
                                SnackBarType.warning);
                            return;
                          }
                          cubit.uploadDeliverables(projectId: widget.projectId);
                        },
                  color: AppColor.k1primeryColor,
                  text: state.isLoading
                      ? 'Loading...'
                      : AppLocalizations.of(context)!.submit,
                  textColor: AppColor.whiteColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void showRequestToJoinProjectDialog(BuildContext context,
    {required int projectId, bool consultant = false}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColor.whiteColor,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => BlocProvider(
      create: (_) => HbLabJoinCubit(consultant: consultant),
      child: _JoinProjectSheet(projectId: projectId, parentContext: context),
    ),
  );
}

class _JoinProjectSheet extends StatefulWidget {
  final int projectId;
  final BuildContext parentContext;
  const _JoinProjectSheet({required this.projectId, required this.parentContext});

  @override
  State<_JoinProjectSheet> createState() => _JoinProjectSheetState();
}

class _JoinProjectSheetState extends State<_JoinProjectSheet> {
  final _formKey = GlobalKey<FormState>();
  final _expertiseController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _expertiseController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocListener<HbLabJoinCubit, HbLabJoinState>(
      listenWhen: (prev, curr) => curr.success && !prev.success,
      listener: (context, state) {
        Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(loc.request_to_join_project,
                    style: MyTextStyle().textStyleSemiBold16()),
                DashedLine(),
                SizedBox(height: 20.h),
                MyTextFieldWidget(
                  controller: _expertiseController,
                  hintText: '${loc.expertise} *',
                  validator: (v) => Validators.required(v, context,
                      fieldName: loc.expertise),
                ),
                SizedBox(height: 16.h),
                MyTextFieldWidget(
                  controller: _messageController,
                  hintText: '${loc.message} *',
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  validator: (v) =>
                      Validators.required(v, context, fieldName: loc.message),
                ),
                SizedBox(height: 24.h),
                BlocBuilder<HbLabJoinCubit, HbLabJoinState>(
                  builder: (context, state) {
                    if (state.loading) {
                      return Center(
                        child: CircularProgressIndicator(
                            color: AppColor.k1primeryColor),
                      );
                    }
                    return CustomButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<HbLabJoinCubit>().joinProject(
                                context: widget.parentContext,
                                projectId: widget.projectId,
                                message: _messageController.text.trim(),
                                expertise: _expertiseController.text.trim(),
                              );
                        }
                      },
                      color: AppColor.k1primeryColor,
                      text: loc.submit,
                      textColor: AppColor.whiteColor,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showAddCommentDialog(BuildContext parentContext, {bool consultant = false}) {
  final detailsCubit = parentContext.read<DetailsIdeasBoxCubit>();
  showModalBottomSheet(
    context: parentContext,
    isScrollControlled: true,
    backgroundColor: AppColor.whiteColor,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => BlocProvider(
      create: (_) => AddCommentCubit(consultant: consultant),
      child: _AddCommentSheet(
        detailsCubit: detailsCubit,
      ),
    ),
  );
}

class _AddCommentSheet extends StatefulWidget {
  final DetailsIdeasBoxCubit detailsCubit;
  const _AddCommentSheet({required this.detailsCubit});

  @override
  State<_AddCommentSheet> createState() => _AddCommentSheetState();
}

class _AddCommentSheetState extends State<_AddCommentSheet> {
  final _bodyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocListener<AddCommentCubit, AddCommentState>(
      listenWhen: (prev, curr) => curr.success && !prev.success,
      listener: (_, __) {
        Navigator.of(context).pop();
        widget.detailsCubit.refresh();
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16.w,
          16.h,
          16.w,
          MediaQuery.of(context).viewInsets.bottom + 16.h,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(loc.add_your_comment,
                  style: MyTextStyle().textStyleSemiBold16()),
              DashedLine(),
              SizedBox(height: 20.h),
              MyTextFieldWidget(
                controller: _bodyController,
                hintText: loc.write_your_comment_here,
                maxLines: 6,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? '${loc.this_field} ${loc.is_required}'
                    : null,
              ),
              SizedBox(height: 24.h),
              BlocBuilder<AddCommentCubit, AddCommentState>(
                builder: (context, state) {
                  if (state.loading) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: AppColor.k1primeryColor),
                    );
                  }
                  return CustomButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AddCommentCubit>().addComment(
                              ideaId: widget.detailsCubit.ideaId,
                              body: _bodyController.text.trim(),
                            );
                      }
                    },
                    color: AppColor.k1primeryColor,
                    text: loc.submit,
                    textColor: AppColor.whiteColor,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<dynamic> showPlaceLoginDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: VectorGraphic(loader: AssetBytesLoader(AppSvg.closeSvg)),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              CircleIcon(
                icon: VectorGraphic(
                  loader: AssetBytesLoader(AppSvg.emojeSvg),
                  width: 95.w,
                  height: 95.h,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'It looks like you are using the app as a guest. Please log in to access all features and complete the process successfully.',
                textAlign: TextAlign.center,
                style: MyTextStyle().textStyleMedium15(),
              ),
              SizedBox(height: 24.h),
              CustomButton(
                onTap: () => Navigator.pushReplacementNamed(context, MyRoutes().authSiginIn),
                color: Colors.black,
                text: 'Log In',
                textColor: Colors.white,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      );
    },
  );
}

void showUploadFileDialog(BuildContext context, int projectId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColor.whiteColor,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      final cubit = context.read<UploadFileCubit>();

      return Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.project_files_deliverables,
                style: MyTextStyle().textStyleSemiBold16(),
              ),
              DashedLine(),
              SizedBox(height: 20.h),

              /// File picker
              FilePickerField(
                controller: cubit.fileController,
                label: AppLocalizations.of(context)!.select_file,
                assetIcon: AppSvg.uplodeSvg,
                allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
                onFilePicked: (file) {
                  cubit.setFile(file); // حدث الـ Cubit مباشرة
                },
              ),

              SizedBox(height: 24.h),

              /// Submit button
              BlocConsumer<UploadFileCubit, UploadFileState>(
                listener: (context, state) {
                  if (state.success == true) {
                    // ✅ تفريغ حقل الملف (بدون رجوع)
                    cubit.reset();
                    // ✅ تحديث (refresh) تفاصيل المشروع بعد رفع الملف
                    context.read<DetailsProjectCubit>().fetchDetailsProject(
                      projectId,
                    );
                  } else if (state.success == false && state.errorMessage != null) {}
                },
                builder: (context, state) {
                  return CustomButton(
                    onTap: state.isLoading
                        ? () {}
                        : () {
                            if (cubit.pickedFile == null || cubit.pickedFile!.path == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)!
                                        .select_a_file_to_upload,
                                  ),
                                ),
                              );
                              return;
                            }

                            cubit.uploadFile(context: context, projectId: projectId);
                          },
                    text: state.isLoading
                        ? AppLocalizations.of(context)!.uploading
                        : AppLocalizations.of(context)!.upload,
                    color: AppColor.k1primeryColor,
                    textColor: AppColor.whiteColor,
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showChangeLanguageDialog(BuildContext context) {
    final localeCubit = context.read<LocaleCubit>(); // 👈
   showModalBottomSheet(
    context: context,
    backgroundColor: AppColor.whiteColor,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => BlocProvider.value( // 👈
      value: localeCubit,
      child: ChangeLanguageWidget(),
    ),
  );
}
