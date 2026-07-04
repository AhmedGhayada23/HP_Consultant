import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/consultant_lookups_cubit/consultant_lookups_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ConsultantLookupsCubit extends Cubit<ConsultantLookupsState> {
  ConsultantLookupsCubit() : super(const ConsultantLookupsState());

  Future<void> fetchLookups() async {
    if (state.professions.isNotEmpty && state.skills.isNotEmpty) return;
    emit(state.copyWith(loading: true));
    try {
      final data = await UseCases.getConsultantLookupsUsecase.call();
      emit(state.copyWith(
        loading: false,
        jobCategories: data.jobCategories,
        professions: data.professions,
        skills: data.skills,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
