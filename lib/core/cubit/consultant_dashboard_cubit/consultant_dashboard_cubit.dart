import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/consultant_dashboard_cubit/consultant_dashboard_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ConsultantDashboardCubit extends Cubit<ConsultantDashboardState> {
  ConsultantDashboardCubit() : super(ConsultantDashboardState());

  Future<void> fetchDashboard() async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.getConsultantDashboardUsecase();
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
