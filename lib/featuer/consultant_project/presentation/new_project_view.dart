import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/active_project_cubit/active_project_cubit.dart';
import 'package:hb/core/cubit/add_project_cubit/add_project_cubit.dart';
import 'package:hb/core/cubit/add_project_cubit/add_project_state.dart';
import 'package:hb/core/cubit/consultant_project_cubit/consultant_project_cubit.dart';
import 'package:hb/core/cubit/consultant_project_cubit/consultant_project_state.dart';
import 'package:hb/core/cubit/payment_types_cubit/payment_types_cubit.dart';
import 'package:hb/core/cubit/payment_types_cubit/payment_types_state.dart';
import 'package:hb/core/cubit/project_types_cubit/project_types_cubit.dart';
import 'package:hb/core/cubit/project_types_cubit/project_types_state.dart';
import 'package:hb/core/data/models/milestone_model.dart';
import 'package:hb/core/message/message_snack_bar.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/date_picker_field.dart';
import 'package:hb/core/widgets/file_picker_field.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/core/widgets/validateWidget.dart';
import 'package:hb/featuer/consultant_project/widgets/btn_new_project_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:hb/utils/validators.dart';

class NewProjectView extends StatefulWidget {
  const NewProjectView({super.key});

  @override
  State<NewProjectView> createState() => _NewProjectViewState();
}

class _NewProjectViewState extends State<NewProjectView> {
  final _formKey = GlobalKey<FormState>();
  final _milestoneFormKey = GlobalKey<FormState>();
  // يُزاد عند النجاح لإعادة بناء النموذج وتصفير الـ dropdowns غير المرتبطة بـ controller
  int _formVersion = 0;

