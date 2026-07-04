import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/city_cubit/city_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class CityCubit extends Cubit<CityState> {
  CityCubit() : super(CityState());

  /// Select a city by name
  void selectCityByName(String cityName) {
    if (cityName.isEmpty) return;
    // Set name immediately so the dropdown shows it before list loads
    int? cityId;
    try {
      cityId = state.cities.firstWhere((c) => c.name == cityName).id;
    } catch (_) {}
    emit(state.copyWith(
      selectedCityName: cityName,
      selectedCityId: cityId,
    ));
  }

  Future<void> fetchCities(int countryId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final cities = await UseCases.getCityUsecase.call(countryId);
      emit(state.copyWith(isLoading: false, cities: cities));
      // Re-apply pending selection now that the list is available
      final pendingName = state.selectedCityName;
      if (pendingName != null && pendingName.isNotEmpty) {
        selectCityByName(pendingName);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(CityState());
  }
}
