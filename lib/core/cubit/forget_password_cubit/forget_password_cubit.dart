import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/forget_password_cubit/forget_password_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordState());

  void forgetPassword({
    required BuildContext context,
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(state.copyWith(isLoading: true));

    try {
      await UseCases.getAuthUseCase.forgetResetPassword(
        context: context,
        email: email,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
