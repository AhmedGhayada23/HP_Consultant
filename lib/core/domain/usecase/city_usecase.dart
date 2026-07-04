import 'package:hb/core/data/models/cities_model.dart';
import 'package:hb/core/domain/repository/city_repositiry.dart';

class CityUsecase {
  final CityRepositiry cityRepository;

  CityUsecase(this.cityRepository);
  Future<List<CitiesModel>> call(int countryId) {
    return cityRepository.getCitiesByCountry(countryId);
  }
}
