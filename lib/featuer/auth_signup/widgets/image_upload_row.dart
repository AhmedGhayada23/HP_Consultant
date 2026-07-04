import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/auth_signup_cubit/auth_signup_cubit.dart';
import 'package:hb/core/cubit/auth_signup_cubit/auth_signup_state.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vector_graphics/vector_graphics.dart';

class ImageUploadRow extends StatelessWidget {
  final String title;
  final VoidCallback? onEditTap;
  final VoidCallback? onUploadTap;

  const ImageUploadRow({super.key, required this.title, this.onEditTap, this.onUploadTap});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthSignupCubit>();
    return BlocBuilder<AuthSignupCubit, AuthSignupState>(
      builder: (context, state) {
        return Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 90.w,
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: AppColor.gray1,
                    shape: BoxShape.circle,
                    image: cubit.selectedImage != null
                        ? DecorationImage(image: FileImage(cubit.selectedImage!))
                        : null,
                    border: Border.all(width: 1.w, color: AppColor.borderColor),
                  ),
                ),
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: GestureDetector(
                    onTap: () {
                      cubit.pickImage(ImageSource.gallery);
                    },
                    child: Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: const Color.fromARGB(0, 0, 12, 33))],
                      ),
                      child: Center(child: VectorGraphic(loader: AssetBytesLoader(AppSvg.editSvg))),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title ${AppLocalizations.of(context)!.image}',
                    style: MyTextStyle().textStyleMedium16(),
                  ),
                  SizedBox(height: 4.h),
                  GestureDetector(
                    onTap: () {
                      cubit.pickImage(ImageSource.gallery);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.upload_image,
                      style: MyTextStyle().textStyleMedium16().copyWith(
                        color: AppColor.uploadImageColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
