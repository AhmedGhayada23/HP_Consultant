import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/local_storage.dart';
import 'package:hb/core/cubit/profile_cubit/profile_cubit.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/my_text_field_password_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';

class DeleteAccountWidget extends StatefulWidget {
  const DeleteAccountWidget({super.key});

  @override
  State<DeleteAccountWidget> createState() => _DeleteAccountWidgetState();
}

class _DeleteAccountWidgetState extends State<DeleteAccountWidget> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    if (_loading) return;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final ok = await context
        .read<ProfileCubit>()
        .deleteAccount(password: _passwordController.text.trim());
    if (!mounted) return;
    if (ok) {
      // نفس آلية تسجيل الخروج: حذف التوكن والانتقال لتسجيل الدخول
      LocalStorage().removeKey(Constants.token);
      Navigator.pushNamedAndRemoveUntil(
        context,
        MyRoutes().authSiginIn,
        (route) => true,
      );
    } else {
      setState(() => _loading = false);
      final msg = context.read<ProfileCubit>().state.errorMessage;
      showCustomSnackBar(
        context,
        (msg ?? '').replaceAll('Exception:', '').trim(),
        SnackBarType.error,
        alignTop: true, // فوق الـ bottom sheet
      );
    }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              loc.delete_account,
              style: MyTextStyle().textStyleSemiBold16(),
            ),
            SizedBox(height: 20.h),
            DashedLine(),
            SizedBox(height: 20.h),
            Text(
              loc.delete_account_desc,
              style: MyTextStyle().textStyleRegular16(),
            ),
            SizedBox(height: 20.h),
            // كلمة المرور مطلوبة لتأكيد الحذف
            MyTextFieldPasswordWidget(
              controller: _passwordController,
              hintText: loc.password,
              validator: (value) => Validators.required(value, context),
            ),
            SizedBox(height: 20.h),
            _loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColor.k1primeryColor,
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onTap: () => Navigator.pop(context),
                          color: AppColor.k1primeryColor,
                          text: loc.keep_account,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: CustomButtonBorder(
                          onTap: _deleteAccount,
                          borderColor: AppColor.countNotificationBgColor,
                          text: loc.delete_account,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
