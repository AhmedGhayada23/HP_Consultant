import 'package:hb/core/data/models/country_model.dart';

class CountryState{
  final bool isLoading;
  final String? errorMessage;
  final List<Country> countries;
  final String? selectedCountryName;
  final String? selectedCountryCode;
  final int? selectedCountryId; // ✅ تأكد من وجود هذا

  const CountryState({
    this.isLoading = false,
    this.errorMessage,
    this.countries = const [],
    this.selectedCountryName,
    this.selectedCountryCode,
    this.selectedCountryId,
  });

  CountryState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Country>? countries,
    String? selectedCountryName,
    String? selectedCountryCode,
    int? selectedCountryId,
  }) {
    return CountryState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      countries: countries ?? this.countries,
      selectedCountryName: selectedCountryName ?? this.selectedCountryName,
      selectedCountryCode: selectedCountryCode ?? this.selectedCountryCode,
      selectedCountryId: selectedCountryId ?? this.selectedCountryId,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        countries,
        selectedCountryName,
        selectedCountryCode,
        selectedCountryId,
      ];
}
