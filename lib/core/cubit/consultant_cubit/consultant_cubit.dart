// lib/featuer/counsultants_directory/presentation/cubit/consultant_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/consultant_cubit/consultant_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ConsultantCubit extends Cubit<ConsultantState> {
  ConsultantCubit() : super(ConsultantState(loading: false));

  Future<void> fetchConsultants() async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.getConsultantUsecase(
        search: state.search,
        category: state.selectedCategory,
        minBudget: state.minBudget,
        maxBudget: state.maxBudget,
        availability: state.availability,
      );
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> fetchCategories() async {
    emit(state.copyWith(categoriesLoading: true));
    try {
      final categories = await UseCases.getConsultantCategoriesUsecase();
      emit(state.copyWith(categories: categories, categoriesLoading: false));
    } catch (_) {
      emit(state.copyWith(categoriesLoading: false));
    }
  }

  void search(String value) {
    emit(state.copyWith(search: value));
    fetchConsultants();
  }

  void setCategory(String value) {
    emit(state.copyWith(selectedCategory: value));
    fetchConsultants();
  }

  void setAvailability(String value) {
    emit(state.copyWith(availability: value));
    fetchConsultants();
  }

  void setBudgetRange(String min, String max) {
    emit(state.copyWith(minBudget: min, maxBudget: max));
    fetchConsultants();
  }
}
