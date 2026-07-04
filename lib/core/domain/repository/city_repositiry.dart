import 'package:hb/core/data/datasource/city_remote_data_source.dart';
import 'package:hb/core/data/models/cities_model.dart';

abstract class CityRepositiry {
  Future<List<CitiesModel>> getCitiesByCountry(int countryId);
}

class CityRepositoryImpl implements CityRepositiry {
  final CityRemoteDataSource dataSource;

  CityRepositoryImpl(this.dataSource);

  @override
  Future<List<CitiesModel>> getCitiesByCountry(int countryId) {
    return dataSource.getCitiesByCountry(countryId);
  }
}
