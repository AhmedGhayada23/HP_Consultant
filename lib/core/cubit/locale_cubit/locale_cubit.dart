import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // للحصول على window.locale

import 'package:hb/core/config/storage/local_storage.dart';
import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleState(Locale('ar'))) {
    _init();
  }

  void _init() {
    // اللغة المحفوظة للمستخدم لها الأولوية، وإلا لغة الجهاز (ar/en فقط)
    final saved = LocalStorage().readValue<String>('lang');
    String code;
    if (saved == 'ar' || saved == 'en') {
      code = saved!;
    } else {
      final deviceLocale = window.locale;
      code = (deviceLocale.languageCode == 'ar' ||
              deviceLocale.languageCode == 'en')
          ? deviceLocale.languageCode
          : 'ar';
      LocalStorage().writeValue('lang', code);
    }
    emit(LocaleState(Locale(code)));
  }

  void changeLocale(String code) {
    // احفظ اللغة لتُرسَل في هيدر الريكوستات (Accept-Language) وتبقى بعد إعادة التشغيل
    LocalStorage().writeValue('lang', code);
    emit(LocaleState(Locale(code)));
  }
}
