import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/industry_cubit/industry_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class IndustryCubit extends Cubit<IndustryState> {
  IndustryCubit() : super(IndustryState()) {
    fetchIndustries();
  }

  Future<void> fetchIndustries() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final industries = await UseCases.getIndustryUsecase();
      emit(state.copyWith(isLoading: false, industries: industries));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
