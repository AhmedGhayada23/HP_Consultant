import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/utils/validators.dart';

class FilePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? assetIcon;
  final bool allowMultiple;
  final List<String>? allowedExtensions;
  final void Function(PlatformFile pickedFile)? onFilePicked;
  final void Function(List<PlatformFile> pickedFiles)? onFilesPicked;

  /// مُحقّق مخصّص؛ إن لم يُمرّر يكون الحقل مطلوباً افتراضياً
  final String? Function(String?)? validator;

  const FilePickerField({
    super.key,
    required this.controller,
    this.label = "Select File",
    this.assetIcon,
    this.allowMultiple = false,
    this.allowedExtensions,
    this.onFilePicked,
    this.onFilesPicked,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            allowMultiple: allowMultiple,
            type: allowedExtensions != null ? FileType.custom : FileType.any,
            allowedExtensions: allowedExtensions,
          );

          if (result != null && result.files.isNotEmpty) {
            if (onFilesPicked != null) {
              controller.text = result.files.map((f) => f.name).join(', ');
              onFilesPicked!(result.files);
            } else {
              final file = result.files.first;
              controller.text = file.name;
              if (onFilePicked != null) {
                onFilePicked!(file);
              }
            }
          }
        } catch (e) {
          debugPrint("Error picking file: $e");
        }
      },
      child: AbsorbPointer(
        child: MyTextFieldWidget(
          controller: controller,
          hintText: label,
          showIcon: true,
          assetsIcon: AppSvg.uplodeSvg,
          validator: validator ?? (value) => Validators.required(value, context),
          readOnly: true, // اجعل الـ TextField للعرض فقط
        ),
      ),
    );
  }
}
