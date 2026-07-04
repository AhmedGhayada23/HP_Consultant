import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/schedule_interview_cubit/schedule_interview_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ScheduleInterviewCubit extends Cubit<ScheduleInterviewState> {
  ScheduleInterviewCubit() : super(ScheduleInterviewState());

  Future<void> scheduleInterview({
    required int applicationId,
    required String meetingTitle,
    required String meetingDate,
    required String meetingTime,
    required String meetingLink,
  }) async {
    emit(state.copyWith(isLoading: true, success: null, errorMessage: null));
    try {
      await UseCases.scheduleInterviewUsecase.call(
        applicationId: applicationId,
        meetingTitle: meetingTitle,
        meetingDate: meetingDate,
        meetingTime: meetingTime,
        meetingLink: meetingLink,
      );
      emit(state.copyWith(isLoading: false, success: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, success: false, errorMessage: e.toString()));
    }
  }
}
