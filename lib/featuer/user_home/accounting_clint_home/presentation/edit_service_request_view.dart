import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/edit_service_request_cubit/edit_service_request_cubit.dart';
import 'package:hb/core/cubit/edit_service_request_cubit/edit_service_request_state.dart';
import 'package:hb/core/cubit/service_request_details_cubit/service_request_details_cubit.dart';
import 'package:hb/core/cubit/service_request_details_cubit/service_request_details_state.dart';
import 'package:hb/core/data/models/service_request_item_model.dart';
import 'package:hb/featuer/file_web_view/file_web_view.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/date_picker_field.dart';
import 'package:hb/core/widgets/file_picker_field.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:hb/utils/validators.dart';

class EditServiceRequestView extends StatefulWidget {
  final int requestId;
  final VoidCallback onSaved;
  const EditServiceRequestView({
    super.key,
    required this.requestId,
    required this.onSaved,
  });

  @override
  State<EditServiceRequestView> createState() => _EditServiceRequestViewState();
}

class _EditServiceRequestViewState extends State<EditServiceRequestView> {
  final _formKey = GlobalKey<FormState>();
  bool _prefilled = false; // لمنع تكرار التعبئة

  // تعبئة حقول التعديل من التفاصيل المجلوبة (مرة واحدة)
  void _prefill(ServiceRequestItemModel data) {
    if (_prefilled) return;
    _prefilled = true;
    final cubit = context.read<EditServiceRequestCubit>();
    cubit.deadlineController.text = data.preferredDeadline;
    cubit.budgetController.text =
        data.proposedBudget.replaceAll(RegExp(r'[^\d.]'), '');
    cubit.descriptionController.text = data.description;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = context.read<EditServiceRequestCubit>();
    return BlocProvider<ServiceRequestDetailsCubit>(
      create: (_) =>
          ServiceRequestDetailsCubit(requestId: widget.requestId)
            ..fetchDetails(),
      child: BlocConsumer<ServiceRequestDetailsCubit, ServiceRequestDetailsState>(
        listenWhen: (prev, curr) => prev.data != curr.data,
        listener: (context, dState) {
          if (dState.data != null) _prefill(dState.data!);
        },
        builder: (context, dState) {
          final bool loadingDetails = dState.loading || dState.data == null;
          return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        title: Text(
          loc.edit_request,
          style: MyTextStyle().textStyleSemiBold20().copyWith(
            color: AppColor.whiteColor,
          ),
        ),
      ),
      bottomNavigationBar:
          BlocConsumer<EditServiceRequestCubit, EditServiceRequestState>(
            listenWhen: (prev, curr) => curr.success && !prev.success,
            listener: (context, state) {
              widget.onSaved();
              showRequestSubmittedDialog(
                context,
                title: loc.request_updated,
                subTitle: loc.service_request_updated_subtitle,
                textBtn: loc.done,
                onDone: () => Navigator.pop(context),
              );
            },
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
                              cubit.updateRequest(context, widget.requestId);
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
        child: Skeletonizer(
          enabled: loadingDetails,
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
                  DatePickerField(
                    controller: cubit.deadlineController,
                    label: loc.deadline,
                    onDatePicked: (pickedDate) {
                      cubit.setDeadline(pickedDate);
                    },
                  ),
                  SizedBox(height: 16.h),
                  MyTextFieldWidget(
                    controller: cubit.budgetController,
                    hintText: loc.budget,
                    keyboardType: TextInputType.number,
                    validator: (value) => Validators.required(value, context),
                  ),
                  SizedBox(height: 16.h),
                  MyTextFieldWidget(
                    controller: cubit.descriptionController,
                    hintText: loc.description,
                    maxLines: 7,
                    validator: (value) => Validators.required(value, context),
                  ),
                  SizedBox(height: 16.h),
                  FilePickerField(
                    controller: TextEditingController(),
                    label: loc.supporting_document,
                    assetIcon: AppSvg.uplodeSvg,
                    allowMultiple: true,
                    allowedExtensions: const ['pdf'],
                    // المرفق اختياري عند التعديل (توجد ملفات حالية)
                    validator: (_) => null,
                    onFilesPicked: (files) => cubit.setFiles(files),
                  ),
                  // الملفات الموجودة مسبقاً (عرض + حذف محلي)
                  if ((dState.data?.requestFiles ?? []).isNotEmpty)
                    BlocBuilder<EditServiceRequestCubit, EditServiceRequestState>(
                      builder: (context, _) {
                        final files = dState.data!.requestFiles
                            .where((f) => !cubit.removedFileIds.contains(f.fileId))
                            .toList();
                        if (files.isEmpty) return const SizedBox.shrink();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            Text(loc.current_files,
                                style: MyTextStyle().textStyleMedium14()),
                            SizedBox(height: 8.h),
                            ...files.map(
                              (f) => Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Container(
                                  padding: EdgeInsets.all(12.r),
                                  decoration: BoxDecoration(
                                    color: AppColor.gray5,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.insert_drive_file_outlined,
                                          color: AppColor.k1primeryColor,
                                          size: 24.r),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Text(
                                          f.fileName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              MyTextStyle().textStyleRegular14(),
                                        ),
                                      ),
                                      // عرض
                                      InkWell(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => FileWebViewPage(
                                              fileName: f.fileName,
                                              fileUrl: f.url,
                                            ),
                                          ),
                                        ),
                                        child: Icon(Icons.visibility_outlined,
                                            color: AppColor.k1primeryColor,
                                            size: 22.r),
                                      ),
                                      SizedBox(width: 12.w),
                                      // حذف محلي (يُرسل عند الحفظ)
                                      InkWell(
                                        onTap: () =>
                                            cubit.removeExistingFile(f.fileId),
                                        child: Icon(Icons.delete_outline,
                                            color: Colors.red, size: 22.r),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
          );
        },
      ),
    );
  }
}
