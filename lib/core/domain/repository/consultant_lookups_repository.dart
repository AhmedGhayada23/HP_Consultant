import 'package:hb/core/data/datasource/consultant_lookups_data_source.dart';
import 'package:hb/core/data/models/consultant_lookups_model.dart';

abstract class ConsultantLookupsRepository {
  Future<ConsultantLookupsModel> getConsultantLookups();
}

class ConsultantLookupsRepositoryImpl implements ConsultantLookupsRepository {
  final ConsultantLookupsDataSource dataSource;
  ConsultantLookupsRepositoryImpl(this.dataSource);

  @override
  Future<ConsultantLookupsModel> getConsultantLookups() =>
      dataSource.getConsultantLookups();
}
