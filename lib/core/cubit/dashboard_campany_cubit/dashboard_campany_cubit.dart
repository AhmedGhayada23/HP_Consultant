import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/dashboard_campany_cubit/dashboard_campany_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class DashboardCampanyCubit extends Cubit<DashboardCampanyState> {
  DashboardCampanyCubit() : super(DashboardCampanyState());

  Future<void> fetchDashboardCampany() async {
    emit(state.copyWith(isLoading: true));
    try {
      final data = await UseCases.getDashboardUsecase.call();
      emit(state.copyWith(isLoading: false, dashboardCampanyModel: data));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
