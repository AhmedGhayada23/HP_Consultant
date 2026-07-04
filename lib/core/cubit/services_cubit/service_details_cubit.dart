import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/services_cubit/service_details_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ServiceDetailsCubit extends Cubit<ServiceDetailsState> {
  final int serviceId;

  ServiceDetailsCubit({required this.serviceId})
      : super(ServiceDetailsState(loading: false));

  Future<void> fetchDetails() async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final service = await UseCases.getServiceDetailsUsecase(serviceId);
      emit(state.copyWith(service: service, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
