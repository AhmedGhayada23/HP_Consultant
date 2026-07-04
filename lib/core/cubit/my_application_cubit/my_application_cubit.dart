// lib/featuer/career_opportunities/presentation/cubit/my_application_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/my_application_cubit/my_application_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class MyApplicationCubit extends Cubit<MyApplicationState> {

  MyApplicationCubit() : super(MyApplicationState(loading: false));

  Future<void> fetchMyApplications() async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.getMyApplicationUsecase();
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
