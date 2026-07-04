import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/job_and_talent_cubit/job_and_talent_cubit.dart';
import 'package:hb/core/cubit/job_details_cubit/job_details_cubit.dart';
import 'package:hb/core/cubit/job_details_cubit/job_details_state.dart';
import 'package:hb/core/cubit/payment_types_cubit/payment_types_cubit.dart';
import 'package:hb/core/cubit/payment_types_cubit/payment_types_state.dart';
import 'package:hb/core/cubit/project_types_cubit/project_types_cubit.dart';
import 'package:hb/core/cubit/project_types_cubit/project_types_state.dart';
import 'package:hb/core/cubit/skills_cubit/skills_cubit.dart';
import 'package:hb/core/cubit/skills_cubit/skills_state.dart';
import 'package:hb/core/cubit/update_job_cubit/update_job_cubit.dart';
import 'package:hb/core/cubit/update_job_cubit/update_job_state.dart';
import 'package:hb/core/data/models/job_details_modle.dart';
import 'package:hb/core/data/models/jobs_model.dart';
import 'package:hb/core/data/models/skills_model.dart';
import 'package:hb/core/message/message_snack_bar.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/date_picker_field.dart';
import 'package:hb/core/widgets/file_picker_field.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/core/widgets/validateWidget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditJobView extends StatefulWidget {
  final JobsModel job;
  const EditJobView({super.key, required this.job});

  @override
  State<EditJobView> createState() => _EditJobViewState();
}

class _EditJobViewState extends State<EditJobView> {
  final _formKey = GlobalKey<FormState>();

  // الملفات الحالية (تُعبّأ مرة عند تحميل التفاصيل) + معرّفات المحذوفة محلياً
  List<JobFileModel>? _existingFiles;
  final List<int> _removedFileIds = [];

  @override
  initState() {
    super.initState();

    // ✅ عبّئ البيانات المتوفّرة فورًا من الكرت بدون انتظار تحميل التفاصيل
    final cubit = context.read<UpdateJobCubit>();
    cubit.titleController.text = widget.job.title;
    cubit.budgetMinController.text = _intStr(widget.job.budgetMin);
    cubit.budgetMaxController.text = _intStr(widget.job.budgetMax);
    if (widget.job.deadline.isNotEmpty) {
      final parsed = DateTime.tryParse(widget.job.deadline);
      if (parsed != null) {
        cubit.deadlineController.text =
            parsed.toLocal().toString().split(' ')[0];
        cubit.setDeadline(parsed);
      }
    }

    context.read<JobDetailsCubit>().fetchJobDetails(widget.job.id);
    context.read<SkillsCubit>().fetchSkills(); // ← أضف هذا
    context.read<ProjectTypesCubit>().fetchProjectTypes();
    context.read<PaymentTypesCubit>().fetchPaymentTypes();
  }

  // يحوّل "3500.00" إلى "3500" للعرض
  String _intStr(String value) =>
      (double.tryParse(value)?.toInt())?.toString() ?? value;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UpdateJobCubit>();

