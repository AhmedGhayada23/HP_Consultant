import 'package:hb/core/data/datasource/country_remote_data_source.dart';
import 'package:hb/core/data/models/country_model.dart';

abstract class CountryRepository {
  Future<List<Country>> fetchCountryCodes();
}

class CountryRepositoryImpl implements CountryRepository {
  final CountryRemoteDataSource remoteDataSource;

  CountryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Country>> fetchCountryCodes() {
    return remoteDataSource.getCountryCodes();
  }
}
