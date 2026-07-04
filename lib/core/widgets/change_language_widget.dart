import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/local_storage.dart';
import 'package:hb/core/cubit/locale_cubit/locale_cubit.dart';
import 'package:hb/core/navigation/app_navigator.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:vector_graphics/vector_graphics.dart';


class ChangeLanguageWidget extends StatefulWidget {
  const ChangeLanguageWidget({super.key});

  @override
  State<ChangeLanguageWidget> createState() => _ChangeLanguageWidgetState();
}

class _ChangeLanguageWidgetState extends State<ChangeLanguageWidget> {
  String? _selectedCode;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocaleCubit>();
    final currentCode = cubit.state.locale.languageCode;

    // الافتراضي يظهر اللغة الحالية
    _selectedCode ??= currentCode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 24.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
           AppLocalizations.of(context)!.choose_language,
            style: MyTextStyle().textStyleSemiBold16(),
          ),
          DashedLine(),
          SizedBox(height: 20.h),

          // English
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: ListTile(
              leading: Radio<String>(
                value: 'en',
                groupValue: _selectedCode,
                onChanged: (value) {
                  setState(() {
                    _selectedCode = value;
                  });
                },
                activeColor: AppColor.k1primeryColor,
              ),
              title: Text(
                'English',
                style: MyTextStyle().textStyleRegular16(),
              ),
              trailing: VectorGraphic(
                loader: AssetBytesLoader(AppSvg.englandSvg),
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // Arabic
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: ListTile(
              leading: Radio<String>(
                value: 'ar',
                groupValue: _selectedCode,
                onChanged: (value) {
                  setState(() {
                    _selectedCode = value;
                  });
                },
                activeColor: AppColor.k1primeryColor,
              ),
              title: Text(
                'العربية',
                style: MyTextStyle().textStyleRegular16(),
              ),
              trailing: VectorGraphic(
                loader: AssetBytesLoader(AppSvg.arabicSvg),
              ),
            ),
          ),

          SizedBox(height: 32.h),

          // Submit button
          CustomButton(
            onTap: () async {
              if (_selectedCode == null) return;
              final code = _selectedCode!;
              // لو نفس اللغة الحالية، فقط أغلق
              if (code == currentCode) {
                Navigator.pop(context);
                return;
              }
              cubit.changeLocale(code);
              Navigator.pop(context); // إغلاق شيت اختيار اللغة

              // نص "جاري التجهيز" حسب اللغة الجديدة
              final message = code == 'ar' ? 'جاري التجهيز...' : 'Preparing...';

              // بوب-أب الشعار + التحميل، ثم إعادة تشغيل التطبيق
              final ctx = navigatorKey.currentContext;
              if (ctx == null) return;
              showLanguageSwitchLoader(ctx, message: message);
              await Future.delayed(const Duration(milliseconds: 1600));

              // إعادة بناء كل الشاشات باللغة الجديدة: مسح ستاك التنقّل
              // (يشمل البوب-أب) والعودة لمسار البداية حسب حالة الدخول
              final nav = navigatorKey.currentState;
              if (nav == null) return;
              final token = LocalStorage().readValue<String>(Constants.token);
              final route = (token != null && token.isNotEmpty)
                  ? MyRoutes().userView
                  : MyRoutes().authSiginIn;
              nav.pushNamedAndRemoveUntil(route, (r) => false);
            },
            color: AppColor.k1primeryColor,
            text: AppLocalizations.of(context)!.submit,
          ),
        ],
      ),
    );
  }
}
