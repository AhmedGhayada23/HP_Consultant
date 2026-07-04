import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/details_job_talent_cubit/details_job_talent_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class DetailsJobTalentCubit extends Cubit<DetailsJobTalentState> {
  DetailsJobTalentCubit() : super(DetailsJobTalentState());

  Future<void> fetchDetailsJobTalent() async {
    emit(state.copyWith(loading: true));

    try {
      final data = await UseCases.getDetailsJobTalentUsecase();
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
