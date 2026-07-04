import 'package:hb/core/data/datasource/details_my_application_data_source.dart';
import 'package:hb/core/data/models/details_my_application_model.dart';

abstract class DetailsMyApplicationRepository {
  Future<DetailsMyApplicationModel> getDetails(int applicationId);
}

class DetailsMyApplicationRepositoryImpl implements DetailsMyApplicationRepository {
  final DetailsMyApplicationDataSource dataSource;
  DetailsMyApplicationRepositoryImpl(this.dataSource);

  @override
  Future<DetailsMyApplicationModel> getDetails(int applicationId) {
    return dataSource.getDetails(applicationId);
  }
}
