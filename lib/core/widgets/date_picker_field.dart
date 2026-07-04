import 'package:flutter/material.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/utils/validators.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final void Function(DateTime pickedDate)? onDatePicked;

  /// أقدم تاريخ يُسمح باختياره (مثلاً DateTime.now() لمنع التواريخ السابقة)
  final DateTime? firstDate;

  const DatePickerField({
    super.key,
    required this.controller,
    this.label = "Select Date",
    this.onDatePicked,
    this.firstDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        // نطبّع أقدم تاريخ ليكون بداية اليوم (بدون وقت) إن مرّر
        final DateTime first = firstDate != null
            ? DateTime(firstDate!.year, firstDate!.month, firstDate!.day)
            : DateTime(2000);
        final DateTime initial = now.isBefore(first) ? first : now;
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: first,
          lastDate: DateTime(2100),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  surface: AppColor.gray2,
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          controller.text = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
          if (onDatePicked != null) {
            onDatePicked!(pickedDate);
          }
        }
      },
      child: AbsorbPointer(
        child: MyTextFieldWidget(
          controller: controller,
          validator:(value)=> Validators.required(value, context),
          hintText: label,
          readOnly: true,
          showIcon: true,
          assetsIcon: AppSvg.deadlineSvg,
        ),
      ),
    );
  }
}
