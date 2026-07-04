import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/service_requests_list_cubit/service_requests_list_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ServiceRequestsListCubit extends Cubit<ServiceRequestsListState> {
  ServiceRequestsListCubit() : super(ServiceRequestsListState(loading: false));

  Future<void> fetchServiceRequests() async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.getServiceRequestsUsecase(
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
    fetchServiceRequests();
  }

  void setStatus(String value) {
    emit(state.copyWith(status: value));
    fetchServiceRequests();
  }
}
