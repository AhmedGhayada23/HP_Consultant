import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/change_passsword_cubit/change_passsword_state.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ChangePassswordCubit extends Cubit<ChangePassswordState> {
  ChangePassswordCubit() : super(ChangePassswordState());

  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  Future<void> changePassword({
    required BuildContext context,
  }) async {
    emit(state.copyWith(isLoading: true));

    try {
      await UseCases.getProfileUsecase.changePassword(
        context: context,
        previousPassword: currentPassController.text,
        newPassword: newPassController.text,

      );
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    currentPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    return super.close();
  }
}
