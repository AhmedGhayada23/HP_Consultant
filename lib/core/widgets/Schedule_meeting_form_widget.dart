import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/schedule_interview_cubit/schedule_interview_cubit.dart';
import 'package:hb/core/cubit/schedule_interview_cubit/schedule_interview_state.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:hb/utils/validators.dart';

class ScheduleMeetingFormWidget extends StatefulWidget {
  final int applicationId;
  const ScheduleMeetingFormWidget({super.key, required this.applicationId});

  @override
  State<ScheduleMeetingFormWidget> createState() => _ScheduleMeetingFormWidgetState();
}

class _ScheduleMeetingFormWidgetState extends State<ScheduleMeetingFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _linkController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      _dateController.text =
          '${picked.year}-${_two(picked.month)}-${_two(picked.day)}';
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      _timeController.text = '${_two(picked.hour)}:${_two(picked.minute)}';
    }
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<ScheduleInterviewCubit>().scheduleInterview(
          applicationId: widget.applicationId,
          meetingTitle: _titleController.text.trim(),
          meetingDate: _dateController.text.trim(),
          meetingTime: _timeController.text.trim(),
          meetingLink: _linkController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 24.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(loc.schedule_meeting, style: MyTextStyle().textStyleSemiBold20()),
              DashedLine(),
              SizedBox(height: 16.h),

              MyTextFieldWidget(
                controller: _titleController,
                hintText: loc.meeting_title,
                validator: (v) => Validators.required(v, context),
              ),
              SizedBox(height: 20.h),

              MyTextFieldWidget(
                controller: _dateController,
                hintText: loc.meeting_date,
                showIcon: true,
                assetsIcon: AppSvg.deadlineSvg,
                readOnly: true,
                onTap: _pickDate,
                validator: (v) => Validators.required(v, context),
              ),
              SizedBox(height: 16.h),

              MyTextFieldWidget(
                controller: _timeController,
                hintText: loc.meeting_time,
                showIcon: true,
                assetsIcon: AppSvg.timeSvg,
                readOnly: true,
                onTap: _pickTime,
                validator: (v) => Validators.required(v, context),
              ),
              SizedBox(height: 16.h),

              MyTextFieldWidget(
                controller: _linkController,
                hintText: loc.meeting_link,
                keyboardType: TextInputType.url,
                validator: (v) => Validators.required(v, context),
              ),
              SizedBox(height: 16.h),

              BlocConsumer<ScheduleInterviewCubit, ScheduleInterviewState>(
                listener: (context, state) {
                  if (state.success == true) {
                    Navigator.pop(context); // اغلق فورم الجدولة
                    showRequestSubmittedDialog(
                      context,
                      title: 'Interview Scheduled',
                      subTitle:
                          'The interview invitation has been sent successfully.',
                      textBtn: 'Done',
                    );
                  } else if (state.success == false &&
                      state.errorMessage != null) {
                    showCustomSnackBar(
                        context, state.errorMessage!, SnackBarType.error);
                  }
                },
                builder: (context, state) {
                  if (state.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: AppColor.k1primeryColor),
                    );
                  }
                  return CustomButton(
                    onTap: () => _submit(context),
                    color: AppColor.k1primeryColor,
                    text: loc.submit,
                  );
                },
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
