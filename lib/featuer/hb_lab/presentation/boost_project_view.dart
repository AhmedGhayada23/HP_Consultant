import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/core/cubit/boost_project_cubit/boost_project_cubit.dart';
import 'package:hb/core/cubit/boost_project_cubit/boost_project_state.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/data/models/skills_model.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/date_picker_field.dart';
import 'package:hb/core/widgets/file_picker_field.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:hb/utils/validators.dart';

class BoostProjectView extends StatefulWidget {
  const BoostProjectView({super.key});

  @override
  State<BoostProjectView> createState() => _BoostProjectViewState();
}

class _BoostProjectViewState extends State<BoostProjectView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = context.read<BoostProjectCubit>();
    return BlocListener<BoostProjectCubit, BoostProjectState>(
      listenWhen: (prev, curr) => curr.success && !prev.success,
      listener: (context, state) {
        showRequestSubmittedDialog(
          context,
          title: loc.project_submitted,
          subTitle: loc.boost_request_submitted,
          textBtn: loc.done,
          onDone: () => Navigator.of(context).pop(),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.blackColor,
          iconTheme: IconThemeData(color: AppColor.whiteColor),
          title: Text(
            loc.boost_your_project,
            style: MyTextStyle().textStyleSemiBold20().copyWith(
              color: AppColor.whiteColor,
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<BoostProjectCubit, BoostProjectState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: state.loading
                  ? CircleAvatar(
                      key: const ValueKey('loader'),
                      radius: 32.r,
                      backgroundColor: AppColor.k1primeryColor,
                      child: CircularProgressIndicator(
                        color: AppColor.whiteColor,
                      ),
                    )
                  : Container(
                      key: const ValueKey('btn'),
                      height: 100.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: CustomButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            cubit.boostProject(context);
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
                  MyTextFieldWidget(
                    controller: cubit.titleController,
                    hintText: loc.project_title,
                    validator: (v) => Validators.required(v, context),
                  ),
                  SizedBox(height: 16.h),
                  CustomDropdown(
                    hint: loc.select_tags,
                    isMultiSelect: true,
                    skillItems: [
                      SkillsModel(id: '1', name: 'AI / NLP', nameAr: 'الذكاء الاصطناعي / معالجة اللغة'),
                      SkillsModel(id: '2', name: 'CRM', nameAr: 'إدارة علاقات العملاء'),
                      SkillsModel(id: '3', name: 'Artificial Intelligence', nameAr: 'الذكاء الاصطناعي'),
                      SkillsModel(id: '4', name: 'FinTech', nameAr: 'التكنولوجيا المالية'),
                      SkillsModel(id: '5', name: 'Data Science', nameAr: 'علم البيانات'),
                      SkillsModel(id: '6', name: 'Blockchain', nameAr: 'بلوكتشين'),
                      SkillsModel(id: '7', name: 'Cloud Computing', nameAr: 'الحوسبة السحابية'),
                      SkillsModel(id: '8', name: 'Cybersecurity', nameAr: 'الأمن السيبراني'),
                      SkillsModel(id: '9', name: 'IoT', nameAr: 'إنترنت الأشياء'),
                      SkillsModel(id: '10', name: 'Mobile Development', nameAr: 'تطوير الجوال'),
                    ],
                    selectedSkills: cubit.selectedCategoryTags,
                    onMultiChanged: (values) {
                      cubit.selectedCategoryTags = values;
                    },
                  ),
                  SizedBox(height: 16.h),
                  MyTextFieldWidget(
                    controller: cubit.budgetController,
                    hintText: loc.budget_range,
                    validator: (v) => Validators.required(v, context),
                  ),
                  SizedBox(height: 16.h),
                  DatePickerField(
                    controller: cubit.deadlineController,
                    label: loc.deadline,
                    onDatePicked: (date) => cubit.setDeadline(date),
                  ),
                  SizedBox(height: 16.h),
                  MyTextFieldWidget(
                    controller: cubit.goalsController,
                    hintText: loc.goals_deliverables,
                    maxLines: 3,
                    validator: (v) => Validators.required(v, context),
                  ),
                  SizedBox(height: 16.h),
                  FilePickerField(
                    controller: cubit.supportingController,
                    label: loc.attachment,
                    assetIcon: AppSvg.uplodeSvg,
                    allowedExtensions: ['pdf'],
                    onFilePicked: (file) => cubit.setAttachmentPath(file.path),
                  ),
                  SizedBox(height: 16.h),
                  MyTextFieldWidget(
                    controller: cubit.descriptionController,
                    hintText: loc.project_description,
                    maxLines: 5,
                    validator: (v) => Validators.required(v, context),
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
