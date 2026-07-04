import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/consultant_meeting_request_cubit/consultant_meeting_request_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ConsultantMeetingRequestCubit extends Cubit<ConsultantMeetingRequestState> {
  ConsultantMeetingRequestCubit() : super(ConsultantMeetingRequestState());

  Future<void> fetchConsultantMeetingRequest({
    String? category,
    String? status,
    String? name,
  }) async {
    emit(state.copyWith(loading: true));

    try {
      final data = await UseCases.getConsultantMeetingRequestUsecase(
        category: category,
        status: status,
        name: name
      );
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
