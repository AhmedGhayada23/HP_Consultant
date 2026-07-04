import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/consultant_requests_cubit/consultant_requests_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ConsultantRequestsCubit extends Cubit<ConsultantRequestsState> {
  ConsultantRequestsCubit() : super(ConsultantRequestsState(loading: false));

  Future<void> fetchConsultantRequests() async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.getConsultantRequestsUsecase(
        search: state.search,
        status: state.status,
      );
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  void search(String value) {
    emit(state.copyWith(search: value));
    fetchConsultantRequests();
  }

  void setStatus(String value) {
    emit(state.copyWith(status: value));
    fetchConsultantRequests();
  }
}
