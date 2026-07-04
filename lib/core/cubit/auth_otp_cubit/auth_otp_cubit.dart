import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/auth_otp_cubit/auth_otp_state.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/service_locator/usecases.dart';

class AuthOtpCubit extends Cubit<AuthOtpState> {
  AuthOtpCubit() : super(AuthOtpState());

  void sentOtp({required BuildContext context, required String email, required String type}) async {
    emit(state.copyWith(isSentOtpLoading: true));
    try {
      await UseCases.getAuthUseCase.sendActivationCode(context: context, email: email, type: type);
      emit(state.copyWith(isSentOtpLoading: false, sentOtpSuccess: true));
      showCustomSnackBar(context, 'OTP sent successfully!', SnackBarType.success);
      // إغلاق/تنقّل فقط عند النجاح
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      // عند الخطأ: ابقَ في نفس الصفحة (الرسالة تُعرض من الـ datasource)
      emit(
        state.copyWith(isSentOtpLoading: false, sentOtpSuccess: false, errorMessage: e.toString()),
      );
    }
  }

  void checkOtp({
    required BuildContext context,
    required String email,
    required String code,
    required String type,
  }) async {
    emit(state.copyWith(isCheckOtpLoading: true));
    try {
      await UseCases.getAuthUseCase.chackActivationCode(context: context, code: code, email: email, type: type);
      emit(state.copyWith(isCheckOtpLoading: false, chekOtpSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(isCheckOtpLoading: false, chekOtpSuccess: false, errorMessage: e.toString()),
      );
    }
  }
   void forgetPasswordCheckOtp({
    required BuildContext context,
    required String email,
    required String code,
  }) async {
    emit(state.copyWith(isCheckOtpLoading: true));
    try {
      await UseCases.getAuthUseCase.forgetPasswordChackCode(context: context, code: code, email: email);
      emit(state.copyWith(isCheckOtpLoading: false, chekOtpSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(isCheckOtpLoading: false, chekOtpSuccess: false, errorMessage: e.toString()),
      );
    }
  }

  void forgetPasswordSendCode({required BuildContext context, required String email}) async {
    emit(state.copyWith(isSentOtpLoading: true));
    try {
      await UseCases.getAuthUseCase.forgetPasswordSendCode(context: context, email: email);
      emit(state.copyWith(isSentOtpLoading: false, sentOtpSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSentOtpLoading: false, errorMessage: e.toString()));
    }
  }
}
