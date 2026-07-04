import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/services_cubit/services_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit() : super(ServicesState(loading: false));

  Future<void> fetchServices() async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.getServicesUsecase(
        search: state.search,
        status: state.status,
      );
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  // البحث بالعنوان
  void search(String value) {
    emit(state.copyWith(search: value));
    fetchServices();
  }

  // فلترة حسب الحالة ('all' = الكل)
  void setStatus(String value) {
    emit(state.copyWith(status: value));
    fetchServices();
  }
}
