import 'package:hb/core/data/models/service_model.dart';
import 'package:hb/core/domain/repository/services_repository.dart';

class ServicesUsecase {
  final ServicesRepository repository;
  ServicesUsecase(this.repository);

  Future<List<ServiceModel>> call({
    String? search,
    String? status,
    int perPage = 15,
    int page = 1,
  }) =>
      repository.getServices(
        search: search,
        status: status,
        perPage: perPage,
        page: page,
      );
}

class ServiceDetailsUsecase {
  final ServicesRepository repository;
  ServiceDetailsUsecase(this.repository);

  Future<ServiceModel> call(int id) => repository.getServiceDetails(id);
}
