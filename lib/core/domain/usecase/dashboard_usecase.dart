import 'package:hb/core/data/models/dashboard_campany_model.dart';
import 'package:hb/core/domain/repository/dashboard_repository.dart';

class DashboardUsecase {
  final DashboardRepository repository;
  DashboardUsecase(this.repository);

  Future<DashboardCampanyModel> call() async {
    return await repository.getDashboardCampany();
  }
}
