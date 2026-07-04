import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/details_application_cubit/details_application_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class DetailsApplicationCubit extends Cubit<DetailsApplicationState>{
  DetailsApplicationCubit() : super (DetailsApplicationState());


   Future<void> fetchDetailsApplication(int applicationId) async {
    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      final data = await UseCases.getDetailsApplicationUsecase(applicationId);
      emit(state.copyWith(data:data,loading: false ));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
