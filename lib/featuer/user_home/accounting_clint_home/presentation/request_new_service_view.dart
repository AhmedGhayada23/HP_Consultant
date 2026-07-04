import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/service_request_cubit/service_request_cubit.dart';
import 'package:hb/core/cubit/service_request_cubit/service_request_state.dart';
import 'package:hb/core/cubit/service_requests_list_cubit/service_requests_list_cubit.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/date_picker_field.dart';
import 'package:hb/core/widgets/file_picker_field.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/featuer/auth_signup/widgets/custom_checkbox_text_row.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:hb/utils/validators.dart';

class RequestNewServiceView extends StatefulWidget {
  const RequestNewServiceView({super.key});

  @override
  State<RequestNewServiceView> createState() => _RequestNewServiceViewState();
}

class _RequestNewServiceViewState extends State<RequestNewServiceView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<ServiceRequestCubit>().fetchServiceTypes();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = context.read<ServiceRequestCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        title: Text(
          loc.new_service_request,
          style: MyTextStyle().textStyleSemiBold20().copyWith(
            color: AppColor.whiteColor,
          ),
        ),
      ),
      bottomNavigationBar:
          BlocConsumer<ServiceRequestCubit, ServiceRequestState>(
            listenWhen: (prev, curr) => curr.success && !prev.success,
            listener: (context, state) {
              // حدّث قائمة طلبات الخدمة بعد نجاح الإضافة
              context.read<ServiceRequestsListCubit>().fetchServiceRequests();
              showRequestSubmittedDialog(
                context,
                title: loc.new_service_request,
                subTitle: loc.service_request_submitted_subtitle,
                textBtn: loc.done,
                onDone: () => Navigator.pop(context),
              );
            },
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
                        child: CustomButton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              cubit.submitServiceRequest(context);
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                BlocBuilder<ServiceRequestCubit, ServiceRequestState>(
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
                      hint: loc.service_type,
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
                  label: loc.deadline,
                  onDatePicked: (pickedDate) {
                    cubit.setDeadline(pickedDate);
                  },
                ),
                SizedBox(height: 16.h),
                FilePickerField(
                  controller: cubit.supportingDocController,
                  label: loc.supporting_document,
                  assetIcon: AppSvg.uplodeSvg,
                  allowMultiple: true,
                  allowedExtensions: ['pdf'],
                  onFilesPicked: (files) {
                    cubit.setSupportingDocs(files);
                  },
                ),

                SizedBox(height: 16.h),
                MyTextFieldWidget(
                  controller: cubit.budgetController,
                  hintText: loc.budget,
                  validator: (value) => Validators.required(value, context),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.h),
                MyTextFieldWidget(
                  controller: cubit.descriptionController,
                  hintText: loc.description,
                  maxLines: 7,
                  validator: (value) => Validators.required(value, context),
                ),
                SizedBox(height: 16.h),
                BlocBuilder<ServiceRequestCubit, ServiceRequestState>(
                  builder: (context, state) {
                    final allowReview = context.select(
                      (ServiceRequestCubit cubit) => cubit.state.allowReview,
                    );
                    return CustomCheckboxTextRow(
                      isChecked: allowReview,
                      onChanged: (value) {
                        context.read<ServiceRequestCubit>().toggleAllowReview(
                          value,
                        );
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
    );
  }
}
