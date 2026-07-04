import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/country_cubit/country_state.dart';
import 'package:hb/core/data/models/country_model.dart';
import 'package:hb/core/service_locator/usecases.dart';

class CountryCubit extends Cubit<CountryState> {
  CountryCubit() : super(CountryState());



  void selectCountryByCode(String countryCode) {
    emit(
      state.copyWith(
        selectedCountryCode: countryCode,
      ),
    );
    }

  /// Select a country by name
  void selectCountryByName(String countryName) {
    if (countryName.isEmpty) return;
    final country = _findCountryByName(countryName);
    emit(state.copyWith(
      selectedCountryName: countryName,
      selectedCountryId: country?.id,
      selectedCountryCode: country?.phoneCode,
    ));
  }

  /// Fetch countries from API
  Future<void> fetchCountries() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final countries = await UseCases.getCountryUsecase.call();
      emit(state.copyWith(isLoading: false, countries: countries, errorMessage: null));
      // Re-apply pending selection now that the list is available
      final pendingName = state.selectedCountryName;
      if (pendingName != null && pendingName.isNotEmpty) {
        selectCountryByName(pendingName);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// Helper: Find country by name
  Country? _findCountryByName(String name) {
    try {
      return state.countries.firstWhere((country) => country.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Reset to initial state
  void reset() {
    emit(CountryState());
  }
}
