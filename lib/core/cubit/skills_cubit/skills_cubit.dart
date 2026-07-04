import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/skills_cubit/skills_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class SkillsCubit extends Cubit<SkillsState> {
  SkillsCubit() : super(SkillsState());

  void setSkills(List<String> skills) {
    emit(state.copyWith(selectedSkills: skills));
  }

  void fetchSkills() async {
    emit(state.copyWith(loading: true, success: null));

    try {
      final data = await UseCases.getJobAndTalentUsecase.getSkills();
      emit(state.copyWith(skills: data, loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, success: false));
    }
  }

  void clearSkills() {
    emit(state.copyWith(selectedSkills: []));
  }
}
