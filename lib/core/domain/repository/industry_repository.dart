import 'package:hb/core/data/datasource/industry_remote_data_source.dart';
import 'package:hb/core/data/models/industry_model.dart';

abstract class IndustryRepository {
  Future<List<IndustryModel>> getIndustries();
}

class IndustryRepositoryImpl implements IndustryRepository {
  final IndustryRemoteDataSource dataSource;

  IndustryRepositoryImpl(this.dataSource);

  @override
  Future<List<IndustryModel>> getIndustries() => dataSource.getIndustries();
}
