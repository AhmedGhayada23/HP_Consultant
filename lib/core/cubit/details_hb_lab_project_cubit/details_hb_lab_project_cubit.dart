import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/details_hb_lab_project_cubit/details_hb_lab_project_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class DetailsHbLabProjectCubit extends Cubit<DetailsHbLabProjectState> {
  DetailsHbLabProjectCubit() : super(DetailsHbLabProjectState());

  Future<void> fetchDetailsHbLabProject(int id) async {
    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      final data = await UseCases.getDetailsHbLabProjectUsecase(id);
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
