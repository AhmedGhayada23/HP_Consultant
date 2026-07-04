import 'package:hb/core/data/models/consultant_dashboard_model.dart';
import 'package:hb/core/domain/repository/consultant_dashboard_repository.dart';

class ConsultantDashboardUsecase {
  final ConsultantDashboardRepository repository;

  ConsultantDashboardUsecase(this.repository);

  Future<ConsultantDashboardModel> call() {
    return repository.getConsultantDashboard();
  }
}
