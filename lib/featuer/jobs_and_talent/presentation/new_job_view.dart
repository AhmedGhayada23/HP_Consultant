import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/job_and_talent_cubit/job_and_talent_cubit.dart';
import 'package:hb/core/cubit/new_job_cubit/new_job_cubit.dart';
import 'package:hb/core/cubit/new_job_cubit/new_job_state.dart';
import 'package:hb/core/cubit/payment_types_cubit/payment_types_cubit.dart';
import 'package:hb/core/cubit/payment_types_cubit/payment_types_state.dart';
import 'package:hb/core/cubit/project_types_cubit/project_types_cubit.dart';
import 'package:hb/core/cubit/project_types_cubit/project_types_state.dart';
import 'package:hb/core/cubit/skills_cubit/skills_cubit.dart';
import 'package:hb/core/cubit/skills_cubit/skills_state.dart';
import 'package:hb/core/data/models/skills_model.dart';
import 'package:hb/core/message/message_snack_bar.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/date_picker_field.dart';
import 'package:hb/core/widgets/file_picker_field.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/core/widgets/validateWidget.dart';
import 'package:hb/featuer/jobs_and_talent/widgets/btn_new_post_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:hb/utils/validators.dart';

class NewJobView extends StatefulWidget {
  const NewJobView({super.key});

  @override
  State<NewJobView> createState() => _NewJobViewState();
}

