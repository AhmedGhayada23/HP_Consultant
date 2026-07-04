import 'package:hb/core/data/datasource/consultant_dashboard_datasource.dart';
import 'package:hb/core/data/models/consultant_dashboard_model.dart';

abstract class ConsultantDashboardRepository {
  Future<ConsultantDashboardModel> getConsultantDashboard();
}

class ConsultantDashboardRepositoryImpl implements ConsultantDashboardRepository {
  final ConsultantDashboardDataSource dataSource;

  ConsultantDashboardRepositoryImpl(this.dataSource);

  @override
  Future<ConsultantDashboardModel> getConsultantDashboard() {
    return dataSource.getConsultantDashboard();
  }
}