    return BlocListener<UpdateJobCubit, UpdateJobState>(
      listener: (context, state) {
        if (state.success == true) {
          // رسالة النجاح من السيرفر (message)
          if (state.message != null) {
            showCustomSnackBar(context, state.message!, SnackBarType.success);
          }
          context.read<JobAndTalentCubit>().fetchJobsAndTalent();
          Navigator.pop(context);
        } else if (state.errorMessage != null) {
          // رسالة الفشل من السيرفر (message)
          showCustomSnackBar(context, state.errorMessage!, SnackBarType.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.blackColor,
          iconTheme: IconThemeData(color: AppColor.whiteColor),
          title: Text(
            AppLocalizations.of(context)!.edit_job,
            style: MyTextStyle().textStyleSemiBold16().copyWith(color: AppColor.whiteColor),
          ),
        ),

        bottomNavigationBar: BlocBuilder<UpdateJobCubit, UpdateJobState>(
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
                      child: Center(child: CircularProgressIndicator(color: AppColor.whiteColor)),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
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
                            context.read<UpdateJobCubit>().updateJob(
                              jobId: widget.job.id,
                              jobData: {
                                'title': cubit.titleController.text,
                                'type': cubit.selectedJobType,
                                'budget_min': int.tryParse(cubit.budgetMinController.text) ?? 0,
                                'budget_max': int.tryParse(cubit.budgetMaxController.text) ?? 0,
                                'deadline': cubit.deadlineDate?.toIso8601String(),
                                'description': cubit.descriptionController.text,
                                'required_skills': context.read<SkillsCubit>().state.selectedSkills,
                                'project_type': context
                                    .read<ProjectTypesCubit>()
                                    .state
                                    .selectedProjectType,
                                'payment_type': context
                                    .read<PaymentTypesCubit>()
                                    .state
                                    .selectedPaymentType,
                                // معرّفات الملفات المحذوفة محلياً
                                'deleted_files': _removedFileIds,
                              },
                            );
                          }
                        },
                        color: AppColor.k1primeryColor,
                        text: AppLocalizations.of(context)!.save,
                      ),
                    ),
            );
          },
        ),

        body: BlocConsumer<JobDetailsCubit, JobDetailsState>(
          listener: (context, state) {
            if (state.jobDetails != null) {
              final job = state.jobDetails!;
              final skillsCubit = context.read<SkillsCubit>();
              cubit.titleController.text = job.title;
              // تحويل "700.00" → "700" حتى لا يرفضها التحقق (أرقام صحيحة فقط)
              cubit.budgetMinController.text = _intStr(job.budgetMin);
              cubit.budgetMaxController.text = _intStr(job.budgetMax);
              cubit.descriptionController.text = job.description;
              cubit.setJobType(job.type);
              if (job.deadline.isNotEmpty) {
                DateTime parsedDate = DateTime.tryParse(job.deadline) ?? DateTime.now();
                cubit.deadlineController.text = parsedDate.toLocal().toString().split(' ')[0];
                cubit.setDeadline(parsedDate);
              }
              context.read<PaymentTypesCubit>().setPaymentType(job.paymentType);
              // نوع المشروع (إن وُجد)
              if (job.projectType != null && job.projectType!.isNotEmpty) {
                context.read<ProjectTypesCubit>().setProjectType(job.projectType!);
              }
              // المهارات: نضبطها دائماً — fetchSkills يحافظ على selectedSkills
              // حتى لو وصلت تفاصيل الوظيفة قبل تحميل قائمة المهارات
              skillsCubit.setSkills(job.requiredSkills);

              // عبّئ قائمة الملفات الحالية مرة واحدة
              _existingFiles ??= [...job.files];
            }
          },
          builder: (context, state) => Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),

              child: SingleChildScrollView(
                child: Skeletonizer(
                  enabled: state.isLoading,
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
                          selectedValue: cubit.selectedJobType == 'full_time'
                              ? 'Full Time'
                              : 'Part Time',
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
                              // يُعاد إنشاؤه عند تحميل القائمة ليطبّق المهارات المختارة مسبقاً
                              key: ValueKey('skills_${skills.length}'),
                              hint: AppLocalizations.of(context)!.required_skills_multiselect,
                              isMultiSelect: true,
                              skillItems: skills,
                              selectedSkills: state.selectedSkills,
                              onMultiChanged: (selectedSkills) {
                                final skillsCubit = context.read<SkillsCubit>();
                                skillsCubit.setSkills(selectedSkills);
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
                              selectedValue: state.selectedProjectType,
                              items: useFallback
                                  ? fallback.keys.toList()
                                  : api.map((e) => e.name).toList(),
                              onChanged: (value) {
                                final projectTypesCubit =
                                    context.read<ProjectTypesCubit>();
                                if (useFallback) {
                                  projectTypesCubit
                                      .setProjectType(fallback[value]!);
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
                              selectedValue: state.selectedPaymentType,
                              items: useFallback
                                  ? fallback.keys.toList()
                                  : api.map((e) => e.name).toList(),
                              onChanged: (value) {
                                final paymentTypesCubit =
                                    context.read<PaymentTypesCubit>();
                                if (useFallback) {
                                  paymentTypesCubit
                                      .setPaymentType(fallback[value]!);
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
                        // اختياري عند التعديل إن وُجد ملف حالي أو تم اختيار ملف جديد
                        validator: (value) {
                          final hasExisting = _existingFiles?.isNotEmpty ?? false;
                          if (hasExisting || (value != null && value.isNotEmpty)) {
                            return null;
                          }
                          return Validators.required(value, context);
                        },
                        onFilePicked: (file) {
                          // هنا تقدر تحدث الـ Cubit مباشرة
                          cubit.setJobFile(file);
                          log('Selected file: $file');
                        },
                      ),

                      // الملفات الحالية للوظيفة (من الـ API) مع إمكانية الحذف
                      if (_existingFiles?.isNotEmpty ?? false) ...[
                        SizedBox(height: 12.h),
                        ..._existingFiles!.map(
                          (f) => Container(
                            margin: EdgeInsets.only(bottom: 8.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: AppColor.gray5,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: AppColor.borderColor),
                            ),
                            child: Row(
                              children: [
                                // أيقونة ملف داخل مربّع ملوّن
                                Container(
                                  width: 40.r,
                                  height: 40.r,
                                  decoration: BoxDecoration(
                                    color: AppColor.k1primeryColor
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Icon(Icons.picture_as_pdf_outlined,
                                      color: AppColor.k1primeryColor, size: 22.r),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    f.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: MyTextStyle().textStyleMedium14(),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                // زر حذف الملف (محلياً ثم يُرسَل عند الحفظ)
                                InkWell(
                                  borderRadius: BorderRadius.circular(8.r),
                                  onTap: () {
                                    setState(() {
                                      if (f.id != 0) _removedFileIds.add(f.id);
                                      _existingFiles!.remove(f);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(7.r),
                                    decoration: BoxDecoration(
                                      color: AppColor.countNotificationBgColor
                                          .withValues(alpha: 0.10),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(Icons.delete_outline,
                                        color: AppColor.countNotificationBgColor,
                                        size: 20.r),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

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