class _NewJobViewState extends State<NewJobView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<SkillsCubit>().fetchSkills();
    context.read<ProjectTypesCubit>().fetchProjectTypes();
    context.read<PaymentTypesCubit>().fetchPaymentTypes();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NewJobCubit>();
    return BlocListener<NewJobCubit, NewJobState>(
      listener: (context, state) {
        if (state.success == true) {
          cubit.resetForm(context);
          showRequestSubmittedDialog(
            context,
            title: AppLocalizations.of(context)!.job_posted_successfully,
            subTitle: AppLocalizations.of(context)!.job_request_submitted,
            textBtn: AppLocalizations.of(context)!.done,
            onDone: () {
              context.read<JobAndTalentCubit>().fetchJobsAndTalent();
              Navigator.pop(context);
            },
          );
        }

        if (state.errorMassage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMassage!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.blackColor,
          iconTheme: IconThemeData(color: AppColor.whiteColor),
          title: Text(
            AppLocalizations.of(context)!.post_new_job,
            style: MyTextStyle().textStyleSemiBold16().copyWith(color: AppColor.whiteColor),
          ),
        ),

        bottomNavigationBar: BlocBuilder<NewJobCubit, NewJobState>(
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
                  : BtnNewPostWidget(
                      onTap: () {
                        log('Submit button tapped');
                        if (_formKey.currentState!.validate()) {
                          // منع تاريخ انتهاء في الماضي
                          final dl = cubit.deadlineDate;
                          final now = DateTime.now();
                          final today = DateTime(now.year, now.month, now.day);
                          if (dl == null || dl.isBefore(today)) {
                            showCustomSnackBar(
                              context,
                              AppLocalizations.of(context)!.deadline_must_be_future,
                              SnackBarType.error,
                            );
                            return;
                          }
                          log('Form is valid, proceed with submission');
                          context.read<NewJobCubit>().newJop(context);
                        }
                      },
                    ),
            );
          },
        ),

        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),

            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    MyTextFieldWidget(
                      controller: cubit.titleController,
                      hintText: AppLocalizations.of(context)!.title,

                      validator: (value) => Validators.required(value, context),
                    ),
                    SizedBox(height: 16.h),
                    ValidateWidget(
                      validator: (value) {
                        if (cubit.selectedJobType == null) {
                          return '${AppLocalizations.of(context)!.this_field} ${AppLocalizations.of(context)!.is_required}';
                        }
                        return null;
                      },
                      child: CustomDropdown(
                        hint: AppLocalizations.of(context)!.job_type, // أضف الترجمة
                        items: const ['Full Time', 'Part Time'],
                        onChanged: (value) {
                          cubit.setJobType(
                            value == 'Full Time' ? 'full_time' : 'part_time',
                          ); // أضف هذه الدالة في الـ Cubit
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),
                    MyTextFieldWidget(
                      controller: cubit.budgetMinController,
                      hintText: AppLocalizations.of(context)!.budget_min,
                      validator: (value) =>
                          Validators.positiveInteger(value, context), // 👈 بدل required
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.h),
                    MyTextFieldWidget(
                      controller: cubit.budgetMaxController,
                      hintText: AppLocalizations.of(context)!.budget_max,
                      validator: (value) =>
                          Validators.positiveInteger(value, context), // 👈 بدل required
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.h),
                    DatePickerField(
                      controller: cubit.deadlineController,
                      label: AppLocalizations.of(context)!.deadline,
                      firstDate: DateTime.now(), // منع التواريخ السابقة
                      onDatePicked: (pickedDate) {
                        // هنا تقدر تحدث الـ Cubit مباشرة
                        cubit.setDeadline(pickedDate);
                      },
                    ),
                    SizedBox(height: 16.h),
                    ValidateWidget(
                      validator: (value) {
                        final skillsCubit = context.read<SkillsCubit>();
                        if (skillsCubit.state.selectedSkills.isEmpty) {
                          return '${AppLocalizations.of(context)!.this_field} ${AppLocalizations.of(context)!.is_required}';
                        }
                        return null;
                      },
                      child: BlocBuilder<SkillsCubit, SkillsState>(
                        builder: (context, state) {
                          // عند فشل/غياب مهارات الـ API نعرض قائمة افتراضية مترجمة
                          final skills =
                              (state.skills == null || state.skills!.isEmpty)
                                  ? _fallbackSkills(context)
                                  : state.skills!;
                          return CustomDropdown(
                            hint: AppLocalizations.of(context)!.required_skills_multiselect,
                            isMultiSelect: true,
                            skillItems: skills,
                            onMultiChanged: (selectedSkills) {
                              final skillsCubit = context.read<SkillsCubit>();
                              skillsCubit.setSkills(selectedSkills); // أضف هذه الدالة في الـ Cubit
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ValidateWidget(
                      validator: (value) {
                        final projectTypesCubit = context.read<ProjectTypesCubit>();
                        if (projectTypesCubit.state.selectedProjectType == null) {
                          return '${AppLocalizations.of(context)!.this_field} ${AppLocalizations.of(context)!.is_required}';
                        }
                        return null;
                      },
                      child: BlocBuilder<ProjectTypesCubit, ProjectTypesState>(
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
                              final projectTypesCubit =
                                  context.read<ProjectTypesCubit>();
                              if (useFallback) {
                                projectTypesCubit.setProjectType(fallback[value]!);
                              } else {
                                final selected =
                                    api.firstWhere((e) => e.name == value);
                                projectTypesCubit.setProjectType(selected.name);
                              }
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ValidateWidget(
                      validator: (value) {
                        final paymentTypesCubit = context.read<PaymentTypesCubit>();
                        if (paymentTypesCubit.state.selectedPaymentType == null) {
                          return '${AppLocalizations.of(context)!.this_field} ${AppLocalizations.of(context)!.is_required}';
                        }
                        return null;
                      },
                      child: BlocBuilder<PaymentTypesCubit, PaymentTypesState>(
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
                              final paymentTypesCubit =
                                  context.read<PaymentTypesCubit>();
                              if (useFallback) {
                                paymentTypesCubit.setPaymentType(fallback[value]!);
                              } else {
                                final selected =
                                    api.firstWhere((e) => e.name == value);
                                paymentTypesCubit.setPaymentType(selected.value);
                              }
                            },
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 16.h),
                    FilePickerField(
                      controller: cubit.jobFileController,
                      label: AppLocalizations.of(context)!.job_files,
                      assetIcon: AppSvg.uplodeSvg,
                      allowedExtensions: ['pdf'],
                      onFilePicked: (file) {
                        // هنا تقدر تحدث الـ Cubit مباشرة
                        cubit.setJobFile(file);
                        log('Selected file: $file');
                      },
                    ),

                    SizedBox(height: 16.h),
                    MyTextFieldWidget(
                      controller: cubit.descriptionController,
                      validator: (value) => Validators.required(value, context),
                      hintText: AppLocalizations.of(context)!.description,
                      maxLines: 5,
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

  // مهارات افتراضية مترجمة عند فشل/غياب بيانات الـ API
  List<SkillsModel> _fallbackSkills(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    const en = [
      'Flutter',
      'React',
      'Node.js',
      'UI/UX Design',
      'Project Management',
      'Data Analysis',
      'Digital Marketing',
      'Content Writing',
    ];
    const ar = [
      'فلاتر',
      'رياكت',
      'Node.js',
      'تصميم واجهات',
      'إدارة المشاريع',
      'تحليل البيانات',
      'التسويق الرقمي',
      'كتابة المحتوى',
    ];
    return List.generate(
      en.length,
      (i) => SkillsModel(id: 'fb_$i', name: isAr ? ar[i] : en[i], nameAr: ar[i]),
    );
  }
}
