import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/core/cubit/reevaluate_project_cubit/reevaluate_project_cubit.dart';
import 'package:hb/core/cubit/reevaluate_project_cubit/reevaluate_project_state.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/file_picker_field.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/utils/validators.dart';

class ReevaluateProjectView extends StatefulWidget {
  const ReevaluateProjectView({super.key});

  @override
  State<ReevaluateProjectView> createState() => _ReevaluateProjectViewState();
}

class _ReevaluateProjectViewState extends State<ReevaluateProjectView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = context.read<ReevaluateProjectCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        title: Text(
          loc.reevaluate_project,
          style: MyTextStyle().textStyleSemiBold20().copyWith(
            color: AppColor.whiteColor,
          ),
        ),
      ),
      bottomNavigationBar:
          BlocBuilder<ReevaluateProjectCubit, ReevaluateProjectState>(
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
                          vertical: 16.h,
                        ),
                        color: AppColor.whiteColor,
                        child: CustomButton(
                          color: AppColor.k1primeryColor,
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              cubit.reevaluateProject(context);
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
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: 16.w,
              vertical: 32.h,
            ),

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
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: AppColor.gray1,
                        ),
                        child: Column(
                          children: [
                            InfoRow(
                              label: loc.job_title,
                              value: 'Backend API Developer',
                            ),
                            SizedBox(height: 16.h),
                            InfoRow(label: 'Project ID', value: 'PR5564'),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      CustomDropdown(hint: 'Desired Outcome', items: []),
                      SizedBox(height: 16.h),
                      FilePickerField(
                        controller: cubit.supportingDocController,
                        label: "Supporting Documents",
                        assetIcon: AppSvg.uplodeSvg,
                        allowedExtensions: ['pdf'],
                        onFilePicked: (file) {
                          // هنا تقدر تحدث الـ Cubit مباشرة
                          //  cubit.setJobFile(file);
                        },
                      ),

                      SizedBox(height: 16.h),
                      MyTextFieldWidget(
                        controller: cubit.reasonBoostController,
                        hintText: 'Reason for Boost',
                        maxLines: 5,
                        validator: (value) =>
                            Validators.required(value, context),
                      ),
                      SizedBox(height: 16.h),
                      MyTextFieldWidget(
                        controller: cubit.descriptionController,
                        hintText: 'Updated Description',
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
    );
  }
}