  @override
  void initState() {
    super.initState();
    context.read<ProjectTypesCubit>().fetchProjectTypes();
    context.read<PaymentTypesCubit>().fetchPaymentTypes();
    context.read<ConsultantProjectCubit>().fetchConsultantProject();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddProjectCubit>();
    return BlocListener<AddProjectCubit, AddProjectState>(
      listener: (context, state) {
        if (state.success == true) {
          showRequestSubmittedDialog(
            context,
            title: AppLocalizations.of(context)!.project_submitted_successfully,
            subTitle: AppLocalizations.of(context)!.project_submitted_subtitle,
            textBtn: AppLocalizations.of(context)!.done,
            onDone: () {
              context.read<ActiveProjectCubit>().fetchActiveProject();
              Navigator.of(context).pop();
            },
          );
          // تفريغ جميع البيانات بعد النجاح
          cubit.clearAll();
          context.read<ProjectTypesCubit>().clearProjectType();
          context.read<PaymentTypesCubit>().clearPaymentType();
          setState(
            () => _formVersion++,
          ); // إعادة بناء النموذج لتصفير الـ dropdowns
        }

        if (state.errorMessage != null) {
          // تنظيف الرسالة من بادئات Exception المتكررة
          final cleaned = state.errorMessage!
              .replaceAll('Exception:', '')
              .replaceAll('Unexpected error:', '')
              .trim();
          showCustomSnackBar(context, cleaned, SnackBarType.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.blackColor,
          iconTheme: IconThemeData(color: AppColor.whiteColor),
          title: Text(
            AppLocalizations.of(context)!.create_new_project,
            style: MyTextStyle().textStyleSemiBold16().copyWith(
              color: AppColor.whiteColor,
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<AddProjectCubit, AddProjectState>(
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
                  : BtnNewProjectWidget(
                      onTap: () {
                        if (!_formKey.currentState!.validate()) return;
                        // منع الإرسال إذا كان تاريخ الانتهاء ليس لاحقًا لتاريخ البدء
                        final start = cubit.startDate;
                        final deadline = cubit.deadlineDate;
                        if (start != null &&
                            deadline != null &&
                            !deadline.isAfter(start)) {
                          showCustomSnackBar(
                            context,
                            AppLocalizations.of(
                              context,
                            )!.deadline_after_start_date,
                            SnackBarType.error,
                          );
                          return;
                        }
                        cubit.newProject(context);
                      },
                      title: AppLocalizations.of(context)!.submit_new_project,
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
                key: ValueKey('new_project_form_$_formVersion'),
                children: [
                  InkWell(
                    onTap: () => Navigator,
                    child: Container(
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
                          MyTextFieldWidget(
                            controller: cubit.titleProjectController,
                            hintText: AppLocalizations.of(
                              context,
                            )!.project_title,
                            validator: (value) =>
                                Validators.required(value, context),
                          ),
                          SizedBox(height: 16.h),
                          Builder(
                            builder: (context) {
                              final loc = AppLocalizations.of(context)!;
                              // عرض مترجم مع إرسال قيمة ثابتة للخادم
                              final categories = {
                                loc.category_consulting: 'consulting',
                                loc.category_technology: 'technology',
                                loc.category_development: 'development',
                                loc.category_design: 'design',
                              };
                              return CustomDropdown(
                                hint: loc.project_category,
                                items: categories.keys.toList(),
                                onChanged: (value) =>
                                    cubit.setCategory(categories[value]!),
                              );
                            },
                          ),
                          SizedBox(height: 16.h),
                          ValidateWidget(
                            validator: (value) {
                              final projectTypesCubit = context
                                  .read<ProjectTypesCubit>();
                              if (projectTypesCubit.state.selectedProjectType ==
                                  null) {
                                return '${AppLocalizations.of(context)!.this_field} ${AppLocalizations.of(context)!.is_required}';
                              }
                              return null;
                            },
                            child:
                                BlocBuilder<
                                  ProjectTypesCubit,
                                  ProjectTypesState
                                >(
                                  builder: (context, state) {
                                    final loc = AppLocalizations.of(context)!;
                                    final api = state.projectTypes ?? [];
                                    // بديل مترجم عند غياب بيانات الـ API
                                    final fallback = {
                                      loc.full_time: 'full_time',
                                      loc.part_time: 'part_time',
                                      loc.contract: 'contract',
                                      loc.freelance: 'freelance',
                                    };
                                    final useFallback = api.isEmpty;
                                    return CustomDropdown(
                                      hint: loc.project_type,
                                      items: useFallback
                                          ? fallback.keys.toList()
                                          : api.map((e) => e.name).toList(),
                                      onChanged: (value) {
                                        final projectTypesCubit = context
                                            .read<ProjectTypesCubit>();
                                        if (useFallback) {
                                          projectTypesCubit
                                              .setProjectType(fallback[value]!);
                                        } else {
                                          final selected = api.firstWhere(
                                            (e) => e.name == value,
                                          );
                                          projectTypesCubit
                                              .setProjectType(selected.name);
                                        }
                                      },
                                    );
                                  },
                                ),
                          ),
                          SizedBox(height: 16.h),
                          DatePickerField(
                            controller: cubit.startDateController,
                            label: AppLocalizations.of(context)!.start_date,
                            onDatePicked: (pickedDate) {
                              // هنا تقدر تحدث الـ Cubit مباشرة
                              cubit.setStartDate(pickedDate);
                            },
                          ),

                          SizedBox(height: 16.h),
                          DatePickerField(
                            controller: cubit.deadlineController,
                            label: AppLocalizations.of(context)!.deadline,
                            onDatePicked: (pickedDate) {
                              // هنا تقدر تحدث الـ Cubit مباشرة
                              cubit.setDeadline(pickedDate);
                            },
                          ),
                          SizedBox(height: 16.h),

                          MyTextFieldWidget(
                            controller: cubit.budgetController,
                            hintText: AppLocalizations.of(context)!.budget,
                            validator: (value) =>
                                Validators.positiveInteger(value, context),
                          ),
                          SizedBox(height: 16.h),
                          ValidateWidget(
                            validator: (value) {
                              final paymentTypesCubit = context
                                  .read<PaymentTypesCubit>();
                              if (paymentTypesCubit.state.selectedPaymentType ==
                                  null) {
                                return '${AppLocalizations.of(context)!.this_field} ${AppLocalizations.of(context)!.is_required}';
                              }
                              return null;
                            },
                            child:
                                BlocBuilder<
                                  PaymentTypesCubit,
                                  PaymentTypesState
                                >(
                                  builder: (context, state) {
                                    final loc = AppLocalizations.of(context)!;
                                    final api = state.paymentTypes ?? [];
                                    // بديل مترجم عند غياب بيانات الـ API
                                    final fallback = {
                                      loc.fixed_price: 'fixed',
                                      loc.hourly_rate_type: 'hourly',
                                      loc.milestone_payments: 'milestone',
                                    };
                                    final useFallback = api.isEmpty;
                                    return CustomDropdown(
                                      hint: loc.payment_type,
                                      items: useFallback
                                          ? fallback.keys.toList()
                                          : api.map((e) => e.name).toList(),
                                      onChanged: (value) {
                                        final paymentTypesCubit = context
                                            .read<PaymentTypesCubit>();
                                        if (useFallback) {
                                          paymentTypesCubit
                                              .setPaymentType(fallback[value]!);
                                        } else {
                                          final selected = api.firstWhere(
                                            (e) => e.name == value,
                                          );
                                          paymentTypesCubit
                                              .setPaymentType(selected.value);
                                        }
                                      },
                                    );
                                  },
                                ),
                          ),
                          SizedBox(height: 16.h),
                          Builder(
                            builder: (context) {
                              final loc = AppLocalizations.of(context)!;
                              // عرض مترجم مع إرسال قيمة ثابتة للخادم
                              final priorities = {
                                loc.low: 'low',
                                loc.medium: 'medium',
                                loc.high: 'high',
                              };
                              return CustomDropdown(
                                hint: loc.priority,
                                items: priorities.keys.toList(),
                                onChanged: (value) =>
                                    cubit.setPriority(priorities[value]!),
                              );
                            },
                          ),

                          SizedBox(height: 16.h),
                          FilePickerField(
                            controller: cubit.jobFileController,
                            label: AppLocalizations.of(context)!.job_files,
                            assetIcon: AppSvg.uplodeSvg,
                            allowedExtensions: ['pdf'],
                            onFilePicked: (file) {
                              // هنا تقدر تحدث الـ Cubit مباشرة
                              //  cubit.setJobFile(file);
                            },
                          ),

                          SizedBox(height: 16.h),
                          MyTextFieldWidget(
                            controller: cubit.descriotionController,
                            hintText: AppLocalizations.of(
                              context,
                            )!.project_description,
                            maxLines: 5,
                            validator: (value) =>
                                Validators.required(value, context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Form(
                      key: _milestoneFormKey,
                      child: Column(
                        children: [
                          MyTextFieldWidget(
                            controller: cubit.milestoneTitleController,
                            hintText: AppLocalizations.of(
                              context,
                            )!.milestone_title,
                            validator: (value) =>
                                Validators.required(value, context),
                          ),
                          SizedBox(height: 16.h),
                          DatePickerField(
                            controller: cubit.dueDateController,
                            label: AppLocalizations.of(context)!.due_date,
                            // لا نستدعي setDeadline هنا حتى لا نفسد تاريخ انتهاء المشروع
                            onDatePicked: (pickedDate) {},
                          ),

                          SizedBox(height: 16.h),

                          MyTextFieldWidget(
                            controller: cubit.budgetAllocationController,
                            hintText: AppLocalizations.of(
                              context,
                            )!.budget_allocation,
                            validator: (value) =>
                                Validators.positiveInteger(value, context),
                          ),
                          SizedBox(height: 16.h),
                          BlocBuilder<
                            ConsultantProjectCubit,
                            ConsultantProjectState
                          >(
                            builder: (context, state) {
                              return CustomDropdown(
                                hint: AppLocalizations.of(context)!.assign_to,
                                items:
                                    state.consultantProjectData
                                        ?.map((e) => e.name)
                                        .toList() ??
                                    [],
                                onChanged: (value) {
                                  final selected = state.consultantProjectData
                                      ?.firstWhere((e) => e.name == value);
                                  if (selected != null) {
                                    context.read<AddProjectCubit>().setAssignTo(
                                      selected.id,
                                    );
                                  }
                                },
                              );
                            },
                          ),

                          SizedBox(height: 16.h),

                          MyTextFieldWidget(
                            controller: cubit.deliverablesDecController,
                            hintText: AppLocalizations.of(
                              context,
                            )!.deliverables_description,
                            maxLines: 5,
                            validator: (value) =>
                                Validators.required(value, context),
                          ),

                          SizedBox(height: 24.h),
                          InkWell(
                            onTap: () {
                              if (_milestoneFormKey.currentState!.validate()) {
                                final cubit = context.read<AddProjectCubit>();

                                // ✅ التحقق من assign_to
                                if (cubit.selectedAssignTo == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.please_select_user_to_assign,
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final milestone = MilestoneModel(
                                  title: cubit.milestoneTitleController.text,
                                  deadline: cubit.dueDateController.text,
                                  budgetAllocation:
                                      double.tryParse(
                                        cubit.budgetAllocationController.text,
                                      ) ??
                                      0,
                                  assignTo:
                                      cubit.selectedAssignTo!, // ✅ int (ID)
                                  deliverables:
                                      cubit.deliverablesDecController.text,
                                );

                                cubit.addMilestone(milestone);
                                cubit.clearMilestoneFields(); // ✅ تنظيف الحقول

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.milestone_added_successfully,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.r),
                                border: Border.all(
                                  width: 1.w,
                                  color: AppColor.k1primeryColor,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.add_milestone,
                                  style: MyTextStyle()
                                      .textStyleSemiBold16()
                                      .copyWith(color: AppColor.k1primeryColor),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          BlocBuilder<AddProjectCubit, AddProjectState>(
                            builder: (context, state) {
                              if (cubit.milestones.isEmpty) {
                                return SizedBox.shrink();
                              }

                              return ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final m = cubit.milestones[index];
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 24.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.gray5,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ✅ Row للعنوان + زر الحذف
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              m.title,
                                              style: MyTextStyle()
                                                  .textStyleSemiBold16(),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                context
                                                    .read<AddProjectCubit>()
                                                    .removeMilestone(index);
                                              },

                                              child: Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                                size: 22.r,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${AppLocalizations.of(context)!.assign_to}:',
                                              style: MyTextStyle()
                                                  .textStyleRegular14(),
                                            ),
                                            Text(
                                              m.assignTo.toString(),
                                              style: MyTextStyle()
                                                  .textStyleRegular14(),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${AppLocalizations.of(context)!.deadline}:',
                                              style: MyTextStyle()
                                                  .textStyleRegular14(),
                                            ),
                                            Text(
                                              m.deadline,
                                              style: MyTextStyle()
                                                  .textStyleRegular14(),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${AppLocalizations.of(context)!.budget_allocation}:',
                                              style: MyTextStyle()
                                                  .textStyleRegular14(),
                                            ),
                                            Text(
                                              m.budgetAllocation.toString(),
                                              style: MyTextStyle()
                                                  .textStyleRegular14(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 10.h),
                                itemCount: cubit.milestones.length,
                              );
                            },
                          ),
                        ],
                      ),
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
