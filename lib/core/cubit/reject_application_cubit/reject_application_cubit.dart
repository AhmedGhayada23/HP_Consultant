import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/reject_application_cubit/reject_application_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class RejectApplicationCubit extends Cubit<RejectApplicationState> {
  RejectApplicationCubit() : super(RejectApplicationState());

  Future<void> rejectApplication(int applicationId) async {
    emit(state.copyWith(isLoading: true, success: null, errorMessage: null));
    try {
      await UseCases.rejectApplicationUsecase.call(applicationId);
      emit(state.copyWith(isLoading: false, success: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, success: false, errorMessage: e.toString()));
    }
  }
}
