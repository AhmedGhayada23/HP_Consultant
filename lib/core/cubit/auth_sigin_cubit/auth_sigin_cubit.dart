import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/auth_sigin_cubit/auth_sigin_state.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/network/network_info.dart';
import 'package:hb/core/service_locator/usecases.dart';

class AuthSiginCubit extends Cubit<AuthSiginState> {
  AuthSiginCubit() : super(AuthSiginState());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void toggleRememberMe(bool value) {
    emit(state.copyWith(remember: value));
  }

  void signIn(BuildContext context) async {
    final networkInfo = NetworkInfoImpl(Connectivity());
    final hasConnection = await networkInfo.isConnected;
    if (!hasConnection) {
      showCustomSnackBar(context, "لا يوجد اتصال بالإنترنت", SnackBarType.noConnection);
      return; // لازم توقف هنا
    }
    emit(state.copyWith(loading: true));
    try {
      await UseCases.getAuthUseCase.login(
        context: context,
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, success: false, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
