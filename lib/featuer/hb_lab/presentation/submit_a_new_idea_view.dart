import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/core/cubit/new_idea_cubit/new_idea_cubit.dart';
import 'package:hb/core/cubit/new_idea_cubit/new_idea_state.dart';
import 'package:hb/core/data/models/skills_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/file_picker_field.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:hb/utils/validators.dart';

class SubmitANewIdeaView extends StatefulWidget {
  const SubmitANewIdeaView({super.key});

  @override
  State<SubmitANewIdeaView> createState() => _SubmitANewIdeaViewState();
}

class _SubmitANewIdeaViewState extends State<SubmitANewIdeaView> {
  final _formKey = GlobalKey<FormState>();

  static final _tagItems = [
    SkillsModel(
      id: '1',
      name: 'AI / NLP',
      nameAr: 'الذكاء الاصطناعي / معالجة اللغة',
    ),
    SkillsModel(id: '2', name: 'CRM', nameAr: 'إدارة علاقات العملاء'),
    SkillsModel(
      id: '3',
      name: 'Artificial Intelligence',
      nameAr: 'الذكاء الاصطناعي',
    ),
    SkillsModel(id: '4', name: 'FinTech', nameAr: 'التكنولوجيا المالية'),
    SkillsModel(id: '5', name: 'Data Science', nameAr: 'علم البيانات'),
    SkillsModel(id: '6', name: 'Blockchain', nameAr: 'بلوكتشين'),
    SkillsModel(id: '7', name: 'Cloud Computing', nameAr: 'الحوسبة السحابية'),
    SkillsModel(id: '8', name: 'Cybersecurity', nameAr: 'الأمن السيبراني'),
    SkillsModel(id: '9', name: 'IoT', nameAr: 'إنترنت الأشياء'),
    SkillsModel(id: '10', name: 'Payroll', nameAr: 'الرواتب'),
  ];

  static const _confidentialityItems = ['public', 'internal', 'confidential'];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = context.read<NewIdeaCubit>();
    return BlocListener<NewIdeaCubit, NewIdeaState>(
      listenWhen: (prev, curr) => curr.success && !prev.success,
      listener: (context, state) {
        showRequestSubmittedDialog(
          context,
          title: loc.idea_submitted,
          subTitle: loc.idea_submitted_subtitle,
          textBtn: loc.done,
          onDone: () => Navigator.of(context).pop(),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.blackColor,
          iconTheme: IconThemeData(color: AppColor.whiteColor),
          title: Text(
            loc.submit_a_new_idea,
            style: MyTextStyle().textStyleSemiBold20().copyWith(
              color: AppColor.whiteColor,
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<NewIdeaCubit, NewIdeaState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: state.loading
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
                      key: const ValueKey('btn'),
                      height: 100.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      color: AppColor.whiteColor,
                      child: CustomButton(
                        color: AppColor.k1primeryColor,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            cubit.newIdea(context);
                          }
                        },
                        text: loc.submit,
                        textColor: AppColor.whiteColor,
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
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: AppColor.whiteColor,
                    ),
                    child: Column(
                      children: [
                        MyTextFieldWidget(
                          controller: cubit.titleController,
                          hintText: loc.idea_title,
                          validator: (value) =>
                              Validators.required(value, context),
                        ),
                        SizedBox(height: 16.h),
                        CustomDropdown(
                          hint: loc.select_tags,
                          isMultiSelect: true,
                          skillItems: _tagItems,
                          selectedSkills: cubit.selectedTags,
                          onMultiChanged: (values) {
                            cubit.selectedTags = values;
                          },
                        ),
                        SizedBox(height: 16.h),
                        CustomDropdown(
                          hint: loc.select_confidentiality,
                          items: _confidentialityItems,
                          selectedValue: cubit.confidentialityLevel,
                          onChanged: (value) {
                            cubit.confidentialityLevel = value;
                          },
                        ),
                        SizedBox(height: 16.h),
                        FilePickerField(
                          controller: cubit.supportingDocController,
                          label: loc.attachment,
                          assetIcon: AppSvg.uplodeSvg,
                          allowedExtensions: ['pdf'],
                          onFilePicked: (file) =>
                              cubit.setAttachmentPath(file.path),
                        ),
                        SizedBox(height: 16.h),
                        MyTextFieldWidget(
                          controller: cubit.updatedDescriptionController,
                          hintText: loc.idea_description,
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
