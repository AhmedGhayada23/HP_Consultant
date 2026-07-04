import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/core/cubit/job_apply_cubit/job_apply_cubit.dart';
import 'package:hb/core/cubit/job_apply_cubit/job_apply_state.dart';
import 'package:hb/core/data/models/recommended_jos_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/date_picker_field.dart';
import 'package:hb/core/widgets/file_picker_field.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/featuer/auth_signup/widgets/custom_checkbox_text_row.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:hb/utils/validators.dart';

class AppleNowJobView extends StatefulWidget {
  final RecommendedJobModel recommendedJobModel;
  const AppleNowJobView({super.key, required this.recommendedJobModel});

  @override
  State<AppleNowJobView> createState() => _AppleNowJobViewState();
}

class _AppleNowJobViewState extends State<AppleNowJobView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // تفريغ بيانات أي تقديم سابق عند الدخول لوظيفة جديدة
    context.read<JobApplyCubit>().clearFields();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = context.read<JobApplyCubit>();
    return BlocListener<JobApplyCubit, JobApplyState>(
      listenWhen: (prev, curr) => curr.success == true && prev.success != true,
      listener: (context, state) {
        showRequestSubmittedDialog(
          context,
          title: loc.application_submitted,
          subTitle: loc.application_submitted_subtitle,
          textBtn: loc.done,
          onDone: () => Navigator.of(context).pop(),
        );
      },
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        title: Text(
          loc.apply,
          style: MyTextStyle().textStyleSemiBold20().copyWith(color: AppColor.whiteColor),
        ),
      ),
      bottomNavigationBar: BlocBuilder<JobApplyCubit, JobApplyState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: state.loading == true
                ? CircleAvatar(
                    key: const ValueKey('loader'),
                    radius: 32.r,
                    backgroundColor: AppColor.k1primeryColor,
                    child: Center(child: CircularProgressIndicator(color: AppColor.whiteColor)),
                  )
                : Container(
                    height: 100.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
                          cubit.newJopApply(
                              context, widget.recommendedJobModel.id);
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
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: AppColor.gray5,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      children: [
                        InfoRow(label: loc.job_title, value: widget.recommendedJobModel.title ?? ''),
                        DashedLine(),
                        SizedBox(height: 12.h),
                        InfoRow(label: loc.budget, value: widget.recommendedJobModel.budget ?? ''),
                        DashedLine(),
                        SizedBox(height: 12.h),
                        InfoRow(
                          label: loc.deadline,
                          value: widget.recommendedJobModel.deadline ?? '',
                        ),
                        DashedLine(),
                        SizedBox(height: 12.h),

                        InfoRow(
                          label: loc.company,
                          value: widget.recommendedJobModel.company ?? '',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  MyTextFieldWidget(
                    controller: cubit.rateController,
                    hintText: loc.proposed_rate_total,
                    validator: (value)=> Validators.required(value, context),
                  ),
                  SizedBox(height: 16.h),
                  MyTextFieldWidget(
                    controller: cubit.estimatedDurationController,

                    hintText: loc.estimated_duration_weeks,
                    validator: (value)=> Validators.required(value, context),
                  ),
                  SizedBox(height: 16.h),

                  DatePickerField(
                    controller: cubit.startDateController,
                    label: loc.availability_start_date,
                    onDatePicked: (pickedDate) {
                      // هنا تقدر تحدث الـ Cubit مباشرة
                      cubit.setStartDate(pickedDate);
                    },
                  ),

                  SizedBox(height: 16.h),
                  FilePickerField(
                    controller: cubit.supportingDocController,
                    label: loc.supporting_documents,
                    assetIcon: AppSvg.uplodeSvg,
                    allowedExtensions: ['pdf'],
                    onFilePicked: (file) {
                      cubit.setSupportingDocPath(file.path);
                    },
                  ),

                  SizedBox(height: 16.h),
                  MyTextFieldWidget(
                    controller: cubit.coverLetterController,
                    hintText: loc.cover_letter_hint,
                    maxLines: 8,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    validator: (value) =>
                        Validators.required(value, context,
                            fieldName: loc.cover_letter) ??
                        Validators.minLength(value, 50, context,
                            fieldName: loc.cover_letter),
                  ),

                  DashedLine(),
                  SizedBox(height: 20.h),
                  BlocBuilder<JobApplyCubit, JobApplyState>(
                    builder: (context, state) {
                      return CustomCheckboxTextRow(
                        isChecked: state.confirmInfo,
                        onChanged: (value) {
                          context.read<JobApplyCubit>().toggleConfirmInfo(value);
                        },
                        text: loc.confirm_info_accurate,
                      );
                    },
                  ),

                  SizedBox(height: 20.h),
                  BlocBuilder<JobApplyCubit, JobApplyState>(
                    builder: (context, state) {
                      return CustomCheckboxTextRow(
                        isChecked: state.allowReview,
                        onChanged: (value) {
                          context.read<JobApplyCubit>().toggleAllowReview(value);
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
      ),
    );
  }
}
