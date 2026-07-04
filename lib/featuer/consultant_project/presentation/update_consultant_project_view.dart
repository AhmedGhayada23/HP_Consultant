import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/consultant_project_cubit/consultant_project_cubit.dart';
import 'package:hb/core/cubit/consultant_project_cubit/consultant_project_state.dart';
import 'package:hb/core/cubit/details_project_cubit/details_project_cubit.dart';
import 'package:hb/core/cubit/details_project_cubit/details_project_state.dart';
import 'package:hb/core/cubit/payment_types_cubit/payment_types_cubit.dart';
import 'package:hb/core/cubit/payment_types_cubit/payment_types_state.dart';
import 'package:hb/core/cubit/project_types_cubit/project_types_cubit.dart';
import 'package:hb/core/cubit/project_types_cubit/project_types_state.dart';
import 'package:hb/core/cubit/update_project_cubit/update_project_cubit.dart';
import 'package:hb/core/cubit/update_project_cubit/update_project_state.dart';
import 'package:hb/core/data/models/details_project_model.dart';
import 'package:hb/core/data/models/milestone_model.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/date_picker_field.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/core/widgets/validateWidget.dart';
import 'package:hb/featuer/consultant_project/widgets/btn_new_project_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UpdateConsultantProjectView extends StatefulWidget {
  final int projectId;
  const UpdateConsultantProjectView({super.key, required this.projectId});

  @override
  State<UpdateConsultantProjectView> createState() =>
      _UpdateConsultantProjectViewState();
}

