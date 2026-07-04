import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/details_my_application_cubit/details_my_application_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class DetailsMyApplicationCubit extends Cubit<DetailsMyApplicationState> {
  DetailsMyApplicationCubit() : super(DetailsMyApplicationState());

  Future<void> fetchDetails(int applicationId) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.detailsMyApplicationUsecase.call(applicationId);
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
