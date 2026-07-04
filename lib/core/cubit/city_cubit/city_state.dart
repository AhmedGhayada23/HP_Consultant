import 'package:hb/core/data/models/cities_model.dart';

class CityState {
  final bool isLoading;
  final List<CitiesModel> cities;
  final String? errorMessage;
  final String? selectedCityName;
  final int? selectedCityId;
  CityState({
    this.isLoading = false,
    this.cities = const [],
    this.errorMessage,
    this.selectedCityName,
    this.selectedCityId,
  });

  CityState copyWith({
    bool? isLoading,
    List<CitiesModel>? cities,
    String? errorMessage,
    String? selectedCityName,
    int? selectedCityId,
  }) {
    return CityState(
      isLoading: isLoading ?? this.isLoading,
      cities: cities ?? this.cities,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCityName: selectedCityName ?? this.selectedCityName,
      selectedCityId: selectedCityId ?? this.selectedCityId,
    );
  }
}
