import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/details_consultant_meeting_request_cubit/details_consultant_meeting_request_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class DetailsConsultantMeetingRequestCubit extends Cubit<DetailsConsultantMeetingRequestState> {
  DetailsConsultantMeetingRequestCubit() : super(DetailsConsultantMeetingRequestState());

  Future<void> fetchDetailsConsultantMeetingRequest(int id) async {
    emit(state.copyWith(loading: true));

    try {
      final data = await UseCases.getDetailsConsultantMeetingRequestUsecase(id);
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> cancelMeetingRequest(BuildContext context, int id) async {
    await UseCases.getDetailsConsultantMeetingRequestUsecase.cancelMeetingRequest(context,id);
  }
}
