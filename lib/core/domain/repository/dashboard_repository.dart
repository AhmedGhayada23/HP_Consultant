import 'package:hb/core/data/datasource/dashboard_remote_data_source.dart';
import 'package:hb/core/data/models/dashboard_campany_model.dart';

abstract class DashboardRepository {
  Future<DashboardCampanyModel> getDashboardCampany();
}

class DashboardRepositoryImpl extends DashboardRepository {
  final DashboardRemoteDataSource dataSource;
  DashboardRepositoryImpl(this.dataSource);

  @override
  Future<DashboardCampanyModel> getDashboardCampany() {
    return dataSource.getDashboardCampany();
  }
}