class _UpdateConsultantProjectViewState
    extends State<UpdateConsultantProjectView> {
  final _formKey = GlobalKey<FormState>();
  final _milestoneFormKey = GlobalKey<FormState>();
  late UpdateProjectCubit cubit;
  bool _prefilled = false; // لمنع تكرار تعبئة الحقول

  @override
  void initState() {
    super.initState();

    cubit = context.read<UpdateProjectCubit>();

    // جلب القوائم + تفاصيل المشروع (التعبئة تتم عند وصول التفاصيل)
    context.read<ProjectTypesCubit>().fetchProjectTypes();
    context.read<PaymentTypesCubit>().fetchPaymentTypes();
    context.read<ConsultantProjectCubit>().fetchConsultantProject();
    context.read<DetailsProjectCubit>().fetchDetailsProject(widget.projectId);
  }

  // تعبئة الحقول من البيانات المجلوبة (مرة واحدة)
  void _prefill(DetailsProjectModel data) {
    if (_prefilled) return;
    final project = data.project;
    if (project == null) return;
    _prefilled = true;

    cubit.titleProjectController.text = project.title;
    cubit.deadlineController.text = project.deadline;
    cubit.budgetController.text = project.budget.replaceAll(
      RegExp(r'[^\d.]'),
      '',
    );
    cubit.descriotionController.text = project.description;

    cubit.setCategory(project.category);
    cubit.setPriority(project.priority);

    context.read<ProjectTypesCubit>().setProjectType(project.projectType);
    context.read<PaymentTypesCubit>().setPaymentType(project.paymentType);

    for (final m in data.projectMilestones) {
      cubit.addMilestone(
        MilestoneModel(
          title: m.title,
          deadline: m.deadline,
          budgetAllocation: m.budget is String
              ? double.tryParse(m.budget.toString()) ?? 0
              : (m.budget as num).toDouble(),
          assignTo: int.tryParse(m.assignedTo.toString()) ?? 0,
          deliverables: '',
        ),
      );
    }
  }

  @override
  void dispose() {
    cubit.clearAllData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UpdateProjectCubit>();

    // تفاصيل المشروع المجلوبة + تعبئة الحقول
    final detailsState = context.watch<DetailsProjectCubit>().state;
    final project = detailsState.data?.project;

    // skeleton أثناء تحميل التفاصيل أو القوائم الثلاث
    final bool loadingData =
        (detailsState.loading ?? false) ||
        detailsState.data == null ||
        context.watch<ProjectTypesCubit>().state.isLoading ||
        context.watch<PaymentTypesCubit>().state.isLoading ||
        context.watch<ConsultantProjectCubit>().state.loading;

    return MultiBlocListener(
      listeners: [
        // تعبئة الحقول عند وصول تفاصيل المشروع
        BlocListener<DetailsProjectCubit, DetailsProjectState>(
          listenWhen: (prev, curr) => prev.data != curr.data,
          listener: (context, state) {
            if (state.data != null) _prefill(state.data!);
          },
        ),
        BlocListener<UpdateProjectCubit, UpdateProjectState>(
          listener: (context, state) {
            if (state.success == true) {
              showCustomSnackBar(
                context,
                AppLocalizations.of(context)!.update_project_successfully,
                SnackBarType.success,
              );
              context.read<DetailsProjectCubit>().fetchDetailsProject(
                widget.projectId,
              );
              Navigator.pop(context);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.blackColor,
          iconTheme: IconThemeData(color: AppColor.whiteColor),
          title: Text(
            AppLocalizations.of(context)!.update_project,
            style: MyTextStyle().textStyleSemiBold16().copyWith(
              color: AppColor.whiteColor,
            ),
          ),
        ),
        bottomNavigationBar:
            BlocBuilder<UpdateProjectCubit, UpdateProjectState>(
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: state.loading == true
                      ? CircleAvatar(
                          key: const ValueKey('loader'),
                          radius: 32.r,
                          backgroundColor: AppColor.k1primeryColor,
                          child: CircularProgressIndicator(
                            color: AppColor.whiteColor,
                          ),
                        )
                      : BtnNewProjectWidget(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              cubit.updateProject(context, widget.projectId);
                            }
                          },
                          title: AppLocalizations.of(context)!.submit,
                        ),
                );
              },
            ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
            child: Skeletonizer(
              enabled: loadingData,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ========================= Project Info =========================
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
                          MyTextFieldWidget(
                            controller: cubit.titleProjectController,
                            hintText: AppLocalizations.of(
                              context,
                            )!.project_title,
                            validator: (value) =>
                                Validators.required(value, context),
                          ),
                          SizedBox(height: 16.h),
                          BlocBuilder<UpdateProjectCubit, UpdateProjectState>(
                            buildWhen: (prev, curr) =>
                                prev.selectedCategory != curr.selectedCategory,
                            builder: (context, state) {
                              final loc = AppLocalizations.of(context)!;
                              // القيمة الثابتة → العرض المترجم (كما في الصورة)
                              final categories = {
                                'consulting': loc.category_consulting,
                                'technology': loc.category_technology,
                                'development': loc.category_development,
                                'design': loc.category_design,
                              };
                              return CustomDropdown(
                                hint: loc.project_category,
                                selectedValue: categories[
                                        state.selectedCategory?.toLowerCase()] ??
                                    '',
                                items: categories.values.toList(),
                                onChanged: (value) {
                                  final canonical = categories.entries
                                      .firstWhere((e) => e.value == value)
                                      .key;
                                  cubit.setCategory(canonical);
                                },
                              );
                            },
                          ),
                          SizedBox(height: 16.h),
                          ValidateWidget(
                            validator: (_) {
                              if (context
                                      .read<ProjectTypesCubit>()
                                      .state
                                      .selectedProjectType ==
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
                                      'full_time': loc.full_time,
                                      'part_time': loc.part_time,
                                      'contract': loc.contract,
                                      'freelance': loc.freelance,
                                    };
                                    final useFallback = api.isEmpty;
                                    final stored = project?.projectType ?? '';
                                    return CustomDropdown(
                                      hint: loc.project_type,
                                      selectedValue: useFallback
                                          ? (fallback[stored.toLowerCase()] ?? '')
                                          : stored,
                                      items: useFallback
                                          ? fallback.values.toList()
                                          : api.map((e) => e.name).toList(),
                                      onChanged: (value) {
                                        final ptCubit =
                                            context.read<ProjectTypesCubit>();
                                        if (useFallback) {
                                          final canonical = fallback.entries
                                              .firstWhere((e) => e.value == value)
                                              .key;
                                          ptCubit.setProjectType(canonical);
                                        } else {
                                          final selected = api.firstWhere(
                                            (e) => e.name == value,
                                          );
                                          ptCubit.setProjectType(selected.name);
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
                            onDatePicked: (date) => cubit.setStartDate(date),
                          ),
                          SizedBox(height: 16.h),
                          DatePickerField(
                            controller: cubit.deadlineController,
                            label: AppLocalizations.of(context)!.deadline,
                            onDatePicked: (date) => cubit.setDeadline(date),
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
                            validator: (_) {
                              if (context
                                      .read<PaymentTypesCubit>()
                                      .state
                                      .selectedPaymentType ==
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
                                    final useFallback = api.isEmpty;
                                    final stored = project?.paymentType ?? '';
                                    // بديل مترجم عند غياب بيانات الـ API
                                    final fallback = {
                                      'fixed': loc.fixed_price,
                                      'hourly': loc.hourly_rate_type,
                                      'milestone': loc.milestone_payments,
                                    };
                                    String selectedValue;
                                    if (useFallback) {
                                      selectedValue =
                                          fallback[stored.toLowerCase()] ?? '';
                                    } else {
                                      // المخزّن قد يكون value (مثل hourly) فنحوّله لاسم العرض
                                      final matches = api
                                          .where((e) =>
                                              e.value == stored ||
                                              e.name == stored)
                                          .toList();
                                      selectedValue = matches.isNotEmpty
                                          ? matches.first.name
                                          : stored;
                                    }
                                    return CustomDropdown(
                                      hint: loc.payment_type,
                                      selectedValue: selectedValue,
                                      items: useFallback
                                          ? fallback.values.toList()
                                          : api.map((e) => e.name).toList(),
                                      onChanged: (value) {
                                        final ptCubit =
                                            context.read<PaymentTypesCubit>();
                                        if (useFallback) {
                                          final canonical = fallback.entries
                                              .firstWhere((e) => e.value == value)
                                              .key;
                                          ptCubit.setPaymentType(canonical);
                                        } else {
                                          final selected = api.firstWhere(
                                            (e) => e.name == value,
                                          );
                                          ptCubit.setPaymentType(selected.value);
                                        }
                                      },
                                    );
                                  },
                                ),
                          ),
                          SizedBox(height: 16.h),
                          BlocBuilder<UpdateProjectCubit, UpdateProjectState>(
                            buildWhen: (prev, curr) =>
                                prev.selectedPriority != curr.selectedPriority,
                            builder: (context, state) {
                              final loc = AppLocalizations.of(context)!;
                              // القيمة الثابتة → العرض المترجم
                              final priorities = {
                                'low': loc.low,
                                'medium': loc.medium,
                                'high': loc.high,
                              };
                              return CustomDropdown(
                                hint: loc.priority,
                                selectedValue: priorities[
                                        state.selectedPriority?.toLowerCase()] ??
                                    '',
                                items: priorities.values.toList(),
                                onChanged: (value) {
                                  final canonical = priorities.entries
                                      .firstWhere((e) => e.value == value)
                                      .key;
                                  cubit.setPriority(canonical);
                                },
                              );
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

                    SizedBox(height: 20.h),

                    // ========================= Milestones =========================
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
                              onDatePicked: (date) => cubit.setDeadline(date),
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
                                      context
                                          .read<UpdateProjectCubit>()
                                          .setAssignTo(selected.id);
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

                            // ✅ زر Add Milestone
                            InkWell(
                              onTap: () {
                                if (_milestoneFormKey.currentState!
                                    .validate()) {
                                  // ✅ state بدل cubit
                                  if (cubit.state.selectedAssignTo == null) {
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
                                  cubit.addMilestone(
                                    MilestoneModel(
                                      title:
                                          cubit.milestoneTitleController.text,
                                      deadline: cubit.dueDateController.text,
                                      budgetAllocation:
                                          double.tryParse(
                                            cubit
                                                .budgetAllocationController
                                                .text,
                                          ) ??
                                          0,
                                      assignTo:
                                          cubit.state.selectedAssignTo!, // ✅
                                      deliverables:
                                          cubit.deliverablesDecController.text,
                                    ),
                                  );
                                  cubit.clearMilestoneFields();
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
                                        .copyWith(
                                          color: AppColor.k1primeryColor,
                                        ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 20.h),

                            // ✅ قائمة الـ Milestones
                            BlocBuilder<UpdateProjectCubit, UpdateProjectState>(
                              buildWhen: (prev, curr) =>
                                  prev.milestones != curr.milestones,
                              builder: (context, state) {
                                if (state.milestones.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: state.milestones.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 10.h),
                                  itemBuilder: (context, index) {
                                    final m = state.milestones[index]; // ✅
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 24.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColor.gray5,
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
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
                                                onTap: () => context
                                                    .read<UpdateProjectCubit>()
                                                    .removeMilestone(index),
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
      ),
    );
  }
}
