import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/details_hb_lab_project_cubit/details_hb_lab_project_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

/// نفس منطق تفاصيل مشروع HB Lab، لكن لقسم الاستشاري (endpoint مختلف)
class DetailsHbLabProjectConsultantCubit
    extends Cubit<DetailsHbLabProjectState> {
  DetailsHbLabProjectConsultantCubit() : super(DetailsHbLabProjectState());

  Future<void> fetchDetailsHbLabProject(int id) async {
    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      final data =
          await UseCases.getDetailsHbLabProjectConsultantUsecase(id);
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
