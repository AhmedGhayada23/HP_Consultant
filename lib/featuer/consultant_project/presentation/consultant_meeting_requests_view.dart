import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/consultant_meeting_request_cubit/consultant_meeting_request_cubit.dart';
import 'package:hb/core/cubit/consultant_request_cubit/consultant_request_cubit.dart';
import 'package:hb/core/cubit/consultant_request_cubit/consultant_request_state.dart';
import 'package:hb/core/message/message_snack_bar.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/date_picker_field.dart';
import 'package:hb/core/widgets/file_picker_field.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:hb/utils/validators.dart';

class ConsultantMeetingRequestsView extends StatefulWidget {
  const ConsultantMeetingRequestsView({super.key});

  @override
  State<ConsultantMeetingRequestsView> createState() =>
      _ConsultantMeetingRequestsViewState();
}

class _ConsultantMeetingRequestsViewState
    extends State<ConsultantMeetingRequestsView> {
  final _formKey = GlobalKey<FormState>();
  // يُزاد عند النجاح لإعادة بناء النموذج وتصفير الـ dropdowns
  int _formVersion = 0;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ConsultantRequestCubit>();
    return BlocListener<ConsultantRequestCubit, ConsultantRequestState>(
      listener: (context, state) {
        if (state.success == true) {
          showRequestSubmittedDialog(
            context,
            title: AppLocalizations.of(context)!.request_submitted_successfully,
            subTitle: AppLocalizations.of(context)!.consultant_request_sent,
            textBtn: AppLocalizations.of(context)!.done,
            onDone: () {
              context
                  .read<ConsultantMeetingRequestCubit>()
                  .fetchConsultantMeetingRequest();
              Navigator.pop(context);
            },
          );
          // ✅ تفريغ البيانات بعد النجاح + إعادة بناء الـ dropdowns
          cubit.clearAll();
          setState(() => _formVersion++);
        }

        if (state.errorMessage != null) {
          // ✅ رسالة السيرفر عبر custom snackbar (مع تنظيف بادئة Exception)
          final cleaned = state.errorMessage!
              .replaceAll('Exception:', '')
              .trim();
          showCustomSnackBar(context, cleaned, SnackBarType.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.blackColor,
          iconTheme: IconThemeData(color: AppColor.whiteColor),
          title: Text(
            AppLocalizations.of(context)!.consultant_meeting_requests,
            style: MyTextStyle().textStyleSemiBold16().copyWith(
              color: AppColor.whiteColor,
            ),
          ),
        ),
        bottomNavigationBar:
            BlocBuilder<ConsultantRequestCubit, ConsultantRequestState>(
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                  child: state.loading == true
                      ? CircleAvatar(
                          key: const ValueKey('loader'),
                          radius: 32.r,
                          backgroundColor: AppColor.k1primeryColor,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColor.whiteColor,
                            ),
                          ),
                        )
                      : Container(
                          height: 100.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          color: AppColor.whiteColor,
                          child: Center(
                            child: CustomButton(
                              color: AppColor.k1primeryColor,
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  cubit.newConsultantRequest(context);
                                }
                              },
                              text: AppLocalizations.of(context)!.submit,
                              textColor: AppColor.whiteColor,
                            ),
                          ),
                        ),
                );
              },
            ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
            child: SingleChildScrollView(
              child: Column(
                key: ValueKey('consultant_request_form_$_formVersion'),
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      children: [
                        // ✅ category
                        CustomDropdown(
                          hint: AppLocalizations.of(context)!.service_category,
                          items: [
                            "Development",
                            "Design",
                            "Marketing",
                            "Business",
                            "Finance",
                            "Legal",
                            "Human Resources",
                            "IT & Networking",
                            "Data & Analytics",
                            "Product Management",
                            "Customer Support",
                            "Operations",
                          ],
                          onChanged: (value) => cubit.setCategory(value),
                        ),
                        SizedBox(height: 16.h),

                        MyTextFieldWidget(
                          controller: cubit.titleRequestController,
                          hintText: AppLocalizations.of(context)!.title_of_request,
                          validator: (value) =>
                              Validators.required(value, context),
                        ),
                        SizedBox(height: 16.h),

                        // ✅ consultant_type
                        CustomDropdown(
                          hint: AppLocalizations.of(context)!
                              .preferred_consultant_type,
                          items: [
                            "Senior Backend Developer",
                            "Backend Developer",
                            "Frontend Developer",
                            "Full Stack Developer",
                            "Mobile App Developer",
                            "Flutter Developer",
                            "UI/UX Designer",
                            "Product Manager",
                            "Project Manager",
                            "DevOps Engineer",
                            "Cloud Engineer",
                            "Data Analyst",
                            "Data Scientist",
                            "QA Engineer",
                            "Cybersecurity Specialist",
                            "IT Consultant",
                            "Business Analyst",
                            "Digital Marketing Specialist",
                            "SEO Specialist",
                            "Content Strategist",
                          ],
                          onChanged: (value) => cubit.setConsultantType(value),
                        ),
                        SizedBox(height: 16.h),

                        DatePickerField(
                          controller: cubit.startDateController,
                          label: AppLocalizations.of(context)!.preferred_start_date,
                          onDatePicked: (pickedDate) =>
                              cubit.setStartDate(pickedDate),
                        ),
                        SizedBox(height: 16.h),

                        // ✅ urgency — عرض مقروء وإرسال القيمة للـ API
                        Builder(
                          builder: (context) {
                            final urgencyOptions = {
                              AppLocalizations.of(context)!.urgent: 'urgent',
                              AppLocalizations.of(context)!.not_urgent:
                                  'not_urgent',
                            };
                            return CustomDropdown(
                              hint: AppLocalizations.of(context)!.urgency,
                              items: urgencyOptions.keys.toList(),
                              onChanged: (value) => cubit.setUrgency(
                                urgencyOptions[value] ?? value,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16.h),

                        // ✅ estimated_duration
                        CustomDropdown(
                          hint: AppLocalizations.of(context)!.estimated_duration,
                          items: [
                            "Less than 1 week",
                            "1-2 weeks",
                            "2-4 weeks",
                            "1-2 months",
                            "2-3 months",
                            "3-6 months",
                            "6+ months",
                          ],
                          onChanged: (value) =>
                              cubit.setEstimatedDuration(value),
                        ),
                        SizedBox(height: 16.h),

                        MyTextFieldWidget(
                          controller: cubit.budgetMinController,
                          keyboardType: TextInputType.number,
                          hintText: AppLocalizations.of(context)!.budget_range_min,
                          validator: (value) =>
                              Validators.positiveInteger(value, context),
                        ),
                        SizedBox(height: 16.h),

                        MyTextFieldWidget(
                          controller: cubit.budgetMaxController,
                          keyboardType: TextInputType.number,
                          hintText: AppLocalizations.of(context)!.budget_range_max,
                          validator: (value) =>
                              Validators.positiveInteger(value, context),
                        ),
                        SizedBox(height: 16.h),

                        // ✅ supporting_document
                        FilePickerField(
                          controller: cubit.uploadDecController,
                          label: AppLocalizations.of(context)!
                              .upload_supporting_document,
                          assetIcon: AppSvg.uplodeSvg,
                          allowedExtensions: [
                            'pdf',
                            'doc',
                            'docx',
                            'jpg',
                            'png',
                          ],
                          onFilePicked: (file) =>
                              cubit.setDocument(file.path!), // ✅ مسار الملف
                        ),
                        SizedBox(height: 16.h),

                        MyTextFieldWidget(
                          controller: cubit.descriptionController,
                          hintText: AppLocalizations.of(context)!.description,
                          maxLines: 5,
                          validator: (value) =>
                              Validators.required(value, context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
