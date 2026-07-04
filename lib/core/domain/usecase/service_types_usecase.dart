import 'package:hb/core/data/models/service_type_model.dart';
import 'package:hb/core/domain/repository/service_types_repository.dart';

class ServiceTypesUsecase {
  final ServiceTypesRepository repository;
  ServiceTypesUsecase(this.repository);

  Future<List<ServiceTypeModel>> call() => repository.getServiceTypes();
}
