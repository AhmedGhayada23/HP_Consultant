import 'package:hb/core/data/models/country_model.dart';
import 'package:hb/core/domain/repository/country_repository.dart';

class CountryUsecase {
  final CountryRepository repository;

  CountryUsecase(this.repository);


  Future<List<Country>> call() {
    return repository.fetchCountryCodes();
  }
}
