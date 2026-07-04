import 'package:hb/core/data/datasource/service_types_remote_datasource.dart';
import 'package:hb/core/data/models/service_type_model.dart';

abstract class ServiceTypesRepository {
  Future<List<ServiceTypeModel>> getServiceTypes();
}

class ServiceTypesRepositoryImpl implements ServiceTypesRepository {
  final ServiceTypesRemoteDataSource remoteDataSource;

  ServiceTypesRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ServiceTypeModel>> getServiceTypes() =>
      remoteDataSource.getServiceTypes();
}
