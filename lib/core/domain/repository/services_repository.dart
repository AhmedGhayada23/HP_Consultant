import 'package:hb/core/data/datasource/services_remote_datasource.dart';
import 'package:hb/core/data/models/service_model.dart';

abstract class ServicesRepository {
  Future<List<ServiceModel>> getServices({
    String? search,
    String? status,
    int perPage,
    int page,
  });
  Future<ServiceModel> getServiceDetails(int id);
}

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDataSource remoteDataSource;

  ServicesRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ServiceModel>> getServices({
    String? search,
    String? status,
    int perPage = 15,
    int page = 1,
  }) =>
      remoteDataSource.getServices(
        search: search,
        status: status,
        perPage: perPage,
        page: page,
      );

  @override
  Future<ServiceModel> getServiceDetails(int id) =>
      remoteDataSource.getServiceDetails(id);
}
