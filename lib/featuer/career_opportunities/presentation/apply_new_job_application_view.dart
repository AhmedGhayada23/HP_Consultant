import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/core/cubit/apply_now_job_internship_cubit/apply_now_job_internship_cubit.dart';
import 'package:hb/core/cubit/apply_now_job_internship_cubit/apply_now_job_internship_state.dart';
import 'package:hb/core/cubit/completed_courses_cubit/completed_courses_cubit.dart';
import 'package:hb/core/cubit/completed_courses_cubit/completed_courses_state.dart';
import 'package:hb/core/data/models/completed_course_model.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/date_picker_field.dart';
import 'package:hb/core/widgets/file_picker_field.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/featuer/auth_signup/widgets/custom_checkbox_text_row.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:hb/utils/validators.dart';

class ApplyNewJobApplicationView extends StatefulWidget {
  final int jobId;
  final String? jobTitle;
  final String? duration;
  final String? company;
  const ApplyNewJobApplicationView({
    super.key,
    required this.jobId,
    this.jobTitle,
    this.duration,
    this.company,
  });

  @override
  State<ApplyNewJobApplicationView> createState() =>
      _ApplyNewJobApplicationViewState();
}

class _ApplyNewJobApplicationViewState
    extends State<ApplyNewJobApplicationView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // حمّل الدورات المكتملة لعرضها في القائمة
    if (context.read<CompletedCoursesCubit>().state.data == null) {
      context.read<CompletedCoursesCubit>().fetchCompletedCourses();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = context.read<ApplyNowJobInternshipCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        title: Text(
          loc.apply,
          style: MyTextStyle().textStyleSemiBold20().copyWith(
            color: AppColor.whiteColor,
          ),
        ),
      ),
      bottomNavigationBar:
          BlocConsumer<ApplyNowJobInternshipCubit, ApplyNowJobInternshipState>(
            listener: (context, state) {
              if (state.isSuccess) {
                showRequestSubmittedDialog(
                  context,
                  title: loc.application_submitted_title,
                  subTitle: loc.application_submitted_subtitle,
                  textBtn: loc.done,
                  onDone: () => Navigator.pop(context),
                );
              } else if (state.errorMessage != null && !state.isLoading) {
                showCustomSnackBar(
                  context,
                  state.errorMessage!,
                  SnackBarType.error,
                );
              }
            },
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: state.isLoading == true
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              offset: Offset(0, -3),
                              color: AppColor.borderColor,
                            ),
                          ],
                        ),
                        child: CustomButton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              cubit.applyNowJobInternship(
                                context,
                                jobId: widget.jobId,
                              );
                            }
                          },
                          color: AppColor.k1primeryColor,
                          text: loc.submit,
                        ),
                      ),
              );
            },
          ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.gray5,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      children: [
                        InfoRow(
                          label: loc.job_title,
                          value: widget.jobTitle ?? '',
                        ),
                        DashedLine(),
                        SizedBox(height: 12.h),
                        InfoRow(
                          label: loc.duration,
                          value: widget.duration ?? '',
                        ),
                        DashedLine(),
                        SizedBox(height: 12.h),

                        InfoRow(
                          label: loc.company,
                          value: widget.company ?? '',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  MyTextFieldWidget(
                    controller: cubit.nameTextEditingController,
                    hintText: loc.name_label,
                    validator: (value) => Validators.required(value, context),
                  ),
                  SizedBox(height: 16.h),
                  MyTextFieldWidget(
                    controller: cubit.emailTextEditingController,
                    hintText: loc.email_address,
                    validator: (value) => Validators.email(value, context),
                  ),
                  SizedBox(height: 16.h),
                  BlocBuilder<CompletedCoursesCubit, CompletedCoursesState>(
                    builder: (context, coursesState) {
                      final courses = coursesState.data ?? [];
                      return CustomDropdown(
                        hint: loc.completed_courses,
                        items: courses
                            .map((c) => c.title)
                            .where((t) => t.isNotEmpty)
                            .toList(),
                        onChanged: (value) {
                          final selected = courses.firstWhere(
                            (c) => c.title == value,
                            orElse: () => CompletedCourseModel(),
                          );
                          cubit.setCompletedCourseIds(
                            selected.id != 0 ? [selected.id] : [],
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                  DatePickerField(
                    controller: cubit.startDateTextEditingController,
                    label: loc.availability_start_date,
                    onDatePicked: (pickedDate) {
                      // هنا تقدر تحدث الـ Cubit مباشرة
                      cubit.setDeadline(pickedDate);
                    },
                  ),

                  SizedBox(height: 16.h),
                  FilePickerField(
                    controller: cubit.supporingTextEditingController,
                    label: loc.supporting_documents_cv,
                    assetIcon: AppSvg.uplodeSvg,
                    allowedExtensions: ['pdf'],
                    onFilePicked: (file) {
                      cubit.setCvFile(file);
                    },
                  ),

                  SizedBox(height: 16.h),
                  MyTextFieldWidget(
                    controller: cubit.coverTextEditingController,
                    hintText: loc.cover_letter_proposal,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                  ),

                  DashedLine(),
                  SizedBox(height: 20.h),
                  BlocBuilder<
                    ApplyNowJobInternshipCubit,
                    ApplyNowJobInternshipState
                  >(
                    builder: (context, state) {
                      final confirmInfo = context.select(
                        (ApplyNowJobInternshipCubit cubit) =>
                            cubit.state.confirmInfo,
                      );
                      return CustomCheckboxTextRow(
                        isChecked: confirmInfo,
                        onChanged: (value) {
                          cubit.toggleConfirmInfo(value);
                        },
                        text: loc.confirm_info_accurate,
                      );
                    },
                  ),

                  SizedBox(height: 20.h),
                  BlocBuilder<
                    ApplyNowJobInternshipCubit,
                    ApplyNowJobInternshipState
                  >(
                    builder: (context, state) {
                      final allowReview = context.select(
                        (ApplyNowJobInternshipCubit cubit) =>
                            cubit.state.allowReview,
                      );
                      return CustomCheckboxTextRow(
                        isChecked: allowReview,
                        onChanged: (value) {
                          cubit.toggleAllowReview(value);
                        },
                        text: loc.allow_admin_review,
                      );
                    },
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
