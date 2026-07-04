import 'package:hb/core/data/datasource/details_application_data_source.dart';
import 'package:hb/core/data/models/details_application_model.dart';

abstract class DetailsApplicationRepository {
  Future<DetailsApplicationModel> getDetailsApplication(int applicationId);
}

class DetailsApplicationRepositoryImpl extends DetailsApplicationRepository {
  final DetailsApplicationDataSource dataSource;

  DetailsApplicationRepositoryImpl(this.dataSource);
  @override
  Future<DetailsApplicationModel> getDetailsApplication(int applicationId) {
    return dataSource.getDetailsApplication(applicationId);
  }
}
