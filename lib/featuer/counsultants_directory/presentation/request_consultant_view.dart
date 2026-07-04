import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/consultant_requests_cubit/consultant_requests_cubit.dart';
import 'package:hb/core/cubit/request_consultant_cubit/request_consultant_cubit.dart';
import 'package:hb/core/cubit/request_consultant_cubit/request_consultant_state.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/date_picker_field.dart';
import 'package:hb/core/widgets/file_picker_field.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/featuer/auth_signup/widgets/custom_checkbox_text_row.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';

class RequestConsultantView extends StatefulWidget {
  /// معرّف المستشار المطلوب (consultant_id)
  final int consultantId;
  const RequestConsultantView({super.key, this.consultantId = 0});

  @override
  State<RequestConsultantView> createState() => _RequestConsultantViewState();
}

class _RequestConsultantViewState extends State<RequestConsultantView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<RequestConsultantCubit>().fetchServiceTypes();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RequestConsultantCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        title: Text(
          AppLocalizations.of(context)!.request_consultant,
          style: MyTextStyle().textStyleSemiBold20().copyWith(
            color: AppColor.whiteColor,
          ),
        ),
      ),
      bottomNavigationBar:
          BlocConsumer<RequestConsultantCubit, RequestConsultantState>(
            listenWhen: (prev, curr) =>
                curr.isRequestSuccessful && !prev.isRequestSuccessful,
            listener: (context, state) {
              // حدّث قائمة الطلبات
              context.read<ConsultantRequestsCubit>().fetchConsultantRequests();
              showRequestSubmittedDialog(
                context,
                title: AppLocalizations.of(context)!.request_consultant,
                subTitle: AppLocalizations.of(
                  context,
                )!.consultant_request_submitted,
                textBtn: AppLocalizations.of(context)!.done,
                onDone: () => Navigator.pop(context),
              );
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
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, -3),
                              color: AppColor.borderColor,
                            ),
                          ],
                        ),
                        child: CustomButton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              cubit.requestConsultant(
                                context,
                                consultantId: widget.consultantId,
                              );
                            }
                          },
                          color: AppColor.k1primeryColor,
                          text: AppLocalizations.of(context)!.submit,
                        ),
                      ),
              );
            },
          ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),

            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                MyTextFieldWidget(
                  controller: cubit.tittleController,
                  hintText: AppLocalizations.of(context)!.project_service_title,
                  validator: (value) => Validators.required(value, context),
                ),
                SizedBox(height: 16.h),
                BlocBuilder<RequestConsultantCubit, RequestConsultantState>(
                  buildWhen: (prev, curr) =>
                      prev.serviceTypes != curr.serviceTypes ||
                      prev.serviceTypesLoading != curr.serviceTypesLoading ||
                      prev.selectedServiceTypeId != curr.selectedServiceTypeId,
                  builder: (context, state) {
                    final types = state.serviceTypes ?? [];
                    final matches = types.where(
                      (t) => t.id == state.selectedServiceTypeId,
                    );
                    final selected = matches.isEmpty
                        ? null
                        : matches.first.serviceType;
                    return CustomDropdown(
                      hint: AppLocalizations.of(context)!.service_type,
                      items: types.map((t) => t.serviceType).toList(),
                      selectedValue: selected,
                      onChanged: (value) {
                        final match = types.where(
                          (t) => t.serviceType == value,
                        );
                        if (match.isNotEmpty) {
                          cubit.setServiceType(match.first.id);
                        }
                      },
                    );
                  },
                ),
                SizedBox(height: 16.h),
                DatePickerField(
                  controller: cubit.deadlineController,
                  label: AppLocalizations.of(context)!.deadline,
                  onDatePicked: (pickedDate) {
                    cubit.setDeadline(pickedDate);
                  },
                ),

                SizedBox(height: 16.h),
                Builder(
                  builder: (context) {
                    final loc = AppLocalizations.of(context)!;
                    // العرض مترجم، والقيمة المرسلة fixed/hourly
                    final pricingOptions = {
                      loc.fixed: 'fixed',
                      loc.hourly: 'hourly',
                    };
                    return CustomDropdown(
                      hint: loc.service_type_fixed_hourly,
                      items: pricingOptions.keys.toList(),
                      onChanged: (value) =>
                          cubit.setPricingType(pricingOptions[value] ?? value),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                MyTextFieldWidget(
                  controller: cubit.budgetController,
                  hintText: AppLocalizations.of(context)!.budget,
                  validator: (value) => Validators.required(value, context),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.h),
                Builder(
                  builder: (context) {
                    final loc = AppLocalizations.of(context)!;
                    // العرض مترجم، والقيمة المرسلة low/medium/high
                    final priorityOptions = {
                      loc.low: 'low',
                      loc.medium: 'medium',
                      loc.high: 'high',
                    };
                    return CustomDropdown(
                      hint: loc.priority,
                      items: priorityOptions.keys.toList(),
                      onChanged: (value) =>
                          cubit.setPriority(priorityOptions[value] ?? value),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                FilePickerField(
                  controller: cubit.supportingDocController,
                  label: AppLocalizations.of(context)!.supporting_documents,
                  assetIcon: AppSvg.uplodeSvg,
                  allowMultiple: true,
                  allowedExtensions: const ['pdf'],
                  onFilesPicked: (files) {
                    cubit.setSupportingDocs(files);
                  },
                ),

                SizedBox(height: 16.h),
                MyTextFieldWidget(
                  controller: cubit.descriptionController,
                  hintText: AppLocalizations.of(context)!.description,
                  maxLines: 7,
                  validator: (value) => Validators.required(value, context),
                ),

                DashedLine(),
                SizedBox(height: 20.h),
                BlocBuilder<RequestConsultantCubit, RequestConsultantState>(
                  builder: (context, state) => CustomCheckboxTextRow(
                    isChecked: state.allowReview,
                    onChanged: (value) {
                      cubit.toggleAllowReview(value);
                    },
                    text: AppLocalizations.of(context)!.allow_admin_review,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
