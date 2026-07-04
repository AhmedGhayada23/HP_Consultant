import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/details_consultant_project_cubit/details_consultant_project_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class DetailsConsultantProjectCubit extends Cubit<DetailsConsultantProjectState> {
  DetailsConsultantProjectCubit() : super(DetailsConsultantProjectState());





  Future<void> fetchDetailsConsultantProject(int id) async {
    emit(state.copyWith(loading: true));

    try {
      final data = await UseCases.getDetailsConsultantProjectUsecase(id);
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }}
