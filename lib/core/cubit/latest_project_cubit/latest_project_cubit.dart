import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/latest_project_cubit/latest_project_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class LatestProjectCubit extends Cubit<LatestProjectState> {
  LatestProjectCubit() : super(LatestProjectState());


    Future<void> fetchLatestProject() async {
    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      final invoices = await UseCases.getLatestProjectUsecase();
      emit(state.copyWith(
        latestProjectData: invoices,
        loading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
